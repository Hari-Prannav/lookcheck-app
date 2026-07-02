import 'package:flutter/material.dart';
import 'package:outfit_customizer_1/features/home/screens/home_screen.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const OutfitCustomizerApp());
}

class OutfitCustomizerApp extends StatelessWidget {
  const OutfitCustomizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Outfit Planner",
      theme: AppTheme.darkTheme,
      home: const HomePage(),
    );
  }
}