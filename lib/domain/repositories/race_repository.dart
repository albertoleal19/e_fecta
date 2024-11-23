import 'package:e_fecta/domain/entities/raceday.dart';
import 'package:e_fecta/domain/entities/track.dart';

abstract class RaceRepository {
  Future<Raceday?> getBetAvailableRaceday(String trackId);

  Future<List<Raceday>> getAllPastRacedaysForTrack(String trackId);

  Future<dynamic> getRecedaysForAdmin(String trackId);

  Future<bool> updateRecedayStatusForAdmin(String racedayId, bool isOpen);

  Future<List<Track>> getTracks();

  Future<Raceday?> createRaceday(Raceday raceday);

  Future<bool> editRaceday(Raceday raceday);

  Future<bool> setWinners(String racedayId, List<int> winners, int race);
}
