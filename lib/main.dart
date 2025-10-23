import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pemrograman_mobile/screens/about_screen.dart';
import 'package:pemrograman_mobile/screens/home_screen.dart';
import 'package:pemrograman_mobile/screens/login_screen.dart';
import 'package:pemrograman_mobile/screens/register_screen.dart';
import 'package:pemrograman_mobile/screens/settings_screen.dart';
import 'package:pemrograman_mobile/services/expense_service.dart';
import 'package:pemrograman_mobile/services/storage_service.dart';

// Buat service sebagai singleton (satu instance)
// agar bisa diakses dari mana saja.
final storageService = StorageService();
final expenseService = ExpenseService(storageService);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  
  // PENTING: Muat data dari memori saat aplikasi dimulai
  await expenseService.init(); 
  
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
        
        // Kita tidak perlu mendaftarkan halaman add/edit/stats
        // karena mereka akan dibuka dari dalam ExpenseScreen
      },
    );
  }
}