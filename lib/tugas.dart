import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'detail_tugas.dart';

class TugasPage extends StatefulWidget {
  const TugasPage({super.key});

  @override
  State<TugasPage> createState() => _TugasPageState();
}

class _TugasPageState extends State<TugasPage> {
  static const Color primaryColor = Color(0xFFBC8634);
  late Box tugasBox;
  int idCounter = 100;

  @override
  void initState() {
    super.initState();
    // Inisialisasi box Hive
    tugasBox = Hive.box('tugasBox');

    // Update idCounter berdasarkan data terakhir
    if (tugasBox.isNotEmpty) {
      idCounter = tugasBox.values
              .map((e) => e['id'] as int)
              .reduce((a, b) => a > b ? a : b) +
          1;
    }
  }

  Color statusTextColor(String status) {
    switch (status) {
      case "Belum":
        return Colors.red;
      case "Proses":
        return Colors.orange;
      case "Selesai":
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  // ================= TAMBAH =================
  void showTambahDialog() {
    final judulCtrl = TextEditingController();
    final matkulCtrl = TextEditingController();
    final deadlineCtrl = TextEditingController();
    final deskripsiCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          "Tambah Tugas",
          style: TextStyle(
            fontFamily: 'Poppins',
            color: primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _inputField(judulCtrl, "Judul", primaryColor: primaryColor),
              _inputField(matkulCtrl, "Mata Kuliah", primaryColor: primaryColor),
              _inputField(deadlineCtrl, "Deadline", primaryColor: primaryColor),
              _inputField(deskripsiCtrl, "Deskripsi",
                  maxLines: 3, primaryColor: primaryColor),
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
              final newTugas = {
                "id": idCounter++,
                "judul": judulCtrl.text,
                "matkul": matkulCtrl.text,
                "deadline": deadlineCtrl.text,
                "deskripsi": deskripsiCtrl.text,
                "status": "Belum",
              };
              tugasBox.add(newTugas); // Simpan ke Hive
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
    final tugas = tugasBox.getAt(index) as Map;
    final judulCtrl = TextEditingController(text: tugas['judul']);
    final matkulCtrl = TextEditingController(text: tugas['matkul']);
    final deadlineCtrl = TextEditingController(text: tugas['deadline']);
    final deskripsiCtrl = TextEditingController(text: tugas['deskripsi']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          "Edit Tugas",
          style: TextStyle(
            fontFamily: 'Poppins',
            color: primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _inputField(judulCtrl, "Judul", primaryColor: primaryColor),
              _inputField(matkulCtrl, "Mata Kuliah", primaryColor: primaryColor),
              _inputField(deadlineCtrl, "Deadline", primaryColor: primaryColor),
              _inputField(deskripsiCtrl, "Deskripsi",
                  maxLines: 3, primaryColor: primaryColor),
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
              final updatedTugas = {
                "id": tugas['id'],
                "judul": judulCtrl.text,
                "matkul": matkulCtrl.text,
                "deadline": deadlineCtrl.text,
                "deskripsi": deskripsiCtrl.text,
                "status": tugas['status'],
              };
              tugasBox.putAt(index, updatedTugas);
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
  void hapusTugas(int index) {
    tugasBox.deleteAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final tugasList = tugasBox.values.toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
      body: tugasList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 10),
                const Text(
                  "Tugas",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
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
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: tugasList.length,
                    itemBuilder: (context, index) {
                      final item = tugasList[index] as Map;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailTugasPage(
                                judul: item['judul'],
                                matkul: item['matkul'],
                                deadline: item['deadline'],
                                status: item['status'],
                                deskripsi: item['deskripsi'],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Colors.white,
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
                              Text(item['judul'],
                                  style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text(item['matkul'],
                                  style: const TextStyle(
                                      fontFamily: 'Poppins', color: Colors.grey)),
                              const SizedBox(height: 4),
                              Text("Deadline: ${item['deadline']}",
                                  style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.redAccent)),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Color.fromARGB(255, 99, 100, 100)),
                                    onPressed: () => showEditDialog(index),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Color.fromARGB(255, 99, 100, 100)),
                                    onPressed: () => hapusTugas(index),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: Colors.orange, width: 1.5),
                                ),
                                child: DropdownButton<String>(
                                  value: item['status'],
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  dropdownColor: Colors.white,
                                  items: [
                                    DropdownMenuItem(
                                      value: "Belum",
                                      child: Text(
                                        "Belum dikerjakan",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: statusTextColor("Belum"),
                                        ),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: "Proses",
                                      child: Text("Proses",
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: statusTextColor("Proses"),
                                          )),
                                    ),
                                    DropdownMenuItem(
                                      value: "Selesai",
                                      child: Text("Selesai",
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: statusTextColor("Selesai"),
                                          )),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    final updatedItem = {
                                      ...item,
                                      "status": value!,
                                    };
                                    tugasBox.putAt(index, updatedItem);
                                    setState(() {});
                                  },
                                  selectedItemBuilder: (context) {
                                    return ["Belum", "Proses", "Selesai"]
                                        .map((status) {
                                      return Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          status == "Belum"
                                              ? "Belum dikerjakan"
                                              : status,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                            color: statusTextColor(status),
                                          ),
                                        ),
                                      );
                                    }).toList();
                                  },
                                ),
                              ),
                            ],
                          ),
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

  // ================= INPUT STYLE =================
  static Widget _inputField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    required Color primaryColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(fontFamily: 'Poppins'),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontFamily: 'Poppins', color: primaryColor),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryColor, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
        ),
      ),
    );
  }
}
