import 'package:workmanager/workmanager.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import '../Models/transaction.dart';
import '../Repository/transaction_repository.dart';

class EmailService {
  final TransactionRepository repository;
  EmailService(this.repository);

  void scheduleDailyEmail() {
    Workmanager().initialize(_callbackDispatcher, isInDebugMode: true);
    Workmanager().registerPeriodicTask(
      "daily_email_task",
      "sendEmailIfErrorsExist",
      frequency: const Duration(days: 1),
    );
  }

  static void _callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      try {
        await sendErrorEmail();
        return Future.value(true);
      } catch (e) {
        print("❌ WorkManager Task Failed: $e");
        return Future.value(false);
      }
    });
  }

  static Future<void> sendErrorEmail() async {
    final repository = TransactionRepository();
    await repository.initDatabase();

    List<TransactionModel> errorRecords =
        await repository.getErrorTransactions();

    if (errorRecords.isNotEmpty) {
      String emailBody = "The following transactions have errors:\n\n";
      for (var txn in errorRecords) {
        emailBody +=
            "TransID: ${txn.id}, Desc: ${txn.desc}, DateTime: ${txn.dateTime}\n";
      }

      final Email email = Email(
        body: emailBody,
        subject: "🚨 Daily Error Report: Transactions with Errors",
        recipients: ["gokulakrishnan3570@gmail.com"],
        isHTML: false,
      );

      try {
        await FlutterEmailSender.send(email);
        print("📧 Error email sent successfully!");
      } catch (e) {
        print("❌ Failed to send email: $e");
      }
    }
  }
}
