import 'package:event_rsvp/core/bloc/auth_bloc.dart';
import 'package:event_rsvp/core/bloc/auth_error.dart';
import 'package:event_rsvp/core/bloc/auth_loading.dart';
import 'package:event_rsvp/core/bloc/auth_success.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../../constant/sizes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SignupForm extends StatefulWidget {
  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  List<dynamic> countryPrefixes = [];
  bool isLoading = true;
  String selectedPrefix = "+265";
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    fetchCountryPrefixes();
  }
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Function to fetch country prefixes from local JSON file
  Future<void> fetchCountryPrefixes() async {
    final String response = await rootBundle.loadString('assets/json/countries.json');
    final data = json.decode(response);
    setState(() {
      countryPrefixes = data['countries']; 
      isLoading = false;
    });
  }

  // Password validation function using regex
  String? passwordValidator(String? value) {
    // If the value is null or empty, show an error message
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    // Regular expression to validate password strength
    final passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    // If the password does not match the required pattern, return the error message
    if (!passwordRegExp.hasMatch(value)) {
      return 'Password must contain at least 1 letter, 1 number, and 1 special character';
    }
    return null; 
  }


  @override
  Widget build(BuildContext context) {
    return Form(
       key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: CSizes.spaceBtwSections),
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                prefixIcon: Icon(FontAwesomeIcons.user),
                labelText: "Enter Name",
              ),
            ),
            const SizedBox(height: CSizes.spaceBtwInputFields),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email),
                labelText: "Enter Email",
              ),
            ),
            const SizedBox(height: CSizes.spaceBtwInputFields),

            // Phone Number with Country Prefix Selection
            isLoading
                ? const CircularProgressIndicator()
                : Row(
              children: [
                // Country Prefix Dropdown
                Flexible(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: selectedPrefix,
                    decoration: const InputDecoration(
                      labelText: 'Select Country',
                    ),
                    items: countryPrefixes.map<DropdownMenuItem<String>>((prefix) {
                      return DropdownMenuItem<String>(
                        value: prefix['code'],
                        child: Text('${prefix['prefix']} (${prefix['code']})'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedPrefix = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10), // Space between prefix dropdown and phone number input
                // Phone Number Input
                Expanded(
                  flex: 3, // Adjust flex to control the width proportion
                  child: TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: "Enter Phone Number",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),

            const SizedBox(height: CSizes.spaceBtwInputFields),

                // Password with Validation
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock),
                labelText: "Enter Password",
              ),
              obscureText: true,
              validator: passwordValidator,
            ),
            const SizedBox(height: CSizes.spaceBtwInputFields),
            TextFormField(
              controller: confirmPasswordController, // Use a separate controller
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock),
                labelText: "Confirm Password",
              ),
              obscureText: true,
              validator: (value) {
                if (value != passwordController.text) {
                  return 'Passwords do not match';
                }
                return passwordValidator(value); // You can reuse the password validator
              },
            ),

            const SizedBox(height: CSizes.spaceBtwInputFields),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                  if (state is AuthSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please Login')),
                      );

                      // Clear input fields
                      nameController.clear();
                      emailController.clear();
                      phoneController.clear();
                      passwordController.clear();
                      confirmPasswordController.clear();

                      // Navigate to Login Screen
                      Navigator.pushReplacementNamed(context, '/signin');
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
                          context.read<AuthCubit>().signUp(
                            nameController.text,
                            emailController.text,
                            phoneController.text,
                            passwordController.text,
                            confirmPasswordController.text,
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
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                      ),
                    ),
                  );
                },
              )

           
          ],
        ),
      ),
    );
  }
}
