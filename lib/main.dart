import 'package:flutter/material.dart';
import 'package:safevision/Trip/views/home_view.dart';
import 'shared/widgets/welcome_screen.dart';
import 'shared/widgets/login_screen.dart';
import 'shared/widgets/select_profile_screen.dart';
import 'shared/widgets/sign_up_screen.dart';
import 'shared/widgets/company_info_screen.dart';
import 'shared/widgets/terms_screen.dart';
import 'shared/widgets/account_created_screen.dart';

void main() {
  runApp(const SafeVisionApp());
}

class SafeVisionApp extends StatelessWidget {
  const SafeVisionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeVision',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF239B56),
        scaffoldBackgroundColor: Colors.white,
        // Configuración global de Poppins
        fontFamily: 'Poppins',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'Poppins'),
          displayMedium: TextStyle(fontFamily: 'Poppins'),
          displaySmall: TextStyle(fontFamily: 'Poppins'),
          headlineLarge: TextStyle(fontFamily: 'Poppins'),
          headlineMedium: TextStyle(fontFamily: 'Poppins'),
          headlineSmall: TextStyle(fontFamily: 'Poppins'),
          titleLarge: TextStyle(fontFamily: 'Poppins'),
          titleMedium: TextStyle(fontFamily: 'Poppins'),
          titleSmall: TextStyle(fontFamily: 'Poppins'),
          bodyLarge: TextStyle(fontFamily: 'Poppins'),
          bodyMedium: TextStyle(fontFamily: 'Poppins'),
          bodySmall: TextStyle(fontFamily: 'Poppins'),
          labelLarge: TextStyle(fontFamily: 'Poppins'),
          labelMedium: TextStyle(fontFamily: 'Poppins'),
          labelSmall: TextStyle(fontFamily: 'Poppins'),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF239B56),
          primary: const Color(0xFF239B56),
        ),
      ),
      home: const WelcomeScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/select_profile': (context) => const SelectProfileScreen(),
        '/sign_up': (context) => const SignUpScreen(),
        '/company_info': (context) => const CompanyInfoScreen(),
        '/terms': (context) => const TermsScreen(),
        '/account_created': (context) => const AccountCreatedScreen(),
        '/home': (context) => const HomeView(),
      },
    );
  }
}
