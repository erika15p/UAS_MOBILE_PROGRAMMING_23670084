import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  static const Color primaryColor = Color(0xFFBC8634);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Academic Planner",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: primaryColor,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.grey,
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ValueListenableBuilder(
                  valueListenable: Hive.box('tugasBox').listenable(),
                  builder: (context, Box tugasBox, _) {
                    return _summaryCard(
                      icon: Icons.assignment,
                      title: "Jumlah Tugas",
                      value: tugasBox.length.toString(),
                    );
                  },
                ),

                const SizedBox(width: 12),

                ValueListenableBuilder(
                  valueListenable: Hive.box('jadwalBox').listenable(),
                  builder: (context, Box jadwalBox, _) {
                    return _summaryCard(
                      icon: Icons.calendar_today,
                      title: "Jumlah Jadwal",
                      value: jadwalBox.length.toString(),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 28),

            _sectionTitle("Tentang Academic Planner"),

            const SizedBox(height: 12),

            _infoCard(
              "Academic Planner adalah aplikasi yang dirancang untuk membantu "
              "mahasiswa mengelola tugas dan jadwal kuliah mereka dengan lebih "
              "efisien agar tidak terlambat dan lebih disiplin.",
            ),

            const SizedBox(height: 16),

            _featureCard(
              icon: Icons.list_alt,
              title: "Manajemen Tugas",
              desc:
                  "Menambahkan, melihat, mengubah, dan menghapus tugas agar "
                  "semua deadline dapat dipantau dengan baik.",
            ),

            _featureCard(
              icon: Icons.schedule,
              title: "Manajemen Jadwal",
              desc:
                  "Mencatat jadwal kuliah atau kegiatan akademik, mengedit, "
                  "serta menghapus jadwal yang tidak diperlukan.",
            ),

            const SizedBox(height: 28),

            _sectionTitle("Tips & Metode Belajar Efektif"),

            const SizedBox(height: 12),

            /// ===== METODE POMODORO =====
            const Text(
              "Metode Pomodoro",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Belajar selama 25 menit lalu istirahat 5 menit untuk menjaga fokus.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontFamily: 'Poppins',
                height: 1.6,
                color: Colors.black54,
              ),
            ),
            TextButton(
              onPressed: () {
                _launchUrl(
                  Uri.parse("https://youtu.be/Hl2oFl232KI?si=sdzsBT_2tmW7KD_N"),
                );
              },
              child: const Text("▶ Tonton video Pomodoro"),
            ),

            const SizedBox(height: 14),

            /// ===== ACTIVE RECALL =====
            const Text(
              "Active Recall",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Menguatkan ingatan dengan mengingat kembali materi tanpa melihat catatan.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontFamily: 'Poppins',
                height: 1.6,
                color: Colors.black54,
              ),
            ),
            TextButton(
              onPressed: () {
                _launchUrl(
                  Uri.parse("https://youtu.be/piwSH8_h_sU?si=hOq-0iwvS9KXiBDb"),
                );
              },
              child: const Text("▶ Tonton video Active Recall"),
            ),

            const SizedBox(height: 14),

            /// ===== EISENHOWER MATRIX =====
            const Text(
              "Eisenhower Matrix",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Mengelompokkan tugas berdasarkan tingkat urgensi dan kepentingan.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontFamily: 'Poppins',
                height: 1.6,
                color: Colors.black54,
              ),
            ),
            TextButton(
              onPressed: () {
                _launchUrl(
                  Uri.parse("https://youtu.be/QjWxd9jzkAY?si=i2Ojf1KOsKxqyXsf"),
                );
              },
              child: const Text("▶ Tonton video Eisenhower Matrix"),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= URL LAUNCHER =================
  static void _launchUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  /// ================= SECTION TITLE =================
  static Widget _sectionTitle(String title) {
    return Column(
      children: [
        Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 120,
          height: 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: const LinearGradient(
              colors: [Color.fromARGB(255, 224, 157, 90), Color(0xFF8F67E8)],
            ),
          ),
        ),
      ],
    );
  }

  /// ================= LOGOUT =================
  static void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Apakah kamu yakin ingin logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  /// ================= SUMMARY CARD =================
  static Widget _summaryCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color.fromARGB(255, 224, 157, 90), Color(0xFF8F67E8)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Colors.white70)),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= INFO CARD =================
  static Widget _infoCard(String text) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        text,
        textAlign: TextAlign.justify,
        style: const TextStyle(fontFamily: 'Poppins', height: 1.6),
      ),
    );
  }

  /// ================= FEATURE CARD =================
  static Widget _featureCard({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Text(desc, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
