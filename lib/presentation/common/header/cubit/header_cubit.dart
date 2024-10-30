import 'package:e_fecta/domain/entities/track.dart';
import 'package:e_fecta/domain/entities/user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_fecta/data/race_repository.dart';
import 'package:e_fecta/data/user_repository.dart';
import 'package:e_fecta/domain/repositories/race_repository.dart';
import 'package:e_fecta/domain/repositories/user_repository.dart';
part 'header_state.dart';

class HeaderCubit extends Cubit<HeaderState> {
  HeaderCubit() : super(HeaderInitial());

  final UserRepository userRepository = UserRepositoryImpl();
  final RaceRepository receRepository = RaceRepositoryImpl();

  User? currentUser;
  List<Track> tracks = [];
  Track? selectedTrack;
  int _selecteConfig = -1;

  Future<void> loadInfo() async {
    final tracksResponse = await receRepository.getTracks();
    final user = await userRepository.getUser();

    tracks = tracksResponse;
    selectedTrack = tracks.first;
    currentUser = user;
    emit(
      HeaderInfoLoaded(
        tracks: tracks,
        user: user,
        selectedTrack: selectedTrack!,
      ),
    );
  }

  Future<void> changeTrack(String trackId) async {
    selectedTrack = tracks.firstWhere((element) => element.id == trackId);
    _emitHeaderChangeState();
  }

  Future<void> displayRaceConfiguraiton() async {
    _selecteConfig = 0;
    _emitHeaderChangeState();
  }

  Future<void> leaveAdminMode() async {
    _selecteConfig = -1;
    _emitHeaderChangeState();
  }

  _emitHeaderChangeState() {
    emit(
      HeaderTrackChanged(
        tracks: tracks,
        selectedTrack: selectedTrack!,
        user: currentUser!,
        selectedAdminConfig: _selecteConfig,
      ),
    );
  }
}
