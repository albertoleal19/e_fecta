import 'package:equatable/equatable.dart';

class Ticket extends Equatable {
  const Ticket({
    required this.racedayId,
    required this.selectedOptions,
    required this.username,
    this.number = '',
    this.points = const [0, 0, 0, 0, 0, 0],
    this.totalPts = 0,
  });

  final String racedayId;
  final String number;
  final List<int> selectedOptions;
  final String username;
  final List<int> points;
  final int totalPts;

  @override
  List<Object?> get props => [
        racedayId,
        number,
        selectedOptions,
        username,
        points,
        totalPts,
      ];
}
