import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thiran_tech_task/Bloc/ticket_bloc.dart';
import 'package:thiran_tech_task/Views/create_ticket_screen.dart';
import '../Bloc/ticket_state.dart';

class TicketScreen extends StatelessWidget {
  const TicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Tickets")),
      body: BlocBuilder<TicketBloc, TicketState>(
        builder: (context, state) {
          if (state is TicketLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TicketLoaded) {
            return ListView.builder(
              itemCount: state.tickets.length,
              itemBuilder: (context, index) {
                final ticket = state.tickets[index];
                return ListTile(
                  title: Text(ticket.title),
                  subtitle: Text(ticket.description),
                  trailing: Text(ticket.date),
                );
              },
            );
          } else {
            return const Center(child: Text("No tickets found."));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateTicketScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
