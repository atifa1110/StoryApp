import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_submission_1/provider/register_provider.dart';
import '../common/app_theme.dart';
import '../common/show_toast.dart';
import '../data/api/api_service.dart';
import '../data/enum/state.dart';
import '../routing/app_routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: ChangeNotifierProvider<RegisterProvider>(
            create: (context) => RegisterProvider(ApiService()),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Journey Awaits',
                        style: AppThemes.headline2,
                      ),
                      Text(
                        'Create an account to embark on endless storytelling adventures.',
                        style: AppThemes.text1.copyWith(color: AppThemes.darkGrey),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                  Form(
                    key: _formKey,
                    child: Consumer<RegisterProvider>(
                      builder: (context, provider, child) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                controller: provider.nameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name!';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "Name",
                                  hintStyle: AppThemes.text1,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: Colors.blue),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: provider.emailController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email!';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  hintStyle: AppThemes.text1,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: Colors.blue),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: provider.passwordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password!';
                                  }
                                  return null;
                                },
                                obscureText: provider.isHide,
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  hintStyle: AppThemes.text1,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      provider.isHide ? Icons.visibility : Icons.visibility_off,
                                    ),
                                    onPressed: provider.onChangeObscure,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: Colors.blue),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 48),
                              _handleState(provider) ?? SizedBox.shrink(),
                              SizedBox(
                                height: 48,
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState?.validate() == true) {
                                      provider.register(context);
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      if (provider.registerState == ResultState.loading) ...[
                                        const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(),
                                        ),
                                        const SizedBox(width: 8),
                                      ],
                                      Text(
                                        'Register',
                                        style: AppThemes.text1.copyWith(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              Center(
                                child: Text.rich(
                                  TextSpan(
                                    text: "Already have an account? ",
                                    style: AppThemes.text1,
                                    children: [
                                      TextSpan(
                                        text: "Login",
                                        style: AppThemes.text1.copyWith(color: Colors.blue),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            context.goNamed(
                                              Routes.login.name,
                                            );
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _handleState(RegisterProvider provider) {
    switch (provider.registerState) {
      case ResultState.hasData:
        showToast(provider.registerMessage);
        //afterBuildWidgetCallback(widget.onLoginSuccess);
        break;
      case ResultState.noData:
      case ResultState.error:
        showToast(provider.registerMessage);
        break;
      default:
        break;
    }
  }
}