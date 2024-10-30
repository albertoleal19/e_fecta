part of 'plays_cubit.dart';

abstract class PlaysState with EquatableMixin {
  const PlaysState({
    required this.ticketsCount,
    required this.tokensCount,
  });

  final int ticketsCount;
  final int tokensCount;
}

abstract class PlaysChangeState extends PlaysState {
  const PlaysChangeState({
    required this.selectedHourses,
    required this.isValidPlay,
    required this.exceededTokens,
    required int ticketsCount,
    required int tokensCount,
  }) : super(
          ticketsCount: ticketsCount,
          tokensCount: tokensCount,
        );

  final List<List<int>> selectedHourses;
  final bool isValidPlay;
  final bool exceededTokens;
}

class TogglePlaysSelectionState extends PlaysState with EquatableMixin {
  TogglePlaysSelectionState(this.opened)
      : super(
          tokensCount: 0,
          ticketsCount: 0,
        );

  final bool opened;

  @override
  List<Object?> get props => [
        opened,
        tokensCount,
        ticketsCount,
      ];
}

class PlaysInitial extends PlaysState with EquatableMixin {
  PlaysInitial()
      : super(
          tokensCount: 0,
          ticketsCount: 0,
        );

  @override
  List<Object?> get props => [
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

class PlaysRacesConfigLoaded extends PlaysState {
  PlaysRacesConfigLoaded({
    required this.racesOptions,
    required int ticketsCount,
    required int tokenCounts,
  }) : super(
          tokensCount: tokenCounts,
          ticketsCount: ticketsCount,
        );

  final List<List<int>> racesOptions;

  @override
  List<Object?> get props => [
        racesOptions,
        tokensCount,
        ticketsCount,
      ];
}

class PlaysSelectionChanged extends PlaysChangeState {
  PlaysSelectionChanged({
    required List<List<int>> selectedHourses,
    required int ticketsCount,
    required int tokenCounts,
    required bool isValidPlay,
    required bool exceededTokens,
  }) : super(
          selectedHourses: selectedHourses,
          isValidPlay: isValidPlay,
          tokensCount: tokenCounts,
          ticketsCount: ticketsCount,
          exceededTokens: exceededTokens,
        );

  @override
  List<Object?> get props => [
        selectedHourses,
        tokensCount,
        ticketsCount,
        isValidPlay,
        exceededTokens,
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
