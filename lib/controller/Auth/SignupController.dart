import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class SignupController extends GetxController {
  var isLoading = false.obs;
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  var hasChild = false.obs; // Checkbox value
  void signup() async {
    // Check if any required field is empty
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty
        )
    { // Ensure membership type is selected
      Get.snackbar('Error', 'All fields are required',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
      return;
    }

    isLoading(true);

    try {
      await Hive.openBox('userBox');
      // Save user data to Hive

      Get.snackbar('Success', 'Signup successful',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
    } catch (e) {
      Get.snackbar('Error', 'An error occurred. Please try again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
    } finally {
      isLoading(false);
    }
  }
}
