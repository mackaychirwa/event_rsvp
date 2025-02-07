import 'package:event_rsvp/core/bloc/user/user_bloc.dart';
import 'package:event_rsvp/screens/settings/settings.dart';
import 'package:event_rsvp/widget/bottomNavigation/bottomnavbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import '/screens/authentication/authentication.dart';
import '/screens/authentication/registration.dart';
import '/screens/dashboard/dashboard.dart';
import '/screens/onBoarding/onBoardingScreen.dart';
import '/core/bloc/auth_bloc.dart';
import '/constant/text_constant.dart';
import '/core/usecases/auth_use_case.dart';
import 'core/bloc/attendance/attendance_cubit.dart';
import 'core/bloc/event/event_cubit.dart';
import 'firebase_options.dart';

bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase initialization failed: $e');
    // Handle the error appropriately in your app context
  }

  await Hive.initFlutter();
  await Hive.openBox('userBox');

  SystemChrome.setSystemUIOverlayStyle(
    isIOS
        ? const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          )
        : const SystemUiOverlayStyle(
            statusBarColor: Color(0xFF6C63FF),
          ),
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit(SignUpUseCase())),
        BlocProvider(create: (context) => UserCubit()), 
        BlocProvider(create: (context) => EventCubit()), 
        BlocProvider(create: (context) => AttendeeCubit()), 
        
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: (context, child) => isIOS
            ? const CupertinoApp(
                title: TextConstants.titleSystem,
                home: OnboardingScreen(),
                theme: CupertinoThemeData(
                  primaryColor: Color(0xFF6C63FF),
                  barBackgroundColor: Color(0xFF6C63FF),
                  scaffoldBackgroundColor: Colors.blueGrey,
                ),
                debugShowCheckedModeBanner: false,
              )
            : MaterialApp(
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
                  '/bottomNav': (context) => BottomNavBar(),
                  '/settings': (context) => Settings(),
                },
              ),
      ),
    ),
  );
}
