import 'package:equatable/equatable.dart';

class Raceday extends Equatable {
  const Raceday({
    required this.closingTime,
    required this.winners,
    required this.racesOptions,
    required this.trackId,
    required this.isOpen,
    this.tokensPerTicket = 1,
  });

  final DateTime closingTime;
  final int tokensPerTicket;
  final String trackId;
  final bool isOpen;
  final List<List<int>> winners;
  final List<List<int>> racesOptions;

  @override
  List<Object?> get props =>
      [closingTime, winners, racesOptions, tokensPerTicket];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> races = {};
    final Map<String, dynamic> raceday = {
      'closingDateTime': closingTime,
      'ticketCost': tokensPerTicket,
      'trackId': trackId,
      'opened': isOpen,
    };
    for (var i = 0; i < racesOptions.length; i++) {
      raceday['race${i + 1}'] = racesOptions[i];
      races['${i + 1}'] = racesOptions[i];
    }
    raceday['races'] = races;
    return raceday;
  }
}
