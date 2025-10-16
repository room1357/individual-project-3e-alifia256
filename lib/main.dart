import 'package:flutter/material.dart';
import 'package:pemrograman_mobile/screens/about_screen.dart'; // Tambah import
import 'package:pemrograman_mobile/screens/home_screen.dart';
import 'package:pemrograman_mobile/screens/login_screen.dart';
import 'package:pemrograman_mobile/screens/profile_screen.dart'; // Tambah import
import 'package:pemrograman_mobile/screens/register_screen.dart';
import 'package:pemrograman_mobile/screens/settings_screen.dart'; // Tambah import

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CityFood',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/register',
      // Daftarkan semua rute baru di sini
      routes: {
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/settings': (context) => const SettingsScreen(), // Rute baru
        '/about': (context) => const AboutScreen(), // Rute baru
      },
    );
  }
}
