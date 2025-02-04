import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thiran_tech_task/Bloc/ticket_bloc.dart';
import 'package:thiran_tech_task/Repository/transaction_repository.dart';
import 'package:thiran_tech_task/Service/email_service.dart';
import 'package:thiran_tech_task/ViewModels/transactionViewModel.dart';
import 'package:thiran_tech_task/Views/homescreen.dart';
import 'Bloc/ticket_event.dart';
import 'firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final repository = TransactionRepository();
  final emailService = EmailService(repository);
  emailService.scheduleDailyEmail();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TransactionViewModel()),
        BlocProvider(create: (context) => TicketBloc()..add(LoadTickets())),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(), 
      ),
    );
  }
}
