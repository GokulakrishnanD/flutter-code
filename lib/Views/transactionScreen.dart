import 'package:flutter/material.dart';
import 'package:thiran_tech_task/Service/email_service.dart';
import '../Repository/transaction_repository.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  late EmailService emailService;

  @override
  void initState() {
    super.initState();
    emailService = EmailService(TransactionRepository());
    emailService.scheduleDailyEmail();
  }

  void _sendTestEmail() async {
    print('Check the Email');
    await EmailService.sendErrorEmail();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Test email sent! Check your inbox.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transaction Email Scheduler")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Daily error email scheduling is active.",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendTestEmail,
              child: const Text("Send Test Email"),
            ),
          ],
        ),
      ),
    );
  }
}
