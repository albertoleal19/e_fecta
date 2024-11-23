import 'package:e_fecta/domain/entities/ticket.dart';
import 'package:e_fecta/domain/entities/user.dart';

abstract class TicketRepository {
  Future<int?> sealTickets(
      List<Ticket> tickets, User user, int tokensPerTicket);

  Future<List<Ticket>> getTickets(String racedayId);

  Future<bool> updateTickets(
      String racedayId, int race, int position, int points);

  Future<int> getSummary(String racedayId);
}
