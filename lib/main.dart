import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:floating_navbar/floating_navbar.dart';
import 'package:floating_navbar/floating_navbar_item.dart';
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
// HALAMAN DENGAN FLOATING NAVBAR
// ======================================================
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;

  final List<Widget> pages = const [
    BerandaPage(),
    TugasPage(),
    JadwalPage(),
    ProfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return FloatingNavBar(
      color: Colors.white,
      borderRadius: 28,
      selectedIconColor: const Color(0xFFBC8634),
      unselectedIconColor: Colors.grey,
      showTitle: true,
      horizontalPadding: 10,
      items: [
        FloatingNavBarItem(
          iconData: Icons.home_rounded,
          title: 'Beranda',
          page: pages[0],
        ),
        FloatingNavBarItem(
          iconData: Icons.task_rounded,
          title: 'Tugas',
          page: pages[1],
        ),
        FloatingNavBarItem(
          iconData: Icons.schedule_rounded,
          title: 'Jadwal',
          page: pages[2],
        ),
        FloatingNavBarItem(
          iconData: Icons.person_rounded,
          title: 'Profil',
          page: pages[3],
        ),
      ],
    );
  }
}
