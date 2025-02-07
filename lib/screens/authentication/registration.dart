import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constant/colors.dart';
import '../../helpers/helper_functions.dart';
import '../../widget/Auth/login_header.dart';
import '../../widget/Auth/register_form.dart';
import '../../widget/style/spacing_style.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = CHelperFunctions.isDarkMode(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: CSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              // Logo, Title, Subtitle
              const LoginHeader(),

              // Form
              SignupForm(),
              // Divider line
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                      color: dark ? CColors.darkGrey : CColors.grey,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              // Sign Up Link

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signin');
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary, // Customize color as needed
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
