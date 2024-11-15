import 'package:e_fecta/data/race_repository.dart';
import 'package:e_fecta/data/ticket_repository.dart';
import 'package:e_fecta/data/user_repository.dart';
import 'package:e_fecta/domain/entities/raceday.dart';
import 'package:e_fecta/domain/entities/ticket.dart';
import 'package:e_fecta/domain/entities/user.dart';
import 'package:e_fecta/domain/repositories/race_repository.dart';
import 'package:e_fecta/domain/repositories/ticket_repository.dart';
import 'package:e_fecta/domain/repositories/user_repository.dart';
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

  Future<void> setTrack(String trackId) async {
    if (_trackId != trackId) {
      _trackId = trackId;
      _loadConfigurationInfo();
    }
  }

  void togglePlaysSelections() {
    _playSelectionpOpened = !_playSelectionpOpened;
    emit(TogglePlaysSelectionState(_playSelectionpOpened));
  }

  Future<void> getTicketsForRaceday() async {
    if (_racedayInfo != null) {
      final tickets = await ticketRepository.getTickets(_racedayInfo!.id);
      emit(PlaysTicketsLoaded(tickets: tickets));
    }
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
      // playSelection[race].clear();
      // playSelection[race].addAll(optionSelected);
      playSelection = List.from(pleriminarySelection);

      // ticketsCount = playSelection
      //     .map((e) => e.length)
      //     .reduce((value, element) => value * element);

      ticketsCount = preliminaryTicketsCount;

      tokensCount = (_racedayInfo?.tokensPerTicket ?? 1) * ticketsCount;

      emit(
        PlaysSelectionChanged(
          selectedHourses: _getSelectionForStates(),
          isValidPlay: _isValidPlay(),
          // step: step,
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
    await getTicketsForRaceday();
  }

  // Future<void> nextStep() async {
  //   step++;
  //   print('Step: $step');
  //   switch (step) {
  //     case 6:
  //       calcultaSummary();
  //       break;
  //     case 7:
  //       sealTicket();
  //       break;
  //     default:
  //       emit(
  //         PlaysStepChanged(
  //           selectedHourses: playSelection.map((e) => e.toList()).toList(),
  //           step: step,
  //           tokenCounts: tokensCount,
  //           ticketsCount: ticketsCount,
  //         ),
  //       );
  //       break;
  //   }
  // }

  // Future<void> previousStep() async {
  //   if (step > 0) {
  //     step--;
  //     emit(
  //       PlaysStepChanged(
  //         selectedHourses:
  //             step < 6 ? playSelection.map((e) => e.toList()).toList() : [],
  //         step: step,
  //         tokenCounts: tokensCount,
  //         ticketsCount: ticketsCount,
  //       ),
  //     );
  //   }
  // }

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

  Future<void> _loadConfigurationInfo() async {
    final authUser = await userRepository.getAuthenticatedUser();
    if (authUser == null) {
      //emit(error to handle auth);
    } else {
      _currentUser = authUser;
    }
    _racedayInfo = await raceRepository.getRecedayInfo(_trackId);
    if (_racedayInfo != null) {
      emit(
        PlaysRacesConfigLoaded(
          racesOptions: _racedayInfo!.racesOptions,
          ticketsCount: ticketsCount,
          tokenCounts: tokensCount,
          tokensPerTicket: _racedayInfo?.tokensPerTicket ?? 1,
          closingTime: _racedayInfo!.closingTime,
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
}
