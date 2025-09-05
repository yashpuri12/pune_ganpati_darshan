// lib/screens/mandal_details_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../data/mandals.dart';

class MandalDetailsPage extends StatefulWidget {
  final Mandal mandal;
  const MandalDetailsPage({super.key, required this.mandal});

  @override
  State<MandalDetailsPage> createState() => _MandalDetailsPageState();
}

class _MandalDetailsPageState extends State<MandalDetailsPage> {
  GoogleMapController? _mapController;

  void _openMapSheet(BuildContext context) {
    final lat = widget.mandal.lat;
    final lng = widget.mandal.lng;
    if (lat == null || lng == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.78,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(lat, lng),
            zoom: 16,
          ),
          markers: {
            Marker(
              markerId: MarkerId(widget.mandal.name),
              position: LatLng(lat, lng),
              infoWindow:
              InfoWindow(title: widget.mandal.name, snippet: widget.mandal.area),
            )
          },
          onMapCreated: (c) => _mapController = c,
        ),
      ),
    );
  }

  Widget _buildBanner(String? path, double height) {
    // Banner with orange gradient background + image centered (BoxFit.contain)
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Orange soft gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade200, Colors.orange.shade100],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Centered image (contain so not cropped). If asset path starts with '/',
          // treat as file; else asset.
          if (path == null)
            const Center(child: Icon(Icons.temple_hindu, size: 84, color: Colors.white70))
          else
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: height - 24,
                  maxWidth: MediaQuery.of(context).size.width - 40,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: path.startsWith('/')
                      ? Image.file(File(path), fit: BoxFit.contain, alignment: Alignment.center)
                      : Image.asset(path, fit: BoxFit.contain, alignment: Alignment.center),
                ),
              ),
            ),

          // Soft top dark overlay to ensure icons/back-button visible
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.28), Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.deepOrange.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.deepOrange.withOpacity(.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.deepOrange),
          const SizedBox(width: 6),
          Text(text,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 13.5)),
        ],
      ),
    );
  }

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
              offset: const Offset(0, 6))
        ],
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange)),
            const SizedBox(height: 8),
            child,
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mandal = widget.mandal;
    final screenW = MediaQuery.of(context).size.width;
    // banner height tuned so image shows well but doesn't take entire screen
    final bannerH = (screenW * 0.62).clamp(220.0, 360.0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top banner area
          Stack(
            children: [
              _buildBanner(mandal.image, bannerH),
              // Back button placed in SafeArea
              Positioned(
                left: 12,
                top: MediaQuery.of(context).padding.top + 8,
                child: Material(
                  color: Colors.black45,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => Navigator.pop(context),
                    child: const SizedBox(
                      width: 46,
                      height: 46,
                      child: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // The white content area overlapping banner (no large bottom gap)
          Expanded(
            child: Container(
              // move upward so banner overlaps nicely and no bottom gap
              transform: Matrix4.translationValues(0, -28, 0),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.deepOrange.withOpacity(.06),
                      blurRadius: 20,
                      offset: const Offset(0, -10)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + area
                  Text(mandal.name,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Colors.black87)),
                  Text(mandal.area,
                      style: const TextStyle(color: Colors.black54, fontSize: 15)),
                  const SizedBox(height: 14),

                  // Quick chips
                  Wrap(spacing: 8, runSpacing: 10, children: [
                    _glassChip(Icons.login, "Entry: ${mandal.entry}"),
                    _glassChip(Icons.logout, "Exit: ${mandal.exit}"),
                    _glassChip(Icons.access_time, mandal.timings),
                    _glassChip(Icons.verified,
                        mandal.tag == "Manacha"
                            ? "Manacha • ${mandal.manachaRank ?? '-'}"
                            : mandal.tag),
                  ]),
                  const SizedBox(height: 16),

                  // Content scroll area (ensures location card sits at its natural place)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if ((mandal.description ?? '').isNotEmpty)
                            _sectionCard(
                                title: "About",
                                child: Text(mandal.description!,
                                    style: const TextStyle(
                                        height: 1.45, fontSize: 15))),
                          if ((mandal.year2025 ?? '').isNotEmpty)
                            _sectionCard(
                                title: "Special 2025",
                                child: Row(children: [
                                  const Icon(Icons.event, color: Colors.deepOrange),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Text(mandal.year2025!,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600))),
                                ])),

                          // Location card — will appear after other sections, no extra bottom gap
                          if (mandal.lat != null && mandal.lng != null)
                            _sectionCard(
                                title: "Location",
                                child: Row(
                                  children: [
                                    const Icon(Icons.place, color: Colors.deepOrange),
                                    const SizedBox(width: 8),
                                    Expanded(
                                        child: Text("${mandal.lat}, ${mandal.lng}",
                                            style: const TextStyle(fontSize: 13))),
                                    const SizedBox(width: 12),
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.deepOrange,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10))),
                                      onPressed: () => _openMapSheet(context),
                                      icon: const Icon(Icons.map, size: 18),
                                      label: const Text("View on map"),
                                    )
                                  ],
                                )),

                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}