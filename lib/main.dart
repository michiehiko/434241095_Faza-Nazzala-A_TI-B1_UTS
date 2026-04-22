import 'package:flutter/material.dart';
import 'features/auth/presentation/splash_screen.dart';
import 'features/auth/presentation/login_screen.dart'; 
import 'features/ticket/presentation/user/dashboard_screen.dart';
import 'features/ticket/presentation/user/ticket_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Ticketing Helpdesk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4A5568)),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF63B3ED), brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: _themeMode, 
      home: const SplashScreen(),
    );
  }
}