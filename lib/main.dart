import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/language_provider.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LanguageProvider(),
      child: const DvmRationApp(),
    ),
  );
}

class DvmRationApp extends StatelessWidget {
  const DvmRationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'গো-পুষ্টি',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppTheme.primary,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const HomeScreen(),
    );
  }
}
