import 'package:e_fecta/data/race_repository.dart';
import 'package:e_fecta/domain/entities/raceday.dart';
import 'package:e_fecta/domain/repositories/race_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit() : super(AdminInitial());

  final RaceRepository raceRepository = RaceRepositoryImpl();

  String _trackId = '';

  final List<Set<int>> _raceOptions = ([{}, {}, {}, {}, {}, {}]);

  Future<void> setTrack(String trackId) async {
    _trackId = trackId;
    loadRacedaysInfo();
  }

  Future<void> setSelection({
    required List<int> optionSelected,
    required int race,
  }) async {
    _raceOptions[race].clear();
    _raceOptions[race].addAll(optionSelected);
    if (state is AdminInputErrorState) {
      emit(AdminInitial());
    }
  }

  Future<void> createRaceday({
    required int tokensPerTicket,
    required DateTime closingTime,
  }) async {
    if (_raceOptions.any((element) => element.length < 2)) {
      emit(AdminInputErrorState());
      return;
    }

    await raceRepository.createRaceday(
      Raceday(
        closingTime: closingTime,
        trackId: _trackId,
        racesOptions: _raceOptions.map((e) => e.toList()).toList(),
        winners: [],
        isOpen: false,
        tokensPerTicket: tokensPerTicket,
      ),
    );
  }

  Future<void> loadRacedaysInfo() async {
    if (_trackId.isNotEmpty) {
      final racedays = await raceRepository.getRecedaysForAdmin(_trackId);
      emit(AdminConfiguredRacedaysLoaded(racedays: racedays));
    }
  }
}
