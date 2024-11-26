import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_submission_2/provider/add_location_provider.dart';

class AddLocationScreen extends StatelessWidget {
  static const routeName = '/addLocation';
  const AddLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Location")),
      floatingActionButton: Consumer<AddLocationProvider>(
        builder: (context, locationManager, _) {
          if (locationManager.selectedLocation != null) {
            return FloatingActionButton(
              onPressed: () {
                context.pop(locationManager.selectedLocation);
              },
              child: const Icon(Icons.check),
            );
          }
          return Container(); // Return an empty container when no action button is needed
        },
      ),
      body: Consumer<AddLocationProvider>(
        builder: (context, locationManager, _) {
          return FutureBuilder<LatLng>(
            future: locationManager.getCurrentLocation(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: snapshot.data!,
                    zoom: 18,
                  ),
                  onMapCreated: locationManager.setMapController,
                  onTap: locationManager.selectLocation,
                  markers: locationManager.markers, // Ensure markers are used here
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        },
      ),
    );
  }
}