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
    required this.tokensPerTicket,
    required this.closingTime,
    required int ticketsCount,
    required int tokensCount,
  }) : super(
          ticketsCount: ticketsCount,
          tokensCount: tokensCount,
        );

  final List<List<int>> selectedHourses;
  final bool isValidPlay;
  final bool exceededTokens;
  final int tokensPerTicket;
  final DateTime closingTime;
}

class TogglePlaysSelectionState extends PlaysState {
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

class PlaysInitial extends PlaysState {
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

class PlaysRacesConfigLoaded extends PlaysState {
  PlaysRacesConfigLoaded({
    required this.racesOptions,
    required this.closingTime,
    required this.tokensPerTicket,
    required int ticketsCount,
    required int tokenCounts,
  }) : super(
          tokensCount: tokenCounts,
          ticketsCount: ticketsCount,
        );

  final List<List<int>> racesOptions;
  final DateTime closingTime;
  final int tokensPerTicket;

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
    required DateTime closingTime,
    required int tokensPerTicket,
  }) : super(
          selectedHourses: selectedHourses,
          isValidPlay: isValidPlay,
          tokensCount: tokenCounts,
          ticketsCount: ticketsCount,
          exceededTokens: exceededTokens,
          tokensPerTicket: tokensPerTicket,
          closingTime: closingTime,
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
    required this.newBalance,
  }) : super(
          tokensCount: 0,
          ticketsCount: 0,
        );

  final int newBalance;

  @override
  List<Object?> get props => [
        tokensCount,
        ticketsCount,
        newBalance,
      ];
}

class PlaysNotAvailable extends PlaysState {
  const PlaysNotAvailable()
      : super(
          ticketsCount: 0,
          tokensCount: 0,
        );

  @override
  List<Object?> get props => [
        tokensCount,
        ticketsCount,
      ];
}
