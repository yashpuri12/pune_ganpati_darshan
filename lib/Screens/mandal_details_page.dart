import 'dart:io';
import 'package:flutter/material.dart';
import '../data/mandals.dart';

class MandalDetailsPage extends StatelessWidget {
  final Mandal mandal;
  const MandalDetailsPage({super.key, required this.mandal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade100, Colors.orange.shade50],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Scroll content
          ListView(
            padding: EdgeInsets.zero,
            children: [
              // ===== Top Banner Image =====
              Stack(
                children: [
                  _buildBanner(mandal.image),
                  Positioned(
                    left: 12,
                    top: 40,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ],
              ),

              // ===== Content =====
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.08),
                      blurRadius: 15,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + Area
                    Text(
                      mandal.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      mandal.area,
                      style: const TextStyle(color: Colors.black54, fontSize: 15),
                    ),
                    const SizedBox(height: 16),

                    // Quick Info Chips
                    Wrap(
                      spacing: 8,
                      runSpacing: 10,
                      children: [
                        _glassChip(Icons.login, "Entry: ${mandal.entry}"),
                        _glassChip(Icons.logout, "Exit: ${mandal.exit}"),
                        _glassChip(Icons.access_time, mandal.timings),
                        _glassChip(
                          Icons.verified,
                          mandal.tag == "Manacha"
                              ? "Manacha • ${mandal.manachaRank ?? '-'}"
                              : mandal.tag,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Description
                    if ((mandal.description ?? '').isNotEmpty)
                      _sectionCard(
                        title: "About",
                        child: Text(
                          mandal.description!,
                          style: const TextStyle(height: 1.45, fontSize: 15),
                        ),
                      ),

                    // 2025 Special
                    if ((mandal.year2025 ?? '').isNotEmpty)
                      _sectionCard(
                        title: "Special 2025",
                        child: Row(
                          children: [
                            const Icon(Icons.event, color: Colors.deepOrange),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                mandal.year2025!,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Location
                    if (mandal.lat != null && mandal.lng != null)
                      _sectionCard(
                        title: "Location",
                        child: Row(
                          children: [
                            const Icon(Icons.place, color: Colors.deepOrange),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "${mandal.lat}, ${mandal.lng}\n(Android build me live map markers add karenge.)",
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Banner Image with full view (no cut) + orange background + soft gradient
  Widget _buildBanner(String? path) {
    final tag = mandal.name; // same hero tag

    return Container(
      height: 240,
      width: double.infinity,
      color: Colors.deepOrange.shade100,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: tag,
            child: path == null
                ? Container(color: Colors.orange.shade200)
                : (path.startsWith('/')
                ? Image.file(File(path), fit: BoxFit.contain, alignment: Alignment.center)
                : Image.asset(path, fit: BoxFit.contain, alignment: Alignment.center)),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(.3), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Glassmorphic Chip
  Widget _glassChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.deepOrange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.deepOrange.withOpacity(.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.deepOrange),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
          ),
        ],
      ),
    );
  }

  // Section Card
  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
