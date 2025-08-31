import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ℹ️ About"), backgroundColor: Colors.deepOrange),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text("Pune Ganpati Rescue", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text("Bheed me lost person reports, route guidance aur Lost & Found ke liye simple app."),
          SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.phone, color: Colors.deepOrange),
            title: Text("Emergency Helpline: 112"),
          ),
          ListTile(
            leading: Icon(Icons.shield, color: Colors.deepOrange),
            title: Text("Privacy"),
            subtitle: Text("Submitted reports sirf rescue team tak pahunchte hain."),
          ),
        ],
      ),
    );
  }
}
