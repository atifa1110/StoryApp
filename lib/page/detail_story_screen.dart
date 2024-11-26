import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_submission_2/component/lottie_widget.dart';
import 'package:story_submission_2/data/preferences/preferences_helper.dart';

import '../data/api/api_service.dart';
import '../data/enum/state.dart';
import '../data/model/story.dart';
import '../provider/story_detail_provider.dart';
import '../theme/resources.dart';
import 'package:geocoding/geocoding.dart' as geo;

class DetailStoryScreen extends StatefulWidget {
  static const routeName = '/detailStory';

  final String storyId;
  final bool isBackButtonShow;

  const DetailStoryScreen({super.key, required this.isBackButtonShow, required this.storyId});

  @override
  State<DetailStoryScreen> createState() => _StoryDetailPageState();

}

class _StoryDetailPageState extends State<DetailStoryScreen> {
  late final Set<Marker> markers = {};
  geo.Placemark? placemark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Story")),
      body: SafeArea(
        child: ChangeNotifierProvider<DetailStoryProvider>(
          create: (context) => DetailStoryProvider(
              ApiService(), widget.storyId, PreferencesHelper(SharedPreferences.getInstance())
          ),
          builder: (context, child) => Consumer<DetailStoryProvider>(
            builder: (context, provider, _) {
              switch (provider.state) {
                case ResultState.loading:
                  return const Center(child: CircularProgressIndicator());
                case ResultState.hasData:
                  var story = provider.story;
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 400,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(story.photoUrl??""),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          story.name??"",
                                          style: Theme.of(context).textTheme.headlineSmall,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Description :',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                story.description??"",
                                textAlign: TextAlign.justify,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        if (provider.story.lat != null &&
                            provider.story.lon != null)
                          _buildMap(provider.story)
                      ],
                    ),
                  );
                case ResultState.error:
                  return LottieWidget(
                    assets: Resources.lottieEmpty,
                    description: 'No Result',
                    subtitle: provider.message,
                    onRefresh: (){
                      // Call the refresh method on RestaurantProvider
                      context.read<DetailStoryProvider>().refresh(widget.storyId);
                    },
                  );
                case ResultState.noData:
                  return LottieWidget(
                    assets: Resources.lottieEmpty,
                    description: 'No Result',
                    subtitle: provider.message,
                    onRefresh: (){
                      // Call the refresh method on RestaurantProvider
                      context.read<DetailStoryProvider>().refresh(widget.storyId);
                    },
                  );
                default:
                  return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMap(Story story) {
    final location = LatLng(story.lat!, story.lon!);

    Future<void> onMapCreated(GoogleMapController controller) async {
      final info = await geo.placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );
      final place = info[0];
      final street = place.street!;
      final address =
          '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

      setState(() {
        placemark = place;
      });

      final marker = Marker(
        markerId: MarkerId(story.id!),
        position: location,
        infoWindow: InfoWindow(
          title: street,
          snippet: address,
        ),
      );
      markers.add(marker);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(12),
          child: const Text(
            'Address',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        if (placemark != null) Placemark(placemark: placemark!),
        Container(
          height: 320,
          width: double.infinity,
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: GoogleMap(
            onMapCreated: onMapCreated,
            mapToolbarEnabled: false,
            zoomGesturesEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            markers: markers.toSet(),
            initialCameraPosition: CameraPosition(
              target: location,
              zoom: 18,
            ),
          ),
        )
      ],
    );
  }
}

class Placemark extends StatelessWidget {
  final geo.Placemark placemark;

  const Placemark({super.key, required this.placemark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(placemark.street!),
                const SizedBox(height: 10),
                Text(
                  '${placemark.subLocality}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

