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
          Text("Pune Darshan ", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text("By YASH PURI,PvgCOET,Pune", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
          Text("A simple app for lost person reports, route guidance, and Lost & Found in the crowd."),
          SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.phone, color: Colors.deepOrange),
            title: Text("Emergency Helpline: 112"),
          ),
          ListTile(
            leading: Icon(Icons.shield, color: Colors.deepOrange),
            title: Text("Privacy"),
            subtitle: Text("Submitted reports reach only the rescue team."),
          ),
        ],
      ),
    );
  }
}
