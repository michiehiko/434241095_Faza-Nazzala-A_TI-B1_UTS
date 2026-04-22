import 'package:flutter/material.dart';
import 'dart:async';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.support_agent_rounded,
                size: 80,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'E-Ticketing',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'IT Helpdesk System',
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurface.withOpacity(0.6),
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 48),

            CircularProgressIndicator(
              color: colorScheme.primary,
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
