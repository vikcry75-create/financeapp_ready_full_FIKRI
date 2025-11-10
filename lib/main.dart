import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize intl default locale if needed
  Intl.defaultLocale = 'id_ID';
  runApp(const FinanceApp());
}

class FinanceApp extends StatelessWidget {
  const FinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    final seed = Colors.red;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finance App (Merah Putih)',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seed),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 2),
      ),
      home: const HomeScreen(),
    );
  }
}
