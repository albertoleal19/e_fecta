import 'package:equatable/equatable.dart';

class Ticket extends Equatable {
  const Ticket({
    required this.racedayId,
    required this.selectedOptions,
    this.points = const [0, 0, 0, 0, 0, 0],
    this.totalPts = 0,
  });

  final String racedayId;
  final List<int> selectedOptions;
  final List<int> points;
  final int totalPts;

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
