import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ticketform/buisness_logic/ticket_bloc.dart';
import 'package:ticketform/data/database_services.dart';
import 'package:ticketform/data/firebase_services.dart';
import 'package:ticketform/data/models/ticket_repository.dart';
import 'package:ticketform/presentation/screens/ticket_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.requestPermission();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Message received in foreground: ${message.messageId}");
  });
  runApp(MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseService = FirebaseService();
    final databaseService = DatabaseService();
    final ticketRepository = TicketRepository(firebaseService, databaseService);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TicketBloc(ticketRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Ticketing System',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TicketListScreen(),
      ),
    );
  }
}
