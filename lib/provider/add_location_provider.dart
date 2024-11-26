
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class AddLocationProvider extends ChangeNotifier {
  LatLng? _selectedLocation;
  final Set<Marker> _markers = {};
  GoogleMapController? _mapController;

  LatLng? get selectedLocation => _selectedLocation;
  Set<Marker> get markers => _markers;

  @override
  void dispose() {
    super.dispose();
    _mapController?.dispose();
  }

  Future<LatLng> getCurrentLocation() async {
    final location = Location();
    try {
      LocationData locationData = await location.getLocation();
      return LatLng(locationData.latitude ?? 0, locationData.longitude ?? 0);
    } catch (e) {
      throw Exception('Failed to get location: $e');
    }
  }

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  void selectLocation(LatLng latLng) {
    _selectedLocation = latLng;
    _markers.clear();
    _markers.add(Marker(
      markerId: const MarkerId('selectedLocation'),
      position: latLng,
    ));
    debugPrint('Markers: $_markers'); // Log marker details
    notifyListeners();
  }


  void clear() {
    _selectedLocation = null;
    _markers.clear();
    _mapController?.dispose();
    notifyListeners();
  }
}