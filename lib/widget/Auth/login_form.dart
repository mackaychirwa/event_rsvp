import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../constant/sizes.dart';
import '../../controller/Auth/LoginController.dart';
import '../../view/dashboard/dashboard.dart';
import '../bottomNavigation/bottomnavbar.dart';

class login_form extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: CSizes.spaceBtwSections),
        child: Column(
          children: [
            /// Username
            TextFormField(
              controller: loginController.emailController,
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  FontAwesomeIcons.user,
                ),
                labelText: "Enter Email",
              ),
            ),
            const SizedBox(height: CSizes.spaceBtwInputFields),

            /// Password
            TextFormField(
              obscureText: true,
              controller: loginController.passwordController,
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

            /// Forgot Password
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

            Container(
              height: 50,
              width: MediaQuery.of(context).size.width / 1.2,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: InkWell(
                onTap: () async {
                  Get.off(() => BottomNavBar());
                  // loginController.login(); // Triggers the login action
                },
                child: Obx(
                  () {
                    // Observes the isLoading variable from loginController
                    return loginController.isLoading.value
                        ? const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              color: Colors.white,
                            ),
                          ) 
                        : const Center(
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          );
                  },
                ),
              ),
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
