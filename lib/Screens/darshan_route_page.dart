import 'package:flutter/material.dart';

class DarshanRoutePage extends StatelessWidget {
  const DarshanRoutePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🚩 Pune Ganpati Darshan Route"),
        backgroundColor: Colors.deepOrange,
      ),
      body: const Center(
        child: Text(
          "Yaha map + route ayega 🚩",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
