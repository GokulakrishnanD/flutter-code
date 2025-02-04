import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:thiran_tech_task/Models/ticket.dart';

class TicketService {
  final CollectionReference _ticketCollection =
      FirebaseFirestore.instance.collection('tickets');

  Future<String?> _uploadAttachment(File file) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = FirebaseStorage.instance.ref().child('tickets/$fileName');
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask.whenComplete(() => {});
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  Future<List<Ticket>> fetchTickets() async {
    QuerySnapshot snapshot = await _ticketCollection.get();
    return snapshot.docs
        .map(
            (doc) => Ticket.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> addTicket(Ticket ticket, File? attachment) async {
    String? attachmentUrl;
    if (attachment != null) {
      attachmentUrl = await _uploadAttachment(attachment);
    }

    try {
      DocumentReference docRef = await _ticketCollection.add(
        ticket.toMap()..['attachmentUrl'] = attachmentUrl,
      );

      print('Ticket successfully stored with ID: ${docRef.id}');
    } catch (e) {
      print('Error adding ticket: $e');
    }
  }
}
