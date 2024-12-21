import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hedieaty/home/base_tab_screen.dart';
import 'package:hedieaty/onboarding/signup_screen/signup_screen.dart';
import 'package:hedieaty/onboarding/login_screen/login_viewmodel.dart';
import 'package:provider/provider.dart'; // Import provider to use ChangeNotifierProvider
import 'package:validators/validators.dart'; // Import validator package

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Create TextEditingControllers for email and password
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Log In'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Navigate back to the WelcomeScreen
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Header graphic image
                    SvgPicture.asset(
                      'assets/header.svg',
                      height: 200,
                      width: 200,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 40),
                    // Email field
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    // Password field
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.lock),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 40),
                    // Log In button
                    Consumer<LoginViewModel>(
                      builder: (context, viewModel, child) {
                        return ElevatedButton(
                          onPressed: viewModel.isLoading
                              ? null
                              : () {
                            // Fetch email and password from the controllers
                            final email = emailController.text;
                            final password = passwordController.text;

                            // Validate Email
                            if (email.isEmpty || !isEmail(email)) {
                              // Show email validation error
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a valid email address'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            // Validate Password
                            if (password.isEmpty || password.length < 6) {
                              // Show password validation error
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Password must be at least 6 characters'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            // Trigger login action
                            context.read<LoginViewModel>().login(email, password).then((_) {
                              if (viewModel.errorMessage.isEmpty) {
                                // Navigate to Home or another page if login is successful
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BaseTabScreen(),
                                  ),
                                      (Route<dynamic> route) => false, // Remove all previous routes
                                );
                              } else {
                                // Show error message using a Snackbar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(viewModel.errorMessage),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: viewModel.isLoading
                              ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                              : const Text(
                            'Log In',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    // Sign Up prompt
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const SignUpScreen()),
                            );
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}