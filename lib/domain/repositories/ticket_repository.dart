import 'package:e_fecta/domain/entities/ticket.dart';
import 'package:e_fecta/domain/entities/user.dart';

abstract class TicketRepository {
  Future<int?> sealTickets(
      List<Ticket> tickets, User user, int tokensPerTicket);

  Future<dynamic> getTickets();

  Future<bool> updateTickets(
      String racedayId, int race, int position, int points);
}
