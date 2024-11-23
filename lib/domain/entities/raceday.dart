import 'package:equatable/equatable.dart';

class Raceday extends Equatable {
  const Raceday({
    this.id = '',
    required this.closingTime,
    required this.winners,
    required this.racesOptions,
    required this.trackId,
    required this.isOpen,
    this.tokensPerTicket = 1,
    this.prizePlaces = 3,
  });

  final String id;
  final DateTime closingTime;
  final int tokensPerTicket;
  final String trackId;
  final bool isOpen;
  final List<List<int>> winners;
  final List<List<int>> racesOptions;
  final int prizePlaces;

  @override
  List<Object?> get props => [
        closingTime,
        winners,
        racesOptions,
        tokensPerTicket,
        trackId,
        id,
        isOpen,
        prizePlaces,
      ];

  int get raceToSetWinners {
    int raceNumber = 1; //defaut value
    int index = 0;

    while (index < 6) {
      /// if the winners list on a specific index is emptuy or there are values
      /// less than 1 (-1 or 0) within winners structure, it means no winners
      /// have been set to that race;
      if (winners[index].isEmpty ||
          winners[index].any((element) => element < 1)) {
        raceNumber = index + 1;
        break;
      }
      index++;
    }
    return raceNumber;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> races = {};
    final Map<String, dynamic> raceday = {
      'closingDateTime': closingTime,
      'ticketCost': tokensPerTicket,
      'trackId': trackId,
      'opened': isOpen,
      'prizePlaces': prizePlaces,
    };
    for (var i = 0; i < racesOptions.length; i++) {
      // raceday['race${i + 1}'] = racesOptions[i];
      races['${i + 1}'] = racesOptions[i];
    }
    raceday['races'] = races;
    return raceday;
  }

  Raceday copyWith({
    String? id,
    DateTime? closingTime,
    int? tokensPerTicket,
    String? trackId,
    bool? isOpen,
    List<List<int>>? winners,
    List<List<int>>? racesOptions,
    int? prizePlaces,
  }) =>
      Raceday(
        id: id ?? this.id,
        closingTime: closingTime ?? this.closingTime,
        winners: winners ?? this.winners,
        racesOptions: racesOptions ?? this.racesOptions,
        trackId: trackId ?? this.trackId,
        isOpen: isOpen ?? this.isOpen,
        tokensPerTicket: tokensPerTicket ?? this.tokensPerTicket,
        prizePlaces: prizePlaces ?? this.prizePlaces,
      );
}
