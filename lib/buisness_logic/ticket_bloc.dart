import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketform/data/models/ticket.dart';
import 'package:ticketform/data/models/ticket_repository.dart';

abstract class TicketEvent {}

class FetchTickets extends TicketEvent {}

class AddTicket extends TicketEvent {
  final Ticket ticket;
  AddTicket(this.ticket);
}

class TicketState {
  final List<Ticket> tickets;
  final bool hasError;

  TicketState({required this.tickets, this.hasError = false});
}

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final TicketRepository ticketRepository;

  TicketBloc(this.ticketRepository) : super(TicketState(tickets: [])) {
    on<FetchTickets>((event, emit) async {
      try {
        await ticketRepository.syncTickets();
        final tickets = await ticketRepository.getTicketsFromLocal();
        emit(TicketState(tickets: tickets));
      } catch (e) {
        emit(TicketState(tickets: [], hasError: true));
      }
    });

    on<AddTicket>((event, emit) async {
      try {
        await ticketRepository.addTicket(event.ticket);
        await ticketRepository.syncPendingTickets();
        add(FetchTickets());
      } catch (e) {
        emit(TicketState(tickets: state.tickets, hasError: true));
      }
    });
  }
}
