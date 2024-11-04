import 'package:e_fecta/data/race_repository.dart';
import 'package:e_fecta/data/user_repository.dart';
import 'package:e_fecta/domain/entities/raceday.dart';
import 'package:e_fecta/domain/entities/user.dart';
import 'package:e_fecta/domain/repositories/race_repository.dart';
import 'package:e_fecta/domain/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'plays_state.dart';

class PlaysCubit extends Cubit<PlaysState> {
  PlaysCubit() : super(PlaysInitial());

  List<Set<int>> playSelection = ([{}, {}, {}, {}, {}, {}]);
  int ticketsCount = 0;
  int tokensCount = 0;

  late User _currentUser;
  late Raceday _racedayInfo;

  final UserRepository userRepository = UserRepositoryImpl();
  final RaceRepository receRepository = RaceRepositoryImpl();

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

      tokensCount = 2 * ticketsCount;

      emit(
        PlaysSelectionChanged(
          selectedHourses: _getSelectionForStates(),
          isValidPlay: _isValidPlay(),
          // step: step,
          tokenCounts: tokensCount,
          ticketsCount: ticketsCount,
          exceededTokens: false,
        ),
      );
    }

    print(playSelection);
    print('---------------------');
    print(
      'Tickets:  $ticketsCount  --- Tokens: $tokensCount --- Race: $race -- ValidPlay: ${_isValidPlay()}',
    );
  }

  Future<void> getRacedayConfig() async {
    _loadConfigurationInfo();
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
    print('------------- Send tickets to server --------------');

    playSelection = [{}, {}, {}, {}, {}, {}];
    tokensCount = 0;
    ticketsCount = 0;
    _playSelectionpOpened = false;
    emit(
      TogglePlaysSelectionState(_playSelectionpOpened),
    );
  }

  void _loadConfigurationInfo() async {
    _currentUser = await userRepository.getUser();
    _racedayInfo = await receRepository.getRecedayInfo(_trackId);
    emit(
      PlaysRacesConfigLoaded(
        racesOptions: <List<int>>[],

        ///_racedayInfo.racesOptions,
        ticketsCount: ticketsCount,
        tokenCounts: tokensCount,
      ),
    );
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
