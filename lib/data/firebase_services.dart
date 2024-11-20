import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticketform/data/models/ticket.dart';

class FirebaseService {
  final CollectionReference tickets = FirebaseFirestore.instance.collection('tickets');

  Future<List<Ticket>> fetchTickets() async {
    final snapshot = await tickets.get();
    return snapshot.docs.map((doc) => Ticket.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

 Future<void> addTicket(Ticket ticket) async {
  await tickets.doc(ticket.id).set(ticket.toMap());
}

}
