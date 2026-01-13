import 'package:flutter/material.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  static const Color primaryColor = Color(0xFFBC8634);

  // DATA AWAL
  String nama = "Erika Puji Suhartanti";
  String semester = "Semester 5";
  String nim = "23670084";
  String prodi = "Informatika";
  String kampus = "Universitas PGRI Semarang";
  String email = "23670084@upgris.ac.id";
  String telepon = "081234567890";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Profil",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: primaryColor,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            color: primaryColor,
            tooltip: "Edit Profil",
            onPressed: _showEditDialog,
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 220,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(255, 224, 157, 90),
                        Color(0xFF8F67E8),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  bottom: 0,
                  child: ClipPath(
                    clipper: _DiagonalClipper(),
                    child: Container(
                      height: 120,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                    ),
                  ),
                ),

                /// FOTO PROFIL
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.white,
                    child: const CircleAvatar(
                      radius: 44,
                      backgroundImage: AssetImage("images/pp.jpeg"),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              nama,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),

            const SizedBox(height: 4),

            Text(
              semester,
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 28),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _ProfileItem(icon: Icons.badge, title: "NIM", value: nim),
                  _ProfileItem(
                    icon: Icons.school,
                    title: "Program Studi",
                    value: prodi,
                  ),
                  _ProfileItem(
                    icon: Icons.school_outlined,
                    title: "Kampus",
                    value: kampus,
                  ),
                  _ProfileItem(icon: Icons.email, title: "Email", value: email),
                  _ProfileItem(
                    icon: Icons.phone,
                    title: "No. Telepon",
                    value: telepon,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showEditDialog() {
    final namaC = TextEditingController(text: nama);
    final semesterC = TextEditingController(text: semester);
    final nimC = TextEditingController(text: nim);
    final prodiC = TextEditingController(text: prodi);
    final kampusC = TextEditingController(text: kampus);
    final emailC = TextEditingController(text: email);
    final telpC = TextEditingController(text: telepon);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Profil"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _inputField("Nama", namaC),
              _inputField("Semester", semesterC),
              _inputField("NIM", nimC),
              _inputField("Program Studi", prodiC),
              _inputField("Kampus", kampusC),
              _inputField("Email", emailC),
              _inputField("No. Telepon", telpC),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Batal",
              style: TextStyle(color: Color(0xFFBC8634)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            onPressed: () {
              setState(() {
                nama = namaC.text;
                semester = semesterC.text;
                nim = nimC.text;
                prodi = prodiC.text;
                kampus = kampusC.text;
                email = emailC.text;
                telepon = telpC.text;
              });
              Navigator.pop(context);
            },
            child: const Text(
              "Simpan",
              style: TextStyle(color: Color(0xFFBC8634)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ProfileItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 224, 157, 90), Color(0xFF8F67E8)],
              ),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// MIRINGAN HEADER
class _DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 50);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
