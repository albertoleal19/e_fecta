import 'package:e_fecta/domain/entities/ticket.dart';

class TicketModel extends Ticket {
  const TicketModel({
    required String racedayId,
    required List<int> selectedOptions,
    required String username,
    required this.position,
    String number = '',
    List<int> points = const [0, 0, 0, 0, 0, 0],
    int totalPts = 0,
  }) : super(
          racedayId: racedayId,
          selectedOptions: selectedOptions,
          username: username,
          number: number,
          totalPts: totalPts,
          points: points,
        );

  final int position;
}
