import 'package:e_fecta/domain/entities/track.dart';
import 'package:e_fecta/domain/entities/user.dart';
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
  bool _adminActive = false;

  Future<void> loadInfo() async {
    final user = await userRepository.getAuthenticatedUser();
    if (user == null) return;
    final tracksResponse = await receRepository.getTracks();

    tracks = tracksResponse;
    selectedTrack = tracks.first;
    currentUser = user;
    _emitHeaderChangeState();
  }

  Future<void> changeTrack(String trackId) async {
    selectedTrack = tracks.firstWhere((element) => element.id == trackId);
    _emitHeaderChangeState();
  }

  Future<void> displayRaceConfiguration() async {
    _adminActive = true;
    _emitHeaderChangeState();
  }

  Future<void> leaveAdminMode() async {
    _adminActive = false;
    _emitHeaderChangeState();
  }

  Future<void> updateBalance(int newBalace) async {
    currentUser = currentUser?.copyWith(tokens: newBalace);
    _emitHeaderChangeState();
  }

  Future<void> logoutUser() async {
    await userRepository.logout();
    emit(HeaderLogout());
  }

  _emitHeaderChangeState() {
    emit(
      HeaderInfoChanged(
        tracks: tracks,
        selectedTrack: selectedTrack!,
        user: currentUser!,
        adminActive: _adminActive,
      ),
    );
  }
}
