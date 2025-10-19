import 'package:flutter/material.dart';

import 'package:intl/date_symbol_data_local.dart'; 
import 'package:pemrograman_mobile/screens/about_screen.dart';
import 'package:pemrograman_mobile/screens/home_screen.dart';
import 'package:pemrograman_mobile/screens/login_screen.dart';
import 'package:pemrograman_mobile/screens/register_screen.dart';
import 'package:pemrograman_mobile/screens/settings_screen.dart';

// UBAH: Fungsi main menjadi async
void main() async { 
  // BARU: Pastikan Flutter siap sebelum menjalankan kode async
  WidgetsFlutterBinding.ensureInitialized(); 
  
  // BARU: Muat data format tanggal untuk locale 'id_ID' (Indonesia)
  await initializeDateFormatting('id_ID', null); 

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
      routes: {
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/about': (context) => const AboutScreen(),
      },
    );
  }
}