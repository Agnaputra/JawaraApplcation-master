import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class pengeluaranTambahPage extends StatefulWidget {
  const pengeluaranTambahPage({super.key});

  @override
  State<pengeluaranTambahPage> createState() => _pengeluaranTambahPageState();
}

class _pengeluaranTambahPageState extends State<pengeluaranTambahPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nominalController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();

  String? _selectedKategori;
  final List<String> _kategoriList = [
    'Operasional RT/RW',
    'Kegiatan Sosial',
    'Pemeliharaan Fasilitas',
    'Pembangunan',
    'Kegiatan Warga',
    'Lain-lain',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Buat Pengeluaran Baru'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nama Pengeluaran',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _namaController,
                  decoration: InputDecoration(
                    hintText: 'Masukkan nama pengeluaran',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  'Tanggal Pengeluaran',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _tanggalController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: '--/--/----',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: _pickDate,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  'Kategori pengeluaran',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: _selectedKategori,
                  hint: const Text('-- Pilih Kategori --'),
                  onChanged: (value) {
                    setState(() {
                      _selectedKategori = value;
                    });
                  },
                  items: _kategoriList
                      .map((kategori) => DropdownMenuItem(
                            value: kategori,
                            child: Text(kategori),
                          ))
                      .toList(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  'Nominal',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _nominalController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Masukkan nominal pengeluaran',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  'Bukti Pengeluaran',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 80,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: const Text(
                    'Upload bukti pengeluaran (.png/.jpg)',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // submit logic here
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF635BFF), // 💜 matches the screenshot
                        foregroundColor: Colors.white,            // ensures text stays white
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        textStyle: const TextStyle(fontWeight: FontWeight.w600),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('Submit'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () {
                        _namaController.clear();
                        _nominalController.clear();
                        _tanggalController.clear();
                        setState(() {
                          _selectedKategori = null;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        side: const BorderSide(color: Color(0xFFE0E0E0)),
                        backgroundColor: const Color(0xFFF7F8FB),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        _tanggalController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }
}
