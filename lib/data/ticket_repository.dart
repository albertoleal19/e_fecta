import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_fecta/domain/repositories/ticket_repository.dart';

class TicketRepositoryImpl implements TicketRepository {
  final firestore = FirebaseFirestore.instance;
  @override
  Future getTickets() {
    // TODO: implement getTickets
    throw UnimplementedError();
  }

  @override
  Future sealTickets(List tickets, String recedayId) async {
    try {
      for (var ticket in tickets) {
        Map<String, dynamic> ticketToSend = {};
        for (var i = 0; i < 6; i++) {
          ticketToSend['race${i + 1}'] = (ticket['options'] as List<int>)[i];
          ticketToSend['pts${i + 1}'] = 0;
        }
        // ticketToSend['race1'] = (ticket['options'] as List<int>)[0];
        // ticketToSend['race2'] = (ticket['options'] as List<int>)[1];
        // ticketToSend['race3'] = (ticket['options'] as List<int>)[2];
        // ticketToSend['race4'] = (ticket['options'] as List<int>)[3];
        // ticketToSend['race5'] = (ticket['options'] as List<int>)[4];
        // ticketToSend['race6'] = (ticket['options'] as List<int>)[5];

        // ticketToSend['pts1'] = 0;
        // ticketToSend['pts2'] = 0;
        // ticketToSend['pts3'] = 0;
        // ticketToSend['pts4'] = 0;
        // ticketToSend['pts5'] = 0;
        // ticketToSend['pts6'] = 0;
        ticketToSend['totalPts'] = 0;
        ticketToSend['racedayId'] = recedayId;
        ticketToSend['userId'] = ticket['userId'];
        await firestore.collection('tickets').add(ticketToSend);
      }
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  @override
  Future<bool> updateTickets(
      String racedayId, int race, int position, int points) async {
    try {
      final query = firestore
          .collection('tickets')
          // .where('userId', isEqualTo: 'alberto')
          .where('race$race', isEqualTo: position)
          .where('racedayId', isEqualTo: racedayId);
      final count = (await query.count().get()).count ?? 0;
      final batchCount = count % 500;

      final tickets = await query.get();
      var offset = 0;
      var remaining = count;
      var batchLast = remaining < 500 ? remaining : 500;

      for (var i = 0; i < batchCount; i++) {
        final batch = firestore.batch();

        for (var j = offset; j < offset + batchLast; j++) {
          final ticketElement = tickets.docs.elementAt(j);
          final docRef = ticketElement.reference;
          var sum = 0;
          for (var k = 1; k < race; k++) {
            sum += (ticketElement.data()['pts$k'] as int?) ?? 0;
          }
          sum += points;
          batch.update(docRef, {'pts$race': points, 'totalPts': sum});
        }
        //commit batch
        await batch.commit();

        offset += batchLast;
        remaining -= batchLast;
        batchLast = remaining < 500 ? remaining : 500;
      }

      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }
}
