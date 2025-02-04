import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thiran_tech_task/Service/ticket_service.dart';
import 'ticket_event.dart';
import 'ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final TicketService _ticketService = TicketService();

  TicketBloc() : super(TicketLoading()) {
    on<LoadTickets>((event, emit) async {
      try {
        final tickets = await _ticketService.fetchTickets();
        emit(TicketLoaded(tickets));
      } catch (e) {
        emit(TicketError(e.toString()));
      }
    });

    on<AddTicket>((event, emit) async {
      try {
        await _ticketService.addTicket(
            event.ticket, event.attachment); // ✅ Pass attachment
        add(LoadTickets());
      } catch (e) {
        emit(TicketError(e.toString()));
      }
    });
  }
}
