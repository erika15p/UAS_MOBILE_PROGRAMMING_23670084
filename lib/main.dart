import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'login.dart';
import 'beranda.dart';
import 'tugas.dart';
import 'jadwal.dart';
import 'profil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ===== Inisialisasi Hive =====
  await Hive.initFlutter();

  // Membuka box Hive untuk data tugas dan jadwal
  await Hive.openBox('tugasBox');
  await Hive.openBox('jadwalBox');

  runApp(const MyApp());
}

// ======================================================
// APP UTAMA
// ======================================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthCheck(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/beranda': (context) => const BerandaPage(),
        '/tugas': (context) => const TugasPage(),
        '/jadwal': (context) => const JadwalPage(),
        '/profil': (context) => const ProfilPage(),
      },
    );
  }
}

// ======================================================
// CEK LOGIN
// ======================================================
class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  Future<bool> cekLogin() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool('login') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: cekLogin(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return snapshot.data! ? const MainPage() : const LoginPage();
      },
    );
  }
}

// ======================================================
// HALAMAN DENGAN BOTTOM NAVBAR (TIDAK MELAYANG)
// ======================================================
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    BerandaPage(),
    TugasPage(),
    JadwalPage(),
    ProfilPage(),
  ];

  static const Color primaryColor = Color(0xFFBC8634);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task_rounded),
            label: 'Tugas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule_rounded),
            label: 'Jadwal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
