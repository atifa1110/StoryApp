import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_submission_1/page/login_screen.dart';
import 'package:story_submission_1/routing/app_routes.dart';

import '../common/show_toast.dart';
import '../data/api/api_service.dart';
import '../data/enum/state.dart';
import '../data/preferences/preferences_helper.dart';
import '../provider/add_story_provider.dart';

class AddStoryScreen extends StatefulWidget {
  const AddStoryScreen({super.key});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Story")),
      body: ChangeNotifierProvider<AddStoryProvider>(
        create: (context) => AddStoryProvider(
          ApiService(),
          PreferencesHelper(SharedPreferences.getInstance()),
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
            child: Form(
                key: _formKey,
                child: Consumer<AddStoryProvider>(
                    builder: (context, provider, _) {
                      _handleState(provider);
                      return Column(
                        children: [
                          Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              color: Theme.of(context).dividerColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(16),
                              ),
                            ),
                            child: InkWell(
                              onTap: () => provider.selectImage(),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  if (provider.selectedImage != null)
                                    Opacity(
                                      opacity: 0.8,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(16),
                                        ),
                                        child: Image.file(
                                          provider.selectedImage!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  Text(
                                    "Select Image",
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: provider.descriptionController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter description!';
                              }
                              return null;
                            },
                            maxLines: 4,
                            decoration: InputDecoration(
                              labelText: "Description",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState?.validate() == true && provider.selectedImage != null) {
                                provider.addStory(context);
                              }else if (provider.selectedImage == null) {
                                showToast("Please select an image before uploading.");
                              }
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Upload')
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                )
            ),
          ),
        ),
      ),
    );
  }

  void _handleState(AddStoryProvider provider) {
    switch (provider.state) {
      case ResultState.hasData:
        showToast(provider.message);
        break;
      case ResultState.noData:
        showToast(provider.message);
        break;
      case ResultState.error:
        showToast(provider.message);
        break;
      default:
        break;
    }
  }
}
