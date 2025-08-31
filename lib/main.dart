import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const PuneGanpatiDarshanApp());
}

class PuneGanpatiDarshanApp extends StatelessWidget {
  const PuneGanpatiDarshanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pune Ganpati Darshan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
