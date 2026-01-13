import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uts/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final userController = TextEditingController();
  final passController = TextEditingController();
  String? errorText; // untuk menampilkan pesan error

  Future<void> login() async {
    if (userController.text.isEmpty || passController.text.isEmpty) {
      setState(() {
        errorText = "Username dan Password wajib diisi";
      });
      return;
    }

    setState(() {
      errorText = null;
    });

    final pref = await SharedPreferences.getInstance();
    await pref.setBool('login', true);
    await pref.setString('username', userController.text);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainPage()),
      );
    }
  }

  InputDecoration input(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      labelStyle: const TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
      floatingLabelStyle: const TextStyle(
        color: Color(0xFFBC8634),
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFBC8634), width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey),
      ),
      filled: true,
      fillColor: Colors.grey.shade100,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWeb = width >= 800;

    return Scaffold(
      backgroundColor: const Color(0xFFEDE9FF),
      body: Center(
        child: Container(
          width: isWeb ? 900 : double.infinity,
          height: isWeb ? 520 : double.infinity,
          margin: isWeb ? null : const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 2,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        const Icon(
                          Icons.school,
                          size: 80,
                          color: Color(0xFFBC8634),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Academic Planner",
                          style: TextStyle(
                            color: Color(0xFFBC8634),
                            fontFamily: 'Poppins',
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Silakan masuk untuk mengelola tugas dan jadwal akademik Anda",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 32),
                        TextField(
                          controller: userController,
                          decoration: input("Username", Icons.person),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: passController,
                          obscureText: true,
                          decoration: input("Password", Icons.lock),
                        ),
                        const SizedBox(height: 16),
                        if (errorText != null)
                          Text(
                            errorText!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFBC8634),
                            elevation: 2,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 24,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            minimumSize: const Size(0, 0),
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (isWeb)
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 224, 157, 90),
                          Color(0xFF8F67E8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.tablet_android,
                        size: 120,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
