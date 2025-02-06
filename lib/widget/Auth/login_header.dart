import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constant/images.dart';
import '../../constant/sizes.dart';
import '../../helpers/helper_functions.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = CHelperFunctions.isDarkMode(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: CSizes.lg),

        CircleAvatar(
          radius: 40, 
          backgroundColor: Colors.black,
          backgroundImage: AssetImage(
            dark ? TImages.user : TImages.user ,
          ),
        ),
        const SizedBox(height: CSizes.sm), 
        Text(
          "Welcome Back",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: CSizes.sm),
        Text(
          "To Event RSVP",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
