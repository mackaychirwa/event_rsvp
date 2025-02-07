import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';

import '../../widget/bottomNavigation/bottomnavbar.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  void _showErrorModal(BuildContext context) {
    Get.defaultDialog(
      title: "Incorrect OTP",
      middleText: "The entered OTP is incorrect. Please try again.",
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.back();
          },
          child: Text("OK"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mail,
              size: 150,
              color: Theme.of(context).colorScheme.primary,
            ),
            const Text(
              'We have sent an OTP to h*****@*.com please verify that you have received the notification',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            OtpTextField(
              fillColor: Colors.black.withOpacity(0.1),
              filled: true,
              numberOfFields: 6,
              autoFocus: true,
              fieldWidth: 50,
              borderWidth: 1,
              borderColor: Theme.of(context).colorScheme.primary,
              showFieldAsBox: true,
              borderRadius: BorderRadius.circular(13),
              onCodeChanged: (String code) {},
              onSubmit: (String verificationCode) {
                if (verificationCode == "123456") {
                  Get.off(() =>
                      BottomNavBar());
                } 
                // else if (verificationCode == "todat") {
                //   Get.off(() => const DriverDashboard());
                // } 
                else if (verificationCode == "me") {
                  Get.off(() => BottomNavBar());
                } else {
                  _showErrorModal(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
