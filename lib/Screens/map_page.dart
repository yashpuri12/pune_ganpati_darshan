import 'package:flutter/material.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📍 Ganpati Route Map"),
        backgroundColor: Colors.deepOrange,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            "Windows desktop par Google Map widget limited hota hai.\n"
                "Android/iOS me API key add karoge to markers + routes dikhenge.\n\n"
                "Abhi ke liye yahan entry/exit instructions aur static route info dikha sakte hain.",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
