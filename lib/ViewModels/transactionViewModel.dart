import 'package:flutter/material.dart';
import 'package:thiran_tech_task/Models/transaction.dart';
import 'package:thiran_tech_task/Repository/transaction_repository.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mailer/mailer.dart' as mailer;
import 'package:mailer/smtp_server.dart';
import 'package:mailer/smtp_server/gmail.dart';

class TransactionViewModel extends ChangeNotifier {
  final TransactionRepository repository = TransactionRepository();
  List<TransactionModel> transactions = [];
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  TransactionViewModel() {
    _init();
  }

  Future<void> _init() async {
    await repository.initDatabase();
    await loadTransactions();
    scheduleDailyCheck();
  }

  Future<void> loadTransactions() async {
    transactions = await repository.getAllTransactions();
    notifyListeners();
  }

  Future<void> scheduleDailyCheck() async {
    checkAndSendEmail();
  }

  Future<void> checkAndSendEmail() async {
    List<TransactionModel> errorRecords =
        await repository.getErrorTransactions();
    if (errorRecords.isNotEmpty) {
      sendEmailReport(errorRecords);
    }
  }

  Future<void> sendEmailReport(List<TransactionModel> errorRecords) async {
    String message = "Daily Error Report:\n\n";
    for (var record in errorRecords) {
      message +=
          "TransID: ${record.id}, Desc: ${record.desc}, Status: ${record.status}, DateTime: ${record.dateTime}\n";
    }

    final mail = mailer.Message()
      ..from = const mailer.Address('gokulakrishnands7@gmail.com', 'Gokul')
      ..recipients.add('gokulakrishnan3570@gmail.com')
      ..subject = 'Daily Error Report'
      ..text = message;

    await sendEmail(mail);
  }

  Future<void> sendEmail(mailer.Message email) async {
    final smtpServer = gmail('gokulakrishnands7@gmail.com', 'Gokul@123');

    try {
      await mailer.send(email, smtpServer);
    } catch (e) {
      print("Email sending failed: $e");
    }
  }
}
