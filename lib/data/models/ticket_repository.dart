import 'package:ticketform/data/firebase_services.dart';
import 'package:ticketform/data/database_services.dart';
import 'package:ticketform/data/models/ticket.dart';

class TicketRepository {
  final FirebaseService firebaseService;
  final DatabaseService databaseService;

  TicketRepository(this.firebaseService, this.databaseService);

  Future<void> syncTickets() async {
    final ticketsFromFirebase = await firebaseService.fetchTickets();
    await databaseService.clearTickets();
    for (var ticket in ticketsFromFirebase) {
      await databaseService.addTicket(ticket);
    }
  }

  Future<List<Ticket>> getTicketsFromLocal() {
    return databaseService.getTickets();
  }

  Future<void> addTicket(Ticket ticket) async {
    await databaseService.addTicket(ticket);

    try {
      await firebaseService.addTicket(ticket);
    } catch (e) {
      print('Error syncing ticket to Firebase: $e');
    }
  }

 Future<void> syncPendingTickets() async {
  final unsyncedTickets = await databaseService.getUnsyncedTickets();
  for (var ticket in unsyncedTickets) {
    try {
      await firebaseService.addTicket(ticket);
      await databaseService.markAsSynced(ticket.id);
    } catch (e) {
      print('Failed to sync ticket: ${ticket.id}');
    }
  }
}

}
