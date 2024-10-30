part of 'admin_cubit.dart';

class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object> get props => [];
}

class AdminInitial extends AdminState {}

class AdminInputErrorState extends AdminState {}

class AdminConfiguredRacedaysLoaded extends AdminState {
  const AdminConfiguredRacedaysLoaded({required this.racedays});

  final List<Raceday> racedays;

  @override
  List<Object> get props => [racedays];
}
