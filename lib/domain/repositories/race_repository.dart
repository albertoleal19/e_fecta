import 'package:e_fecta/domain/entities/raceday.dart';
import 'package:e_fecta/domain/entities/track.dart';

abstract class RaceRepository {
  Future<dynamic> getRecedayInfo(String trackId);

  Future<dynamic> getRecedaysForAdmin(String trackId);

  Future<List<Track>> getTracks();

  Future<bool> createRaceday(Raceday raceday);
}
