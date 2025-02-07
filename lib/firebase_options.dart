import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'AIzaSyARcvs720YsuklgaZ5nmwFCvdgGgGajtL4',
      appId: '1:934311981828:android:d2ac18ec81a13d231e1651',
      messagingSenderId: '934311981828',
      projectId: 'mega-fpg',
      storageBucket: 'YOUR_STORAGE_BUCKET',
      androidClientId: 'YOUR_ANDROID_CLIENT_ID',
      iosClientId: 'YOUR_IOS_CLIENT_ID',
      iosBundleId: 'YOUR_IOS_BUNDLE_ID',
    );
  }
}
 // Signup Button
            // Container(
            //   height: 50,
            //   width: MediaQuery.of(context).size.width / 1.2,
            //   decoration: BoxDecoration(
            //     color: Theme.of(context).colorScheme.primary,
            //     borderRadius: const BorderRadius.all(Radius.circular(10)),
            //   ),
            //   child: InkWell(
            //     onTap: () async {
            //       signupController.signup(); 
            //     },
            //     child: Obx(
            //           () {
            //         return signupController.isLoading.value
            //             ? const SizedBox(
            //               height: 21.0,
            //               width: 21.0,
            //               child: CircularProgressIndicator(
            //                 strokeWidth: 2.0,
            //                 color: Colors.white,
            //               ),
            //             )
            //             : const Center(
            //               child: Text(
            //             'Sign Up',
            //               style: TextStyle(
            //               color: Colors.white,
            //               fontSize: 20,
            //             ),
            //           ),
            //         );
            //       },
            //     ),
            //   ),
            // ),
            // // Bloc Implementation
// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   final SignUpUseCase signUpUseCase;

//   AuthBloc(this.signUpUseCase) : super(AuthInitial()) {
//     on<SignUpEvent>(_onSignUp);
//   }

//   Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
//     emit(AuthLoading());
//     try {
//       final user = await signUpUseCase.execute(event.email, event.password);
//       emit(AuthSuccess(user));
//     } catch (e) {
//       emit(AuthFailure(e.toString()));
//     }
//   }
// }
