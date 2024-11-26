import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_submission_2/data/preferences/preferences_helper.dart';
import 'package:story_submission_2/page/add_story_screen.dart';
import 'package:story_submission_2/routing/app_routes.dart';

import '../data/api/api_service.dart';
import '../data/enum/state.dart';
import '../data/request/add_story_request.dart';

class AddStoryProvider extends ChangeNotifier {
  final ApiService apiService;
  final PreferencesHelper preferencesHelper;

  AddStoryProvider(this.apiService, this.preferencesHelper);

  ResultState? _state;
  ResultState? get state => _state;

  String _message = "";
  String get message => _message;

  final TextEditingController descriptionController = TextEditingController();

  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  Future<void> selectImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      _selectedImage = File(pickedImage.path);
      notifyListeners();
    }
  }

  LatLng? _selectedLocation;
  LatLng? get selectedLocation => _selectedLocation;

  void updateSelectedLocation(LatLng? location) {
    _selectedLocation = location;
    notifyListeners(); // Notify listeners of the change
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  Future<dynamic> addStory(BuildContext context) async {
    String token = await preferencesHelper.getToken;
    final request = AddStoryRequest(
        description: descriptionController.text,
        photo: selectedImage?? File(""),
        lat: selectedLocation?.latitude ?? 0.0, // Use null-aware operator
        lon: selectedLocation?.longitude ?? 0.0, // Use null-aware operator
    );

    try {
      _state = ResultState.loading;
      notifyListeners();

      final detailStoryResult = await apiService.addStory(request,token);

      if (detailStoryResult.error == true) {
        _state = ResultState.error;
        _message = detailStoryResult.message ?? "Error when uploading!";
      } else {
        _state = ResultState.hasData;
        _message = detailStoryResult.message ?? "Success upload story!";
        if (context.mounted) {
          context.goNamed(Routes.home.name);
        }
      }
    } on SocketException {
      _state = ResultState.error;
      _message = "Error: No Internet Connection";
    } catch (e) {
      _state = ResultState.error;
      _message = "Error: $e";
    } finally {
      notifyListeners();
    }
  }
}