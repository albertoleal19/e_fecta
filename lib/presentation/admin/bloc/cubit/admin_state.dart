part of 'admin_cubit.dart';

enum AdminSection { newTicket, editTicket }

class AdminState {
  const AdminState();
}

class AdminInitial extends AdminState {}

class AdminInputErrorState extends AdminState {
  AdminInputErrorState({this.message = ''});
  final String message;
}

class AdminNewRacedaySectionShownState extends AdminState {
  const AdminNewRacedaySectionShownState({
    required this.raceday,
  });

  final Raceday raceday;
}

class AdminEditRacedaySectionShownState extends AdminState {
  const AdminEditRacedaySectionShownState({
    required this.raceday,
  });

  final Raceday raceday;
  // @override
  // List<Object> get props => [optionsToDisplay];
}

class AdminSetWinnersSectionShownState extends AdminState {
  const AdminSetWinnersSectionShownState({
    required this.raceday,
    required this.race,
    this.isLoading = false,
  });

  final Raceday raceday;
  final int race;
  final bool isLoading;
  // @override
  // List<Object> get props => [optionsToDisplay];
}

class AdminConfiguredRacedaysLoaded extends AdminState {
  const AdminConfiguredRacedaysLoaded({required this.racedays});

  final List<Raceday> racedays;

  // @override
  // List<Object> get props => [racedays];
}
