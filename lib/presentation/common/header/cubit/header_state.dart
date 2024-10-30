part of 'header_cubit.dart';

abstract class HeaderState with EquatableMixin {}

class HeaderInitial extends HeaderState {
  @override
  List<Object?> get props => [];
}

class HeaderInfoLoaded extends HeaderState {
  HeaderInfoLoaded({
    required this.tracks,
    required this.user,
    required this.selectedTrack,
  });

  final List<Track> tracks;
  final User user;
  final Track selectedTrack;

  @override
  List<Object?> get props => [tracks, user, selectedTrack];
}

class HeaderTrackChanged extends HeaderInfoLoaded {
  HeaderTrackChanged({
    required List<Track> tracks,
    required User user,
    required Track selectedTrack,
    this.selectedAdminConfig = -1,
  }) : super(
          tracks: tracks,
          selectedTrack: selectedTrack,
          user: user,
        );

  final int selectedAdminConfig;

  @override
  List<Object?> get props => [tracks, user, selectedTrack, selectedAdminConfig];
}
