import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'plays_state.dart';

class PlaysCubit extends Cubit<PlaysState> {
  PlaysCubit() : super(PlaysInitial());

  List<Set<int>> playSelection = ([{}, {}, {}, {}, {}, {}]);
  int ticketsCount = 0;
  int tokensCount = 0;

  bool isValidPlay() {
    return !playSelection.any((element) => element.isEmpty);
  }

  List<List<int>> getSelectionForStates() {
    return playSelection.map((e) => e.toList()).toList();
  }

  Future<void> setSelection({
    required List<int> optionSelected,
    required int race,
  }) async {
    playSelection[race].clear();
    playSelection[race].addAll(optionSelected);

    ticketsCount = playSelection
        .map((e) => e.length)
        .reduce((value, element) => value * element);

    tokensCount = 2 * ticketsCount;

    print(playSelection);
    print('---------------------');
    print(
      'Tickets:  $ticketsCount  --- Tokens: $tokensCount --- Race: $race -- ValidPlay: ${isValidPlay()}',
    );

    emit(
      PlaysSelectionChanged(
        selectedHourses: getSelectionForStates(),
        isValidPlay: isValidPlay(),
        // step: step,
        tokenCounts: tokensCount,
        ticketsCount: ticketsCount,
      ),
    );
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
        selectedHourses: getSelectionForStates(),
        isValidPlay: isValidPlay(),
        tokenCounts: tokensCount,
        ticketsCount: ticketsCount,
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

    emit(
      PlaysFinished(
        ticketsCount: ticketsCount,
        tokensCount: tokensCount,
      ),
    );
    playSelection = [{}, {}, {}, {}, {}, {}];
    tokensCount = 0;
    ticketsCount = 0;
    emit(
      PlaysInitial(),
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
