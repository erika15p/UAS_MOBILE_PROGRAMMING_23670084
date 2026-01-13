import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class JadwalPage extends StatefulWidget {
  const JadwalPage({super.key});

  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  static const Color primaryColor = Color(0xFFBC8634);
  late Box jadwalBox;

  @override
  void initState() {
    super.initState();
    // Inisialisasi box Hive
    jadwalBox = Hive.box('jadwalBox');
  }

  // ================= TAMBAH =================
  void showTambahDialog() {
    final hariCtrl = TextEditingController();
    final jamCtrl = TextEditingController();
    final ruanganCtrl = TextEditingController();
    final dosenCtrl = TextEditingController();
    final matkulCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          "Tambah Jadwal",
          style: TextStyle(fontFamily: 'Poppins', color: primaryColor),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _inputField(hariCtrl, "Hari"),
              _inputField(jamCtrl, "Jam"),
              _inputField(ruanganCtrl, "Ruangan"),
              _inputField(dosenCtrl, "Dosen"),
              _inputField(matkulCtrl, "Mata Kuliah"),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: primaryColor)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            onPressed: () {
              final newJadwal = {
                "hari": hariCtrl.text,
                "jam": jamCtrl.text,
                "ruangan": ruanganCtrl.text,
                "dosen": dosenCtrl.text,
                "matkul": matkulCtrl.text,
              };
              jadwalBox.add(newJadwal); // Simpan ke Hive
              setState(() {}); // Refresh UI
              Navigator.pop(context);
            },
            child: const Text("Simpan", style: TextStyle(color: primaryColor)),
          ),
        ],
      ),
    );
  }

  // ================= EDIT =================
  void showEditDialog(int index) {
    final jadwal = jadwalBox.getAt(index) as Map;
    final hariCtrl = TextEditingController(text: jadwal["hari"]);
    final jamCtrl = TextEditingController(text: jadwal["jam"]);
    final ruanganCtrl = TextEditingController(text: jadwal["ruangan"]);
    final dosenCtrl = TextEditingController(text: jadwal["dosen"]);
    final matkulCtrl = TextEditingController(text: jadwal["matkul"]);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          "Edit Jadwal",
          style: TextStyle(fontFamily: 'Poppins', color: primaryColor),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _inputField(hariCtrl, "Hari"),
              _inputField(jamCtrl, "Jam"),
              _inputField(ruanganCtrl, "Ruangan"),
              _inputField(dosenCtrl, "Dosen"),
              _inputField(matkulCtrl, "Mata Kuliah"),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: primaryColor)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            onPressed: () {
              final updatedJadwal = {
                "hari": hariCtrl.text,
                "jam": jamCtrl.text,
                "ruangan": ruanganCtrl.text,
                "dosen": dosenCtrl.text,
                "matkul": matkulCtrl.text,
              };
              jadwalBox.putAt(index, updatedJadwal);
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text("Simpan", style: TextStyle(color: primaryColor)),
          ),
        ],
      ),
    );
  }

  // ================= DELETE =================
  void hapusJadwal(int index) {
    jadwalBox.deleteAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final jadwalList = jadwalBox.values.toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Academic Planner",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
      ),
      body: jadwalList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 6),
                const Text(
                  "Jadwal",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 120,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 224, 157, 90),
                        Color(0xFF8F67E8),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: jadwalList.length,
                    itemBuilder: (context, index) {
                      final j = jadwalList[index] as Map;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(
                                  alpha: 20, red: 0, green: 0, blue: 0),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              j["matkul"]!,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _infoRow("Hari", j["hari"]!),
                            _infoRow("Jam", j["jam"]!),
                            _infoRow("Ruangan", j["ruangan"]!),
                            _infoRow("Dosen", j["dosen"]!),
                            Row(
                              children: [
                                IconButton(
                                  icon:
                                      const Icon(Icons.edit, color: Colors.grey),
                                  onPressed: () => showEditDialog(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.grey),
                                  onPressed: () => hapusJadwal(index),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: showTambahDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: const TextStyle(fontFamily: 'Poppins', color: Colors.grey),
            ),
          ),
          Text(value, style: const TextStyle(fontFamily: 'Poppins')),
        ],
      ),
    );
  }

  static Widget _inputField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontFamily: 'Poppins'),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            fontFamily: 'Poppins',
            color: primaryColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryColor, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryColor, width: 2),
          ),
        ),
      ),
    );
  }
}
