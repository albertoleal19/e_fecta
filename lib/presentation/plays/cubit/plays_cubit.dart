import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_fecta/data/race_repository.dart';
import 'package:e_fecta/data/ticket_repository.dart';
import 'package:e_fecta/data/user_repository.dart';
import 'package:e_fecta/domain/entities/raceday.dart';
import 'package:e_fecta/domain/entities/ticket.dart';
import 'package:e_fecta/domain/entities/user.dart';
import 'package:e_fecta/domain/repositories/race_repository.dart';
import 'package:e_fecta/domain/repositories/ticket_repository.dart';
import 'package:e_fecta/domain/repositories/user_repository.dart';
import 'package:e_fecta/presentation/plays/tickets_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'plays_state.dart';

class PlaysCubit extends Cubit<PlaysState> {
  PlaysCubit() : super(PlaysInitial());

  List<Set<int>> playSelection = ([{}, {}, {}, {}, {}, {}]);
  int ticketsCount = 0;
  int tokensCount = 0;

  late User _currentUser;
  Raceday? _racedayInfo;
  List<Raceday> _racedays = [];
  int _selectedRaceIndex = 0;

  final UserRepository userRepository = UserRepositoryImpl();
  final RaceRepository raceRepository = RaceRepositoryImpl();
  final TicketRepository ticketRepository = TicketRepositoryImpl();

  bool _playSelectionpOpened = false;
  String _trackId = '';

  bool _isValidPlay() {
    return !playSelection.any((element) => element.isEmpty);
  }

  List<List<int>> _getSelectionForStates() {
    return playSelection.map((e) => e.toList()).toList();
  }

  Future<void> _loadPastRacedays() async {
    try {
      _racedays = await raceRepository.getAllPastRacedaysForTrack(_trackId);
      if (_racedayInfo != null) {
        _racedays = [_racedayInfo!, ..._racedays];
      }

      _selectedRaceIndex = 0;
      emit(
        PlaysResultsRacedays(
          racedays: _racedays,
          selectedRacedayIndex: _selectedRaceIndex,
        ),
      );
    } catch (e) {
      print('Error loading past racedays: ${e.toString()}');
    }
  }

  Future<void> _loadConfigurationInfo() async {
    final authUser = await userRepository.getAuthenticatedUser();
    if (authUser == null) {
      //emit(error to handle auth);
    } else {
      _currentUser = authUser;
    }
    _racedayInfo = await raceRepository.getBetAvailableRaceday(_trackId);
    if (_racedayInfo != null) {
      emit(
        PlaysRacesConfigLoaded(
          racesOptions: _racedayInfo!.racesOptions,
          ticketsCount: ticketsCount,
          tokenCounts: tokensCount,
          tokensPerTicket: _racedayInfo?.tokensPerTicket ?? 1,
          closingTime: _racedayInfo!.closingTime,
          isPlayConfigOpened: _playSelectionpOpened,
        ),
      );
    } else {
      emit(const PlaysNotAvailable());
    }
  }

  List<List<int>> _generateCombinations(List<List<int>> selectedOptions) {
    // base case: if list is empty, empty list returned
    if (selectedOptions.isEmpty) {
      return [[]];
    }

    // Take first list
    List<int> firstList = selectedOptions.first;

    // Generate combination for remaining lists
    List<List<int>> remainingCombinations =
        _generateCombinations(selectedOptions.sublist(1));

    // Crear las combinaciones tomando un elemento de la primera lista
    List<List<int>> result = [];
    for (var element in firstList) {
      for (var combination in remainingCombinations) {
        result.add([element, ...combination]);
      }
    }

    return result;
  }

  Future<void> _getRacedayTickets(String racedayId) async {
    final ticketsRef = FirebaseFirestore.instance
        .collection('tickets')
        .where('racedayId', isEqualTo: racedayId)
        .orderBy('totalPts', descending: true)
        .orderBy('timestamp', descending: true);

    final collection = ticketsRef.withConverter<TicketModel>(
      fromFirestore: (snapshot, options) {
        final ticket = snapshot.data()!;
        final List<int> horseOptions = List<int>.empty(growable: true);
        for (var i = 1; i < 7; i++) {
          horseOptions.add(ticket['race$i'] as int);
        }
        final List<int> points = List<int>.empty(growable: true);
        for (var i = 1; i < 7; i++) {
          points.add(ticket['pts$i'] as int);
        }
        return TicketModel(
          number: snapshot.id,
          racedayId: ticket['racedayId'],
          selectedOptions: horseOptions,
          username: ticket['username'],
          points: points,
          totalPts: ticket['totalPts'],
          position: 1,
        );
      },
      toFirestore: (value, options) {
        return {};
      },
    );
    final ticketsCount = await ticketRepository.getSummary(racedayId);
    emit(
      PlaysTicketsDisplay(
        ticketsRef: collection,
        ticketsCount: ticketsCount,
      ),
    );
  }

  Future<void> selectRacedayForResults(int racedayIndex) async {
    _selectedRaceIndex = racedayIndex;
    emit(
      PlaysResultsRacedays(
        racedays: _racedays,
        selectedRacedayIndex: _selectedRaceIndex,
      ),
    );
    _getRacedayTickets(_racedays[_selectedRaceIndex].id);
  }

  void processInitialLoading() async {
    await _loadConfigurationInfo();
    await _loadPastRacedays();
    if (_racedays.isNotEmpty) {
      await _getRacedayTickets(_racedays.first.id);
    }
  }

  Future<void> setTrack(String trackId) async {
    if (_trackId != trackId) {
      _trackId = trackId;
      processInitialLoading();
    }
  }

  void togglePlaysSelections() {
    _playSelectionpOpened = !_playSelectionpOpened;
    emit(TogglePlaysSelectionState(_playSelectionpOpened));
  }

  Future<void> setSelection({
    required List<int> optionSelected,
    required int race,
  }) async {
    final List<Set<int>> pleriminarySelection = List.from(playSelection);

    pleriminarySelection[race].clear();
    pleriminarySelection[race].addAll(optionSelected);

    final preliminaryTicketsCount = pleriminarySelection
        .map((e) => e.length)
        .reduce((value, element) => value * element);

    if (preliminaryTicketsCount * 2 > _currentUser.tokens) {
      emit(
        PlaysSelectionChanged(
          selectedHourses: _getSelectionForStates(),
          isValidPlay: _isValidPlay(),
          tokenCounts: preliminaryTicketsCount * 2,
          ticketsCount: preliminaryTicketsCount,
          exceededTokens: true,
          tokensPerTicket: _racedayInfo?.tokensPerTicket ?? 1,
          closingTime: _racedayInfo!.closingTime,
        ),
      );
    } else {
      playSelection = List.from(pleriminarySelection);

      ticketsCount = preliminaryTicketsCount;

      tokensCount = (_racedayInfo?.tokensPerTicket ?? 1) * ticketsCount;

      emit(
        PlaysSelectionChanged(
          selectedHourses: _getSelectionForStates(),
          isValidPlay: _isValidPlay(),
          tokenCounts: tokensCount,
          ticketsCount: ticketsCount,
          exceededTokens: false,
          tokensPerTicket: _racedayInfo?.tokensPerTicket ?? 1,
          closingTime: _racedayInfo!.closingTime,
        ),
      );
    }
  }

  Future<void> getRacedayConfig() async {
    await _loadConfigurationInfo();
  }

  Future<void> modifySelection() async {
    emit(
      PlaysSelectionChanged(
        selectedHourses: _getSelectionForStates(),
        isValidPlay: _isValidPlay(),
        tokenCounts: tokensCount,
        ticketsCount: ticketsCount,
        exceededTokens: false,
        tokensPerTicket: _racedayInfo?.tokensPerTicket ?? 1,
        closingTime: _racedayInfo!.closingTime,
      ),
    );
  }

  Future<void> calcultaSummary() async {
    var combinaciones =
        _generateCombinations(playSelection.map((e) => e.toList()).toList());

    print('------------- Combinaciones --------------');
    for (var element in combinaciones) {
      print(element);
    }

    emit(
      PlaysSummary(
        tickets: combinaciones,
        ticketsCount: ticketsCount,
        tokensCount: tokensCount,
      ),
    );
  }

  Future<void> sealTicket() async {
    if (state is PlaysSummary && _racedayInfo != null) {
      final List<Ticket> tickets = (state as PlaysSummary)
          .tickets
          .map(
            (ticketOptions) => Ticket(
              racedayId: _racedayInfo?.id ?? '',
              selectedOptions: ticketOptions,
              username: _currentUser.username,
            ),
          )
          .toList();
      debugPrint('------------- Send tickets to server --------------');
      final newBalace = await ticketRepository.sealTickets(
        tickets,
        _currentUser,
        _racedayInfo?.tokensPerTicket ?? 1,
      );

      playSelection = [{}, {}, {}, {}, {}, {}];
      tokensCount = 0;
      ticketsCount = 0;
      _playSelectionpOpened = false;
      if (newBalace != null) {
        emit(PlaysFinished(newBalance: newBalace));
      }

      emit(TogglePlaysSelectionState(_playSelectionpOpened));
      // emit(PlaysInitial());
    } else {
      debugPrint('Error: Previous state is not PlaysSummary');
    }
  }
}
