abstract class TicketRepository {
  Future<dynamic> sealTickets(List<dynamic> tickets, String racedayId);

  Future<dynamic> getTickets();

  Future<bool> updateTickets(
      String racedayId, int race, int position, int points);
}
