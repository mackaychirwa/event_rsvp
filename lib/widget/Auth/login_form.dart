import 'package:event_rsvp/core/bloc/auth_loading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../constant/sizes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_rsvp/core/bloc/auth_bloc.dart';
import 'package:event_rsvp/core/bloc/auth_error.dart';
import 'package:event_rsvp/core/bloc/auth_success.dart';
class login_form extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: CSizes.spaceBtwSections),
        child: Column(
          children: [
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  FontAwesomeIcons.user,
                ),
                labelText: "Enter Email",
              ),
            ),
            const SizedBox(height: CSizes.spaceBtwInputFields),
            TextFormField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                prefixIcon: Icon(FontAwesomeIcons.userSecret),
                labelText: "Enter Password",
                suffixIcon: Icon(
                  FontAwesomeIcons.eyeSlash,
                  size: 15,
                ),
              ),
            ),
            const SizedBox(height: CSizes.spaceBtwInputFields / 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(value: true, onChanged: (value) {}),
                    const Text("Remember Me")
                  ],
                ),
                TextButton(
                    onPressed: () {}, child: const Text("Forgot Password"))
              ],
            ),

            const SizedBox(height: CSizes.spaceBtwSections),
            BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text("Wrong combination of email/password ")),
                    );
                  }
                  if (state is AuthSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Welcome to RSVP')),
                      );
                      emailController.clear();
                      passwordController.clear();
                      Navigator.pushReplacementNamed(context, '/bottomNav');
                    }
                },
                builder: (context, state) {
                  return Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 1.2,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthCubit>().signIn(
                            emailController.text,
                            passwordController.text,
                          );
                        }
                      },
                      child: Center(
                        child: state is AuthLoading
                            ? const SizedBox(
                                height: 21.0,
                                width: 21.0,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Sign In',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: CSizes.spaceBtwItems),
            const SizedBox(height: CSizes.spaceBtwItems),

            /// Social Media Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialIcon(FontAwesomeIcons.facebookF, Colors.blue),
                const SizedBox(width: 20),
                _buildSocialIcon(FontAwesomeIcons.google, Colors.red),
                const SizedBox(width: 20),
                _buildSocialIcon(FontAwesomeIcons.x, Colors.black),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}
