import '/constant/text_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import '/view/authentication/authentication.dart';
import 'view/authentication/registration.dart';
import '/view/dashboard/dashboard.dart';
import '/view/onBoarding/onBoardingScreen.dart';

bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('userBox');
  await Hive.openBox('pdfData');
  // Set UI changes for iOS or other platforms
  SystemChrome.setSystemUIOverlayStyle(
    isIOS
        ? const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    )
        : const SystemUiOverlayStyle(
      statusBarColor:Color(0xFF6C63FF),
    ),
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    ProviderScope(
      child: ScreenUtilInit(
        designSize: const Size(360, 690), // Adjust to your design size
        builder: (context, child) => isIOS
            ? const CupertinoApp(
              title: TextConstants.titleSystem,
              home: OnboardingScreen(), // Replace with your iOS Home widget
              theme: CupertinoThemeData(
                primaryColor: Color(0xFF6C63FF),
                barBackgroundColor: Color(0xFF6C63FF),
                scaffoldBackgroundColor: Colors.blueGrey,
              ),
              debugShowCheckedModeBanner: false,
            )
            : GetMaterialApp(
                debugShowCheckedModeBanner: false,
                title: TextConstants.titleSystem,
                theme: ThemeData(
                  scaffoldBackgroundColor: Colors.white,
                  useMaterial3: true,
                  colorScheme: const ColorScheme(
                    brightness: Brightness.light,
                    primary: Color(0xFF6C63FF),
                    onPrimary: Color(0xFFFFFFFF),
                    primaryContainer: Color(0xFFFFDF9B),
                    onPrimaryContainer: Color(0xFF251A00),
                    secondary: Color(0xFF6C63FF),
                    onSecondary: Color(0xFFFFFFFF),
                    secondaryContainer: Color(0xFFDEE0FF),
                    onSecondaryContainer: Color(0xFF000000),
                    tertiary: Color(0xFFC00015),
                    onTertiary: Color(0xFFFFFFFF),
                    tertiaryContainer: Color(0xFFFFDAD6),
                    onTertiaryContainer: Color(0xFF410002),
                    error: Color(0xFFBA1A1A),
                    errorContainer: Color(0xFFFFDAD6),
                    onError: Color(0xFFFFFFFF),
                    onErrorContainer: Color(0xFF410002),
                    background: Color(0xFFFFFBFF),
                    onBackground: Color(0xFF1E1B16),
                    surface: Color(0xFFFFFBFF),
                    onSurface: Color(0xFF1E1B16),
                    surfaceVariant: Color(0xFFEDE1CF),
                    onSurfaceVariant: Color(0xFF4D4639),
                    outline: Color(0xFF7F7667),
                    onInverseSurface: Color(0xFFF7F0E7),
                    inverseSurface: Color(0xFF33302A),
                    inversePrimary: Color(0xFFF9BD00),
                    shadow: Color(0xFF000000),
                    surfaceTint: Color(0xFF785A00),
                    outlineVariant: Color(0xFFD0C5B4),
                    scrim: Color(0xFF000000),
                  ),
                ),
              home: const OnboardingScreen(),
              routes: {
              '/signin': (context) => const Authentication(),
              '/signup': (context) => const Register(),
              '/dashboard': (context) => const Dashboard(),
              '/scan': (context) => const Dashboard(),
              '/weblink': (context) => const Dashboard(),
              '/paste': (context) => const Dashboard(),
          },
        ),
      ),
    ),
  );
}

