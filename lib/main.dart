import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/currency_provider.dart';
import 'features/onboarding/screens/intro_page.dart';

void main() {
  runApp(const FinMitraApp());
}

class FinMitraApp extends StatelessWidget {
  const FinMitraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CurrencyProvider()),
      ],
      child: MaterialApp(
        title: 'FinMitra',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        home: const OnboardingScreen(),
      ),
    );
  }
}

