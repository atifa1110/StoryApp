import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_submission_1/data/preferences/preferences_helper.dart';
import '../common/app_theme.dart';
import '../common/show_toast.dart';
import '../data/api/api_service.dart';
import '../data/enum/state.dart';
import '../provider/login_provider.dart';
import '../routing/app_routes.dart';

class LoginScreen extends StatefulWidget {
  //final VoidCallback onLoginSuccess;
  //final VoidCallback onRegisterClicked;

  const LoginScreen({
        super.key,
        //required this.onLoginSuccess,
        //required this.onRegisterClicked
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: ChangeNotifierProvider<LoginProvider>(
              create: (context) => LoginProvider(ApiService(), PreferencesHelper(SharedPreferences.getInstance())),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome Back',
                          style: AppThemes.headline2,
                        ),
                        Text(
                          'Sign In and Start Your Next Story Adventure',
                          style: AppThemes.text1.copyWith(color: AppThemes.darkGrey),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                    Form(
                        key: _formKey,
                        child: Consumer<LoginProvider>(
                            builder: (context, provider, child) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
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
                                          borderRadius: BorderRadius.circular(10), // Rounded corners with radius 10
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: const BorderSide(color: Colors.grey), // Border color for enabled state
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: const BorderSide(color: Colors.blue), // Border color when focused
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: provider.passwordController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your password!';
                                        } else if(value.length<8){
                                          return 'Password must be more than 8 characters!';
                                        }
                                        return null;
                                      },
                                      obscureText: provider.isHide,
                                      decoration: InputDecoration(
                                        hintText: "Password",
                                        hintStyle: AppThemes.text1,
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            provider.isHide
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                          ),
                                          onPressed: () {
                                            provider.onChangeObscure();
                                          },
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10), // Rounded corners with radius 10
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: const BorderSide(color: Colors.grey), // Border color for enabled state
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: const BorderSide(color: Colors.blue), // Border color when focused
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 48),
                                    Consumer<LoginProvider>(
                                      builder: (context, provider, _) {
                                        _handleState(provider);
                                        return SizedBox(
                                          height: 48,
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue, // Button background color
                                              foregroundColor: Colors.white, // Text color
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10), // Makes the button square
                                              ),
                                            ),
                                            onPressed: () => {
                                              if (_formKey.currentState?.validate() == true){
                                                  provider.login(context),
                                                }
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                if (provider.loginState ==
                                                    ResultState.loading) ...[
                                                  const SizedBox(
                                                    width: 40 * 0.5,
                                                    height: 40 * 0.5,
                                                    child: CircularProgressIndicator(),
                                                  ),
                                                  const SizedBox(width: 8),
                                                ],
                                                Text('Login', style: AppThemes.text1.copyWith(color: Colors.white))
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 32),
                                    Text.rich(
                                      textAlign: TextAlign.center,
                                      TextSpan(
                                        text: "Don't have an account? ",
                                        style: AppThemes.text1, // Your base style here
                                        children: [
                                          TextSpan(
                                            text: "Register",
                                            style: AppThemes.text1.copyWith(color: Colors.blue), // Change color here
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                // Handle the "Register" tap action
                                                print("Navigate to Register Page");
                                                context.pushNamed(
                                                  Routes.register.name,
                                                );
                                              },
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }
                        )
                    )
                  ],
                ),
              ),
            ),
          ),
      ),
    );
  }

  _handleState(LoginProvider provider) {
    switch (provider.loginState) {
      case ResultState.hasData:
        showToast(provider.loginMessage);
        //afterBuildWidgetCallback(widget.onLoginSuccess);
        break;
      case ResultState.noData:
        showToast(provider.loginMessage);
        break;
      case ResultState.error:
        showToast(provider.loginMessage);
        break;
      default:
        break;
    }
  }
}