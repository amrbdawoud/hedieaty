import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hedieaty/home/base_tab_screen.dart';
import 'package:hedieaty/onboarding/signup_screen/signup_screen.dart';
import 'package:hedieaty/onboarding/login_screen/login_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('Log In', style: TextStyle(color: Colors.white)),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Theme.of(context).primaryColor.withOpacity(0.1)],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/header.svg',
                        height: 200,
                        width: 200,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 40),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                          hintText: 'Enter your email',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                          ),
                          prefixIcon: Icon(Icons.email, color: Theme.of(context).primaryColor),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                          hintText: 'Enter your password',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                          ),
                          prefixIcon: Icon(Icons.lock, color: Theme.of(context).primaryColor),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 40),
                      Consumer<LoginViewModel>(
                        builder: (context, viewModel, child) {
                          return ElevatedButton(
                            onPressed: viewModel.isLoading
                                ? null
                                : () {
                              final email = emailController.text;
                              final password = passwordController.text;

                              if (email.isEmpty || !isEmail(email)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Please enter a valid email address'),
                                    backgroundColor: Theme.of(context).colorScheme.error,
                                  ),
                                );
                                return;
                              }

                              if (password.isEmpty || password.length < 6) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Password must be at least 6 characters'),
                                    backgroundColor: Theme.of(context).colorScheme.error,
                                  ),
                                );
                                return;
                              }

                              context.read<LoginViewModel>().login(email, password).then((_) {
                                if (viewModel.errorMessage.isEmpty) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => const BaseTabScreen()),
                                        (Route<dynamic> route) => false,
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(viewModel.errorMessage),
                                      backgroundColor: Theme.of(context).colorScheme.error,
                                    ),
                                  );
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: viewModel.isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                              'Log In',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(color: Theme.of(context).primaryColor),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const SignUpScreen()),
                              );
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
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
      ),
    );
  }
}