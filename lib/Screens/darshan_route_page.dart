// lib/screens/darshan_route_page.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

import '../data/mandals.dart';

// ----- IMPORTANT -----
// 1) Replace with your real Directions API key that has Maps + Directions enabled.
const String kGoogleApiKey = 'YOUR_GOOGLE_DIRECTIONS_API_KEY_HERE';
// ----------------------

class DarshanRoutePage extends StatefulWidget {
  const DarshanRoutePage({super.key});

  @override
  State<DarshanRoutePage> createState() => _DarshanRoutePageState();
}

class _DarshanRoutePageState extends State<DarshanRoutePage> {
  final Completer<GoogleMapController> _ctrl = Completer();
  static const CameraPosition _initialCamera = CameraPosition(
    target: LatLng(18.5204, 73.8567),
    zoom: 13,
  );

  final Set<Marker> _markers = {};
  Polyline? _routePolyline;
  List<LatLng> _routePoints = [];

  bool _loading = false;
  bool _started = false;

  // Use kMandals from your data file to build route stops in preferred order
  List<Mandal> get _stopsOrdered {
    // Example: choose Manacha top5 first (or provide your own ordering).
    final stops = kMandals.where((m) => m.tag == 'Manacha').toList();
    // If you want custom sequence, rearrange here.
    // For now keep as sorted by manachaRank then append famous ones.
    stops.sort((a, b) => (a.manachaRank ?? 999).compareTo(b.manachaRank ?? 999));
    final more = kMandals.where((m) => m.tag != 'Manacha').toList();
    return [...stops, ...more];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _setupMarkers());
  }

  Future<void> _setupMarkers() async {
    // Create markers for stops
    final markers = <Marker>{};
    for (final m in _stopsOrdered) {
      if (m.lat != null && m.lng != null) {
        markers.add(Marker(
          markerId: MarkerId(m.name),
          position: LatLng(m.lat!, m.lng!),
          infoWindow: InfoWindow(title: m.name, snippet: m.area),
        ));
      }
    }
    setState(() => _markers.addAll(markers));
  }

  Future<Position?> _determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }
      if (permission == LocationPermission.deniedForever) return null;
      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      return pos;
    } catch (_) {
      return null;
    }
  }

  // Decode encoded polyline into LatLng list
  List<LatLng> _decodePolyline(String encoded) {
    final List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int shift = 0;
      int result = 0;
      while (true) {
        final int b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
        if (b < 0x20) break;
      }
      final int dlat = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      while (true) {
        final int b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
        if (b < 0x20) break;
      }
      final int dlng = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      poly.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return poly;
  }

  // Build directions URL for a single leg (two points)
  Uri _directionsUrlFor(LatLng a, LatLng b) {
    final origin = '${a.latitude},${a.longitude}';
    final dest = '${b.latitude},${b.longitude}';
    // mode=driving for road-following
    return Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$dest&mode=driving&key=$kGoogleApiKey');
  }

  // Core: request directions sequentially for each leg and combine polylines
  Future<void> _buildRouteFromCurrentLocation() async {
    setState(() => _loading = true);
    try {
      // Determine origin (current position). If unavailable, use first stop.
      Position? pos = await _determinePosition();
      LatLng origin;
      if (pos != null) {
        origin = LatLng(pos.latitude, pos.longitude);
      } else {
        final first = _stopsOrdered.firstWhere((s) => s.lat != null && s.lng != null,
            orElse: () => kMandals.first);
        origin = LatLng(first.lat ?? 18.5204, first.lng ?? 73.8567);
      }

      // Build list of waypoints as LatLng existing stops (skip null coords)
      final waypoints = <LatLng>[];
      for (final m in _stopsOrdered) {
        if (m.lat != null && m.lng != null) {
          waypoints.add(LatLng(m.lat!, m.lng!));
        }
      }

      if (waypoints.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No stops available')));
        setState(() => _loading = false);
        return;
      }

      // Full list: origin + waypoints
      final full = <LatLng>[];
      full.add(origin);
      full.addAll(waypoints);

      final segments = <String>[];

      // Sequentially request directions for each leg (i -> i+1)
      for (int i = 0; i < full.length - 1; i++) {
        final a = full[i];
        final b = full[i + 1];
        final url = _directionsUrlFor(a, b);

        final resp = await http.get(url).timeout(const Duration(seconds: 10));
        if (resp.statusCode != 200) {
          debugPrint('Directions leg $i failed status=${resp.statusCode}');
          continue;
        }
        final Map<String, dynamic> map = json.decode(resp.body);
        final status = (map['status'] ?? '') as String;
        if (status != 'OK') {
          debugPrint('Directions leg $i api status=$status');
          continue;
        }
        final routes = map['routes'] as List<dynamic>? ?? [];
        if (routes.isEmpty) continue;
        final encoded = routes[0]['overview_polyline']?['points'] as String?;
        if (encoded != null && encoded.isNotEmpty) {
          segments.add(encoded);
        }
        // polite small delay
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // Combine decoded points while avoiding duplicates at seams
      final combined = <LatLng>[];
      for (final enc in segments) {
        final pts = _decodePolyline(enc);
        if (pts.isEmpty) continue;
        if (combined.isNotEmpty) {
          final last = combined.last;
          final firstNew = pts.first;
          if ((last.latitude - firstNew.latitude).abs() < 0.000001 &&
              (last.longitude - firstNew.longitude).abs() < 0.000001) {
            combined.addAll(pts.skip(1));
            continue;
          }
        }
        combined.addAll(pts);
      }

      if (combined.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to build route')));
      } else {
        _routePoints = combined;
        _routePolyline = Polyline(
          polylineId: const PolylineId('darshan_route'),
          points: _routePoints,
          color: Colors.deepOrange,
          width: 6,
          jointType: JointType.round,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        );

        // Add marker for current origin too (blue)
        _markers.add(Marker(
          markerId: const MarkerId('origin_marker'),
          position: origin,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: const InfoWindow(title: 'You (start)'),
        ));

        // Move camera to show full route bounds
        await _moveCameraToFitPolyline(_routePoints);
      }
    } catch (e, st) {
      debugPrint('Error building route: $e\n$st');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error building route')));
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _moveCameraToFitPolyline(List<LatLng> pts) async {
    if (pts.isEmpty) return;
    double minLat = pts.first.latitude, maxLat = pts.first.latitude;
    double minLng = pts.first.longitude, maxLng = pts.first.longitude;
    for (final p in pts) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }
    final sw = LatLng(minLat, minLng);
    final ne = LatLng(maxLat, maxLng);
    final controller = await _ctrl.future;
    final bounds = LatLngBounds(southwest: sw, northeast: ne);
    // small padding
    await controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 60));
  }

  Future<void> _onStartPressed() async {
    if (_started) return;
    setState(() => _started = true);
    await _buildRouteFromCurrentLocation();
    setState(() => _started = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.flag),
            SizedBox(width: 8),
            Text("Pune Ganpati Darshan Route"),
          ],
        ),
        backgroundColor: Colors.deepOrange,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialCamera,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: _markers,
            polylines: _routePolyline != null ? {_routePolyline!} : {},
            onMapCreated: (c) => _ctrl.complete(c),
            padding: const EdgeInsets.only(bottom: 120),
            mapToolbarEnabled: false,
          ),
          if (_loading)
            const Positioned(
              left: 16,
              right: 16,
              top: 16,
              child: LinearProgressIndicator(),
            ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _loading ? null : _onStartPressed,
              icon: Icon(_routePolyline == null ? Icons.play_arrow : Icons.redo),
              label: Text(
                _routePolyline == null ? "Start Pune Ganpati Darshan" : "Rebuild Route",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}