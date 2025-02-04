import '../Models/ticket.dart';

abstract class TicketState {}

class TicketLoading extends TicketState {}

class TicketLoaded extends TicketState {
  final List<Ticket> tickets;
  TicketLoaded(this.tickets);
}

class TicketError extends TicketState {
  final String message;
  TicketError(this.message);
}
