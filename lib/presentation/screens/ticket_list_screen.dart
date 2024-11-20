import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketform/buisness_logic/ticket_bloc.dart';
import 'package:ticketform/presentation/screens/ticket_form_screen.dart';
import 'package:ticketform/presentation/widgets/ticket_card.dart';

class TicketListScreen extends StatefulWidget {
  const TicketListScreen({super.key});

  @override
  State<TicketListScreen> createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {

  @override
  void initState() {
    super.initState();
    context.read<TicketBloc>().add(FetchTickets());
  }

  Future<void> _onRefresh() async {
    context.read<TicketBloc>().add(FetchTickets());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Tickets"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TicketFormScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              context.read<TicketBloc>().add(FetchTickets());
            },
          ),
        ],
      ),
      body: BlocBuilder<TicketBloc, TicketState>(
        builder: (context, state) {
          if (state.hasError) {
            return const Center(child: Text("Error loading tickets"));
          } else if (state.tickets.isEmpty) {
            return const Center(child: Text("No tickets available"));
          }

          return RefreshIndicator(
            onRefresh: _onRefresh, 
            child: ListView.builder(
              itemCount: state.tickets.length,
              itemBuilder: (context, index) {
                return TicketCard(ticket: state.tickets[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
