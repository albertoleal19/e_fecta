import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_fecta/domain/entities/raceday.dart';
import 'package:e_fecta/domain/entities/track.dart';
import 'package:e_fecta/domain/repositories/race_repository.dart';

class RaceRepositoryImpl implements RaceRepository {
  final firestore = FirebaseFirestore.instance;
  @override
  Future getRecedayInfo(String trackId) async {
    final racedayResult = await firestore
        .collection('racedays')
        .where('trackId', isEqualTo: trackId)
        .where('closingDateTime', isGreaterThanOrEqualTo: DateTime.now())
        .where('opened', isEqualTo: true)
        .orderBy('closingDateTime')
        .limit(1)
        .get();
    if (racedayResult.docs.isNotEmpty) {
      final raceday = racedayResult.docs.first;
      List<List<int>> options = _mapRaces(raceday.data());

      return Future.value(
        Raceday(
          trackId: trackId,
          tokensPerTicket: raceday['ticketCost'],
          closingTime: DateTime.fromMillisecondsSinceEpoch(
              raceday['closingDateTime'].millisecondsSinceEpoch),
          racesOptions: options,
          isOpen: raceday['opened'],
          winners: const [],
        ),
      );
    }
  }

  @override
  Future<List<Track>> getTracks() async {
    final snap = await firestore.collection('tracks').get();
    final tracks = snap.docs
        .map((track) =>
            Track(id: track.id, name: track['name'], description: ''))
        .toList();
    return tracks;
  }

  @override
  Future<bool> createRaceday(Raceday raceday) async {
    final racedayToSend = raceday.toJson();
    await firestore.collection('racedays').add(racedayToSend);
    return Future.value(true);
  }

  @override
  Future getRecedaysForAdmin(String trackId) async {
    final racedayResult = await firestore
        .collection('racedays')
        .where('trackId', isEqualTo: trackId)
        .orderBy('closingDateTime')
        .get();

    final List<Raceday> racedays = [];

    for (var raceday in racedayResult.docs.map((e) => e.data()).toList()) {
      List<List<int>> options = _mapRaces(raceday);

      racedays.add(
        Raceday(
          trackId: trackId,
          tokensPerTicket: raceday['ticketCost'],
          closingTime: DateTime.fromMillisecondsSinceEpoch(
              raceday['closingDateTime'].millisecondsSinceEpoch),
          racesOptions: options,
          isOpen: raceday['opened'] ?? false,
          winners: const [],
        ),
      );
    }
    return racedays;
  }

  List<List<int>> _mapRaces(Map<String, dynamic> racedayJson) {
    return [
      (racedayJson['race1'] as List<dynamic>)
          .map((e) => int.parse(e.toString()))
          .toList(),
      (racedayJson['race2'] as List<dynamic>)
          .map((e) => int.parse(e.toString()))
          .toList(),
      (racedayJson['race3'] as List<dynamic>)
          .map((e) => int.parse(e.toString()))
          .toList(),
      (racedayJson['race4'] as List<dynamic>)
          .map((e) => int.parse(e.toString()))
          .toList(),
      (racedayJson['race5'] as List<dynamic>)
          .map((e) => int.parse(e.toString()))
          .toList(),
      (racedayJson['race6'] as List<dynamic>)
          .map((e) => int.parse(e.toString()))
          .toList(),
    ];
  }
}
