import 'package:flutter/material.dart';

class pemasukanLainTambahPage extends StatefulWidget {
  const pemasukanLainTambahPage({super.key});

  @override
  State<pemasukanLainTambahPage> createState() => _pemasukanLainTambahPageState();
}

class _pemasukanLainTambahPageState extends State<pemasukanLainTambahPage> {
  // Controller untuk setiap field
  final _namaController = TextEditingController();
  final _tanggalController = TextEditingController();
  final _nominalController = TextEditingController();
  String? _selectedKategori;

  // Daftar item untuk dropdown
  final List<String> _kategoriList = [
    'Donasi',
    'Dana Bantuan Pemerintah',
    'Sumbangan Swadayana',
    'Hasil Usaha Kampung',
    'Dana Lainnya'
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _tanggalController.dispose();
    _nominalController.dispose();
    super.dispose();
  }

  // Fungsi untuk mereset semua field
  void _resetForm() {
    setState(() {
      _namaController.clear();
      _tanggalController.clear();
      _nominalController.clear();
      _selectedKategori = null;
    });
  }

  // Fungsi untuk menampilkan date picker
  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      // Format tanggal: dd/MM/yyyy
      String formattedDate =
          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      setState(() {
        controller.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 1. Judul
                    const Text(
                      'Buat Pemasukan Non Iuran Baru',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 2. Field Nama Pemasukan
                    _buildTextField(
                      controller: _namaController,
                      label: 'Nama Pemasukan',
                      hint: 'Masukkan nama pemasukan',
                    ),
                    const SizedBox(height: 16),

                    // 3. Field Tanggal Pemasukan
                    _buildDateField(
                      context: context,
                      controller: _tanggalController,
                      label: 'Tanggal Pemasukan',
                    ),
                    const SizedBox(height: 16),

                    // 4. Field Kategori Pemasukan
                    _buildDropdownField(),
                    const SizedBox(height: 16),

                    // 5. Field Nominal
                    _buildTextField(
                      controller: _nominalController,
                      label: 'Nominal',
                      hint: 'Masukkan nama pemasukan',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    // 6. Area Upload Bukti
                    _buildFileUploadArea(),
                    const SizedBox(height: 32),

                    // 7. Tombol Aksi
                    _buildActionButtons(),
                    const SizedBox(height: 16),

                    // 8. Teks "Powered by"
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Powered by POINA',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  // --- WIDGET HELPER ---

  // Helper untuk Teks Field
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            hintText: '-- / -- / ----',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today_outlined),
              onPressed: () => _selectDate(context, controller),
            ),
          ),
          onTap: () => _selectDate(context, controller),
        ),
      ],
    );
  }

  // Helper untuk Dropdown Field
  Widget _buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kategori pemasukan',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedKategori,
          hint: const Text('-- Pilih Kategori --'),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          ),
          onChanged: (String? newValue) {
            setState(() {
              _selectedKategori = newValue;
            });
          },
          items: _kategoriList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Helper untuk Area Upload File
  Widget _buildFileUploadArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bukti Pemasukan',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () {
          },
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey.shade300, width: 1.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.upload_file_outlined,
                    color: Colors.grey.shade600, size: 40),
                const SizedBox(height: 8),
                Text(
                  'Upload bukti pemasukan (.png/.jpg)',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Helper untuk Tombol Aksi
  Widget _buildActionButtons() {
    return Row(
      children: [
        // Tombol Submit
        ElevatedButton(
          onPressed: () {
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text('Submit'),
        ),
        const SizedBox(width: 16),
        // Tombol Reset
        TextButton(
          onPressed: _resetForm,
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey.shade700,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide(color: Colors.grey.shade300)),
          ),
          child: const Text('Reset'),
        ),
      ],
    );
  }
}