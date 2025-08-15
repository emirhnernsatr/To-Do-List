import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_uygulamsi/firebase_options.dart';
import 'package:to_do_uygulamsi/screens/home/cubit/home_cubit.dart';
import 'package:to_do_uygulamsi/screens/home/view/home_view.dart';
import 'package:to_do_uygulamsi/screens/login/cubit/login_cubit.dart';
import 'package:to_do_uygulamsi/screens/login/view/login_view.dart';
import 'package:to_do_uygulamsi/core/service/auth_service.dart';
import 'package:to_do_uygulamsi/core/theme/app_theme.dart';
import 'package:to_do_uygulamsi/core/theme/cubit/theme_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: FirebaseAuth.instance.authStateChanges().first,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        final user = snapshot.data;

        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => HomeCubit(user!.uid)),
            BlocProvider(create: (_) => ThemeCubit()),
            BlocProvider(create: (context) => LoginCubit(AuthService())),
          ],
          child: BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: state.themeMode,
                home: user == null
                    ? const LoginView()
                    : HomeView(uid: user.uid),
              );
            },
          ),
        );
      },
    );
  }
}
