import 'package:flutter/material.dart';
import 'package:nutrimedai/features/auth/data/firebase_auth_repo.dart';
import 'package:nutrimedai/features/auth/home/presentation/pages/home_page.dart';
import 'package:nutrimedai/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:nutrimedai/features/auth/presentation/cubits/auth_states.dart';
import 'package:nutrimedai/features/auth/presentation/pages/auth_page.dart';
import 'package:nutrimedai/features/auth/presentation/pages/medical_info_page.dart';
import 'package:nutrimedai/features/profile/data/firebase_profile_repo.dart';
import 'package:nutrimedai/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:nutrimedai/features/storage/data/firebase_storage_repo.dart';
import 'package:nutrimedai/features/themes/light_mode.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  // auth repo
  final firebaseAuthRepo = FirebaseAuthRepo();

  // profile repo
  final firebaseProfileRepo = FirebaseProfileRepo();

  // storage repo
  final firebaseStorageRepo = FirebaseStorageRepo();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //  provide cubits to app
    return MultiBlocProvider(
      providers: [
        // auth cubit
        BlocProvider<AuthCubit>(
          create: (context) =>
              AuthCubit(authRepo: firebaseAuthRepo)..checkAuth(),
        ),

        // profile cubit
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(
            profileRepo: firebaseProfileRepo,
            storageRepo: firebaseStorageRepo,
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        home: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, authState) {
            print(authState);

            //  unauthenticated -> auth page (login/register)
            if (authState is Unauthenticated) {
              return const AuthPage();
            }

            //  authenticated -> check if medical info is completed
            if (authState is Authenticated) {
              // Si el usuario no ha completado su información médica
              if (!authState.user.medicalInfoCompleted) {
                return const MedicalInfoPage();
              }
              // Si ya completó su información médica, ir a home
              return HomePage();
            }
            //  loading...
            else {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
          },
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
      ),
    );
  }
}
