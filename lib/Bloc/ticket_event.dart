import 'dart:io';

import 'package:thiran_tech_task/Models/ticket.dart';

abstract class TicketEvent {}

class LoadTickets extends TicketEvent {}

class AddTicket extends TicketEvent {
  final Ticket ticket;
  final File? attachment;

  AddTicket(this.ticket, this.attachment);
}
