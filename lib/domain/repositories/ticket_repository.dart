abstract class TicketRepository {
  Future<dynamic> sealTickets(List<dynamic> tickets);

  Future<dynamic> getTickets();
}
