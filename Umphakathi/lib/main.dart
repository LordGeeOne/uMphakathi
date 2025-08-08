import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home/home.dart';
import 'vault/providers/media_provider.dart';
import 'safety/providers/safety_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MediaProvider()..initializeMedia(),
        ),
        ChangeNotifierProvider(
          create: (context) => SafetyProvider()..initializeSafety(),
        ),
      ],
      child: MaterialApp(
        title: 'Umphakathi',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          primaryColor: const Color(0xFF004D40),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF004D40),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF004D40),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
        ),
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
