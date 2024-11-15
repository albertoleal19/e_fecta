import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_fecta/domain/entities/ticket.dart';
import 'package:e_fecta/domain/entities/user.dart';
import 'package:e_fecta/domain/repositories/ticket_repository.dart';

class TicketRepositoryImpl implements TicketRepository {
  final firestore = FirebaseFirestore.instance;
  @override
  Future<List<Ticket>> getTickets(String racedayId) async {
    final ticketsResult = await firestore
        .collection('tickets')
        .where('racedayId', isEqualTo: racedayId)
        .orderBy('totalPts', descending: true)
        .orderBy('timestamp', descending: true)
        .limit(100)
        .get();

    try {
      final tickets = ticketsResult.docs.map((ticket) {
        final List<int> options = List<int>.empty(growable: true);
        for (var i = 1; i < 7; i++) {
          options.add(ticket.data()['race$i'] as int);
        }
        final List<int> points = List<int>.empty(growable: true);
        for (var i = 1; i < 7; i++) {
          points.add(ticket.data()['pts$i'] as int);
        }
        return Ticket(
          number: ticket.id,
          racedayId: ticket['racedayId'],
          selectedOptions: options,
          username: ticket['username'],
          points: points,
          totalPts: ticket['totalPts'],
        );
      }).toList();
      return tickets;
    } catch (e) {
      print('Error: e');
      rethrow;
    }
  }

  @override
  Future<int?> sealTickets(
    List<Ticket> tickets,
    User user,
    int tokensPerTicket,
  ) async {
    int? newBalance;
    try {
      for (Ticket ticket in tickets) {
        Map<String, dynamic> ticketToSend = {};
        for (var i = 0; i < 6; i++) {
          ticketToSend['race${i + 1}'] = ticket.selectedOptions[i];
          ticketToSend['pts${i + 1}'] = 0;
        }

        ticketToSend['totalPts'] = 0;
        ticketToSend['racedayId'] = ticket.racedayId;
        ticketToSend['userId'] = user.id;
        ticketToSend['username'] = user.username;
        ticketToSend['timestamp'] = FieldValue.serverTimestamp();
        final userRef = firestore.collection('users').doc(user.id);
        final ticketRef = firestore.collection('tickets').doc();
        newBalance = await firestore.runTransaction((transaction) async {
          final currentBalance =
              (await transaction.get(userRef)).get('balance');
          transaction.set(ticketRef, ticketToSend);
          transaction.update(userRef, {
            'balance': FieldValue.increment(-tokensPerTicket),
          });

          return currentBalance - tokensPerTicket;
        });
        // await firestore.collection('tickets').add(ticketToSend);
      }
      return Future.value(newBalance);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> updateTickets(
      String racedayId, int race, int option, int points) async {
    try {
      final query = firestore
          .collection('tickets')
          // .where('userId', isEqualTo: 'alberto')
          .where('race$race', isEqualTo: option)
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
