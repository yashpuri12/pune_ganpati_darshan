import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? mapController;
  bool _locationAllowed = false;
  bool _mapError = false;

  final LatLng _center = const LatLng(18.5204, 73.8567);

  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId("kasba"),
      position: LatLng(18.5164, 73.8567),
      infoWindow: InfoWindow(title: "Kasba Ganpati"),
    ),
    const Marker(
      markerId: MarkerId("dagdusheth"),
      position: LatLng(18.5165, 73.8540),
      infoWindow: InfoWindow(title: "Dagdusheth Ganpati"),
    ),
    const Marker(
      markerId: MarkerId("tulshibaug"),
      position: LatLng(18.5149, 73.8530),
      infoWindow: InfoWindow(title: "Tulshibaug Ganpati"),
    ),
  };

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      setState(() {
        _locationAllowed = true;
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📍 Pune Darshan Map"),
        backgroundColor: Colors.deepOrange,
      ),
      body: SafeArea(
        child: _mapError
            ? const Center(
                child: Text(
                  "⚠️ Map load nahi ho paaya.\n\nCheck your internet & API key restrictions.",
                  textAlign: TextAlign.center,
                ),
              )
            : GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 14.0,
                ),
                markers: _markers,
                myLocationEnabled: _locationAllowed,
                myLocationButtonEnabled: _locationAllowed,
                zoomControlsEnabled: true,
                onCameraMoveStarted: () {
                  // agar rendering stuck hai to at least handle karenge
                  if (!_locationAllowed) {
                    debugPrint("⚠️ Location permission not granted.");
                  }
                },
                onTap: (pos) {
                  // agar map tap hua to confirm ho jaaye ke map render ho raha hai
                  setState(() => _mapError = false);
                },
                onCameraIdle: () {
                  // agar map frame render fail ho raha ho to detect karke safe exit
                  if (mounted && mapController == null) {
                    setState(() => _mapError = true);
                  }
                },
              ),
      ),
    );
  }
}
