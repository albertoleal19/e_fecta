import 'package:e_fecta/data/race_repository.dart';
import 'package:e_fecta/data/ticket_repository.dart';
import 'package:e_fecta/domain/entities/raceday.dart';
import 'package:e_fecta/domain/repositories/race_repository.dart';
import 'package:e_fecta/domain/repositories/ticket_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit() : super(AdminInitial());

  final RaceRepository raceRepository = RaceRepositoryImpl();
  final TicketRepository ticketRepository = TicketRepositoryImpl();

  String _trackId = '';

  final List<Set<int>> _raceOptions = ([{}, {}, {}, {}, {}, {}]);
  // ignore: prefer_final_fields
  List<Raceday> _racedays = [];

  Future<void> setTrack(String trackId) async {
    if (_trackId != trackId) {
      _trackId = trackId;
      loadRacedaysInfo();
    }
  }

  Future<void> setSelection({
    required List<int> optionSelected,
    required int race,
  }) async {
    _raceOptions[race].clear();
    _raceOptions[race].addAll(optionSelected);
  }

  Future<void> createRaceday({
    required Raceday raceday,
    required int tokensPerTicket,
    required DateTime closingTime,
  }) async {
    final racedayToCreate = Raceday(
      closingTime: closingTime,
      trackId: _trackId,
      racesOptions: _raceOptions.map((e) => e.toList()).toList(),
      winners: [],
      isOpen: false, // to make sure it is closed for betting
      tokensPerTicket: tokensPerTicket,
      prizePlaces: raceday.prizePlaces,
    );
    if (_raceOptions.any((element) => element.length < 3)) {
      emit(
        AdminInputErrorState(
            message: 'Se deben selecciones al menos 3 caballos por carrera'),
      );
      return;
    }

    final response = await raceRepository.createRaceday(racedayToCreate);
    if (response != null) {
      emit(AdminInitial());
      loadRacedaysInfo();
    } else {
      emit(
        AdminInputErrorState(message: 'Hubo un error creando la jornada'),
      );
    }
  }

  Future<void> editRaceday({
    required Raceday raceday,
  }) async {
    final racedayToUpdate = raceday.copyWith(
      racesOptions: _raceOptions.map((e) => e.toList()).toList(),
    );
    if (_raceOptions.any((element) => element.length < 3)) {
      emit(
        AdminInputErrorState(
            message: 'Se deben selecciones al menos 3 caballos por carrera'),
      );
      return;
    }

    final success = await raceRepository.editRaceday(racedayToUpdate);
    if (success) {
      emit(AdminInitial());
      loadRacedaysInfo();
    } else {
      emit(
        AdminInputErrorState(message: 'Hubo un error editando la jornada'),
      );
    }
  }

  void showCreateTicketSection() {
    var currentDate = DateTime.now();
    _raceOptions.clear;
    emit(
      AdminNewRacedaySectionShownState(
        raceday: Raceday(
          closingTime: DateTime(
            currentDate.year,
            currentDate.month,
            currentDate.day,
            16,
          ),
          winners: [],
          racesOptions: _raceOptions.map((e) => e.toList()).toList(),
          trackId: _trackId,
          isOpen: false,
        ),
      ),
    );
  }

  void closeAdminActionSection() {
    emit(AdminInitial());
  }

  void showEditTicketSection(String racedayId) {
    _raceOptions.clear();
    _raceOptions.addAll(
      _racedays
          .firstWhere((element) => element.id == racedayId)
          .racesOptions
          .map(
            (e) => e.toSet(),
          ),
    );
    emit(
      AdminEditRacedaySectionShownState(
        raceday: _racedays
            .firstWhere((element) => element.id == racedayId)
            .copyWith(),
      ),
    );
  }

  void changeRacedayData(Raceday raceday, bool isNewRaceday) {
    emit(
      isNewRaceday
          ? AdminNewRacedaySectionShownState(raceday: raceday)
          : AdminEditRacedaySectionShownState(raceday: raceday),
    );
  }

  Future<void> changeRacedayStatus(bool isOpen, String racedayId) async {
    if (await raceRepository.updateRecedayStatusForAdmin(racedayId, isOpen)) {
      final updatedRaceday = _racedays
          .firstWhere((element) => element.id == racedayId)
          .copyWith(isOpen: isOpen);

      final racedayToUpdateIndex =
          _racedays.indexWhere((element) => element.id == racedayId);
      _racedays[racedayToUpdateIndex] = updatedRaceday;

      emit(AdminConfiguredRacedaysLoaded(racedays: _racedays));
    }
  }

  Future<void> showSetWinnersSection(String racedayId) async {
    final raceday = _racedays.firstWhere((element) => element.id == racedayId);
    emit(
      AdminSetWinnersSectionShownState(
        raceday: raceday,
        race: raceday.raceToSetWinners,
      ),
    );
    //await ticketRepository.updateTickets(racedayId, 6, 3, 5);
  }

  Future<void> setWinners(
    String racedayId,
    // int raceNumber,
    List<int> winners,
  ) async {
    final raceday = _racedays.firstWhere((element) => element.id == racedayId);
    final raceToSetWinners = raceday.raceToSetWinners;
    final setWinnersResponse =
        await raceRepository.setWinners(racedayId, winners, raceToSetWinners);

    if (setWinnersResponse) {
      for (var i = 0; i < winners.length; i++) {
        if (winners[i] > 0) {
          int pts = 0;
          switch (i) {
            case 0:
              pts = 5;
              break;
            case 1:
              pts = 3;
              break;
            default:
              pts = 1;
              break;
          }
          await ticketRepository.updateTickets(
            racedayId,
            raceToSetWinners,
            winners[i],
            pts,
          );
        }
      }
    }

    /// Error setting winners on raceday
  }

  Future<void> loadRacedaysInfo() async {
    _racedays.clear();
    if (_trackId.isNotEmpty) {
      final racedays = await raceRepository.getRecedaysForAdmin(_trackId);
      _racedays.addAll(racedays);
      emit(AdminConfiguredRacedaysLoaded(racedays: racedays));
    }
  }
}
