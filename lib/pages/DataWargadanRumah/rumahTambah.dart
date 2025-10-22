// import 'package:flutter/material.dart';

// class rumahTambahPage extends StatelessWidget {
//   const rumahTambahPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text(
//         'Halaman Rumah Tambah',
//         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class rumahTambahPage extends StatefulWidget {
  const rumahTambahPage({super.key});

  @override
  State<rumahTambahPage> createState() => _rumahTambahPageState();
}

class _rumahTambahPageState extends State<rumahTambahPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _alamatController = TextEditingController();

  void _resetForm() {
    _alamatController.clear();
    _formKey.currentState?.reset();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // TODO: Add your submit logic here (e.g. save to database)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alamat berhasil disimpan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Responsive padding
    final double horizontalPadding = MediaQuery.of(context).size.width * 0.05;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 40,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Tambah Rumah Baru",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Alamat Rumah",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _alamatController,
                        decoration: InputDecoration(
                          hintText: "Contoh: Jl. Merpati No. 5",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.deepPurple, width: 1.8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Alamat wajib diisi.";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Submit",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton(
                            onPressed: _resetForm,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Reset",
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
