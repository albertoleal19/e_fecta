part of 'header_cubit.dart';

abstract class HeaderState {}

class HeaderInitial extends HeaderState {}

class HeaderInfoChanged extends HeaderState {
  HeaderInfoChanged({
    required this.tracks,
    required this.user,
    required this.selectedTrack,
    this.adminActive = false,
  });

  final List<Track> tracks;
  final User user;
  final Track selectedTrack;
  final bool adminActive;
}

class HeaderLogout extends HeaderState {}

// class HeaderInfoChanged extends HeaderInfoLoaded {
//   HeaderInfoChanged({
//     required List<Track> tracks,
//     required User user,
//     required Track selectedTrack,
//     this.selectedAdminConfig = -1,
//   }) : super(
//           tracks: tracks,
//           selectedTrack: selectedTrack,
//           user: user,
//         );

//   final int selectedAdminConfig;

//   // @override
//   // List<Object?> get props => [tracks, user, selectedTrack, selectedAdminConfig];
// }
