import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:math';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Polygon> _polygons = {};
  final Set<Marker> _markers = {};
  LatLng? _currentPosition;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _isLoading = false);
      Get.snackbar('Error', 'Location services are disabled');
      return;
    }

    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _isLoading = false);
        Get.snackbar('Error', 'Location permission denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _isLoading = false);
      Get.snackbar('Error', 'Location permission permanently denied');
      return;
    }

    // Get current position
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
      _updateMap();
    } catch (e) {
      setState(() => _isLoading = false);
      Get.snackbar('Error', 'Failed to get current location: $e');
    }
  }

  void _updateMap() {
    if (_currentPosition != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: _currentPosition!,
        ),
      );
      _polygons.add(
        Polygon(
          polygonId: const PolygonId('area'),
          points: _createRectangle(_currentPosition!, 2000),
          fillColor: Colors.red.withOpacity(0.1),
          strokeColor: Colors.red,
          strokeWidth: 2,
        ),
      );
    }
  }

  List<LatLng> _createRectangle(LatLng center, double radiusInMeters) {
    const double earthRadius = 6371000; // in meters
    final double lat = center.latitude * pi / 180;
    final double lon = center.longitude * pi / 180;
    final double distanceInRadians = radiusInMeters / earthRadius;
    final List<LatLng> corners = [];

    for (double bearing in [45, 135, 225, 315]) {
      final double bearingRad = bearing * pi / 180;
      final double lat2 = asin(sin(lat) * cos(distanceInRadians) +
          cos(lat) * sin(distanceInRadians) * cos(bearingRad));
      final double lon2 = lon +
          atan2(sin(bearingRad) * sin(distanceInRadians) * cos(lat),
              cos(distanceInRadians) - sin(lat) * sin(lat2));
      corners.add(LatLng(lat2 * 180 / pi, lon2 * 180 / pi));
    }
    return corners;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _currentPosition == null
              ? const Center(child: Text('Unable to get location'))
              : GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition!,
                    zoom: 14,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  markers: _markers,
                  polygons: _polygons,
                ),
    );
  }
}
