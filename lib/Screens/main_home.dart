import 'package:flutter/material.dart';

// same-folder imports
import 'home_page.dart';          // Combined Rescue + Mandals
import 'map_page.dart';
import 'lost_found_page.dart';
import 'info_page.dart';

class MainHome extends StatefulWidget {
  final int initialIndex;
  const MainHome({super.key, this.initialIndex = 0});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  late int _index;

  final _pages = const <Widget>[
    HomePage(),        // 0 — Rescue + Mandals ek page
    MapPage(),         // 1 — Map
    LostFoundPage(),   // 2 — Lost & Found
    InfoPage(),        // 3 — Info
  ];

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex.clamp(0, _pages.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => _index = i),
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.emergency_share_rounded),
            label: 'SOS',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.map_rounded), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Lost & Found'),
          BottomNavigationBarItem(icon: Icon(Icons.info_outline_rounded), label: 'Info'),
        ],
      ),
    );
  }
}
