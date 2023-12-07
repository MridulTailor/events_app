import 'package:events_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:events_app/provider/event_provider.dart';
import 'package:events_app/screens/event_detail.dart';
import 'package:events_app/screens/event_search.dart';
import 'package:events_app/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EventProvider(),
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Inter',
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              elevation: 0),
        ),
        title: 'Event App',
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/event_detail': (context) => const EventDetailScreen(),
          '/event_search': (context) => const EventSearchScreen(),
        },
      ),
    );
  }
}
