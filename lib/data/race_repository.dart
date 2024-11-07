import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_fecta/domain/entities/raceday.dart';
import 'package:e_fecta/domain/entities/track.dart';
import 'package:e_fecta/domain/repositories/race_repository.dart';

class RaceRepositoryImpl implements RaceRepository {
  final firestore = FirebaseFirestore.instance;
  @override
  Future<Raceday?> getRecedayInfo(String trackId) async {
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
      List<List<int>> options = _mapRaces(raceday.data()['races']);

      return Raceday(
        id: raceday.id,
        trackId: trackId,
        tokensPerTicket: raceday['ticketCost'],
        closingTime: DateTime.fromMillisecondsSinceEpoch(
            raceday['closingDateTime'].millisecondsSinceEpoch),
        racesOptions: options,
        isOpen: raceday['opened'],
        winners: const [],
      );
    }
    return null;
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
  Future<Raceday?> createRaceday(Raceday raceday) async {
    try {
      for (var element in raceday.racesOptions) {
        element.sort();
      }
      final racedayToSend = raceday.toJson();
      final racedayDocRef =
          await firestore.collection('racedays').add(racedayToSend);
      return Future.value(raceday.copyWith(id: racedayDocRef.id));
    } catch (e) {
      return Future.value(null);
    }
  }

  @override
  Future<bool> editRaceday(Raceday raceday) async {
    try {
      for (var element in raceday.racesOptions) {
        element.sort();
      }
      final racedayToSend = raceday.toJson();
      await firestore
          .collection('racedays')
          .doc(raceday.id)
          .update(racedayToSend);
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  @override
  Future<bool> setWinners(String racedayId, List<int> winners, int race) async {
    try {
      await firestore.collection('racedays').doc(racedayId).update({
        'winners': {'$race': winners}
      });
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  @override
  Future getRecedaysForAdmin(String trackId) async {
    final racedayResult = await firestore
        .collection('racedays')
        .where('trackId', isEqualTo: trackId)
        .orderBy('closingDateTime')
        .get();

    final List<Raceday> racedays = [];

    for (var raceday in racedayResult.docs.map((e) => e).toList()) {
      List<List<int>> options = _mapRaces(raceday['races']);

      racedays.add(
        Raceday(
          id: raceday.id,
          trackId: trackId,
          tokensPerTicket: raceday['ticketCost'],
          closingTime: DateTime.fromMillisecondsSinceEpoch(
              raceday['closingDateTime'].millisecondsSinceEpoch),
          racesOptions: options,
          isOpen: raceday['opened'] ?? false,
          winners: const [
            [1, 2, 4],
            [1, 2, 4],
            [1, 2, 4],
            [1, 2, 4],
            [1, 2, 4],
            [1, 2, 4]
          ],
        ),
      );
    }
    return racedays;
  }

  List<List<int>> _mapRaces(Map<String, dynamic> racedayRacesJson) {
    try {
      List<List<int>> options = [];
      for (var i = 1; i < 7; i++) {
        options.add((racedayRacesJson['$i'] as List<dynamic>)
            .map((e) => int.parse(e.toString()))
            .toList());
      }
      for (var element in options) {
        element.sort();
      }
      return options;
    } catch (ex) {
      return List.generate(6, (index) => []);
    }

    // return [
    //   (racedayJson['race1'] as List<dynamic>)
    //       .map((e) => int.parse(e.toString()))
    //       .toList(),
    //   (racedayJson['race2'] as List<dynamic>)
    //       .map((e) => int.parse(e.toString()))
    //       .toList(),
    //   (racedayJson['race3'] as List<dynamic>)
    //       .map((e) => int.parse(e.toString()))
    //       .toList(),
    //   (racedayJson['race4'] as List<dynamic>)
    //       .map((e) => int.parse(e.toString()))
    //       .toList(),
    //   (racedayJson['race5'] as List<dynamic>)
    //       .map((e) => int.parse(e.toString()))
    //       .toList(),
    //   (racedayJson['race6'] as List<dynamic>)
    //       .map((e) => int.parse(e.toString()))
    //       .toList(),
    // ];

    // return [
    //   (racedayJson['race1'] as List<dynamic>)
    //       .map((e) => int.parse(e.toString()))
    //       .toList(),
    //   (racedayJson['race2'] as List<dynamic>)
    //       .map((e) => int.parse(e.toString()))
    //       .toList(),
    //   (racedayJson['race3'] as List<dynamic>)
    //       .map((e) => int.parse(e.toString()))
    //       .toList(),
    //   (racedayJson['race4'] as List<dynamic>)
    //       .map((e) => int.parse(e.toString()))
    //       .toList(),
    //   (racedayJson['race5'] as List<dynamic>)
    //       .map((e) => int.parse(e.toString()))
    //       .toList(),
    //   (racedayJson['race6'] as List<dynamic>)
    //       .map((e) => int.parse(e.toString()))
    //       .toList(),
    // ];
  }

  @override
  Future<bool> updateRecedayStatusForAdmin(
      String racedayId, bool isOpen) async {
    try {
      final response = await firestore
          .collection('racedays')
          .doc(racedayId)
          .update({'opened': isOpen});
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }
}
