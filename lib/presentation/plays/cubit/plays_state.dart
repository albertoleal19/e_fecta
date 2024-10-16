part of 'plays_cubit.dart';

abstract class PlaysState with EquatableMixin {
  const PlaysState({
    // required this.selectedHourses,
    // required this.step,
    required this.ticketsCount,
    required this.tokensCount,
  });
  // final List<int> selectedHourses;
  // final int step;
  final int ticketsCount;
  final int tokensCount;
}

abstract class PlaysChangeState extends PlaysState {
  const PlaysChangeState({
    required this.selectedHourses,
    required this.isValidPlay,
    required int ticketsCount,
    required int tokensCount,
  }) : super(ticketsCount: ticketsCount, tokensCount: tokensCount);

  final List<List<int>> selectedHourses;
  final bool isValidPlay;
}

class PlaysInitial extends PlaysChangeState with EquatableMixin {
  PlaysInitial()
      : super(
          selectedHourses: <List<int>>[],
          isValidPlay: false,
          tokensCount: 0,
          ticketsCount: 0,
        );

  @override
  List<Object?> get props => [
        selectedHourses,
        isValidPlay,
        tokensCount,
        ticketsCount,
      ];
}

// class PlaysStepChanged extends PlaysChangeState {
//   PlaysStepChanged({
//     required List<List<int>> selectedHourses,
//     required int step,
//     required int ticketsCount,
//     required int tokenCounts,
//   }) : super(
//           selectedHourses: selectedHourses,
//           step: step,
//           tokensCount: tokenCounts,
//           ticketsCount: ticketsCount,
//         );

//   @override
//   List<Object?> get props => [
//         selectedHourses,
//         step,
//         tokensCount,
//         ticketsCount,
//       ];
// }

class PlaysSelectionChanged extends PlaysChangeState {
  PlaysSelectionChanged({
    required List<List<int>> selectedHourses,
    required int ticketsCount,
    required int tokenCounts,
    required bool isValidPlay,
  }) : super(
          selectedHourses: selectedHourses,
          isValidPlay: isValidPlay,
          tokensCount: tokenCounts,
          ticketsCount: ticketsCount,
        );

  @override
  List<Object?> get props => [
        selectedHourses,
        tokensCount,
        ticketsCount,
        isValidPlay,
      ];
}

class PlaysSummary extends PlaysState {
  const PlaysSummary({
    required this.tickets,
    required int ticketsCount,
    required int tokensCount,
  }) : super(
          ticketsCount: ticketsCount,
          tokensCount: tokensCount,
        );

  final List<List<int>> tickets;

  @override
  List<Object?> get props => [
        tickets,
        tokensCount,
        ticketsCount,
      ];
}

class PlaysFinished extends PlaysState {
  const PlaysFinished({
    required int ticketsCount,
    required int tokensCount,
  }) : super(
          ticketsCount: ticketsCount,
          tokensCount: tokensCount,
        );

  @override
  List<Object?> get props => [
        tokensCount,
        ticketsCount,
      ];
}
