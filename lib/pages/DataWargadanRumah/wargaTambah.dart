import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class wargaTambahPage extends StatefulWidget {
  const wargaTambahPage({super.key});

  @override
  State<wargaTambahPage> createState() => _wargaTambahPageState();
}

class _wargaTambahPageState extends State<wargaTambahPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;

  // Controllers
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController teleponController = TextEditingController();
  final TextEditingController tempatLahirController = TextEditingController();

  // Dropdown values
  String? keluargaValue;
  String? jenisKelaminValue;
  String? agamaValue;
  String? golonganDarahValue;
  String? peranKeluargaValue;
  String? pendidikanValue;
  String? pekerjaanValue;
  String? statusValue;

  // Dropdown lists
  final keluargaList = ['Keluarga A', 'Keluarga B', 'Keluarga C'];
  final jenisKelaminList = ['Laki-laki', 'Perempuan'];
  final agamaList = ['Islam', 'Kristen', 'Katolik', 'Hindu', 'Buddha', 'Konghucu'];
  final golonganDarahList = ['A', 'B', 'AB', 'O'];
  final peranKeluargaList = ['Kepala Keluarga', 'Istri', 'Anak'];
  final pendidikanList = ['SD', 'SMP', 'SMA', 'Diploma', 'Sarjana'];
  final pekerjaanList = ['Pelajar', 'Pegawai', 'Wiraswasta', 'Tidak Bekerja'];
  final statusList = ['Aktif', 'Tidak Aktif'];

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2050),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Responsive max width
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.05),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tambah Warga',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildDropdown('Pilih Keluarga', keluargaList, keluargaValue,
                        (val) => setState(() => keluargaValue = val)),

                    _buildTextField('Nama', 'Masukkan nama lengkap', namaController),
                    _buildTextField('NIK', 'Masukkan NIK sesuai KTP', nikController),
                    _buildTextField('Nomor Telepon', '08xxxxxx', teleponController),
                    _buildTextField('Tempat Lahir', 'Masukkan tempat lahir', tempatLahirController),

                    const SizedBox(height: 8),
                    const Text('Tanggal Lahir'),
                    const SizedBox(height: 4),
                    TextField(
                      readOnly: true,
                      onTap: () => _pickDate(context),
                      decoration: InputDecoration(
                        hintText: selectedDate == null
                            ? '--/--/----'
                            : DateFormat('d MMMM yyyy').format(selectedDate!),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _pickDate(context),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    _buildDropdown('Jenis Kelamin', jenisKelaminList, jenisKelaminValue,
                        (val) => setState(() => jenisKelaminValue = val)),

                    _buildDropdown('Agama', agamaList, agamaValue,
                        (val) => setState(() => agamaValue = val)),

                    _buildDropdown('Golongan Darah', golonganDarahList, golonganDarahValue,
                        (val) => setState(() => golonganDarahValue = val)),

                    _buildDropdown('Peran Keluarga', peranKeluargaList, peranKeluargaValue,
                        (val) => setState(() => peranKeluargaValue = val)),

                    _buildDropdown('Pendidikan Terakhir', pendidikanList, pendidikanValue,
                        (val) => setState(() => pendidikanValue = val)),

                    _buildDropdown('Pekerjaan', pekerjaanList, pekerjaanValue,
                        (val) => setState(() => pekerjaanValue = val)),

                    _buildDropdown('Status', statusList, statusValue,
                        (val) => setState(() => statusValue = val)),

                    const SizedBox(height: 24),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Data berhasil disubmit!')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF635BFF),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Submit'),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton(
                          onPressed: () {
                            _formKey.currentState?.reset();
                            namaController.clear();
                            nikController.clear();
                            teleponController.clear();
                            tempatLahirController.clear();
                            setState(() {
                              keluargaValue = null;
                              jenisKelaminValue = null;
                              agamaValue = null;
                              golonganDarahValue = null;
                              peranKeluargaValue = null;
                              pendidikanValue = null;
                              pekerjaanValue = null;
                              statusValue = null;
                              selectedDate = null;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black87,
                            side: const BorderSide(color: Color(0xFFE0E0E0)),
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
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
        ),
      ),
    );
  }

  // Reusable widget for TextField
  Widget _buildTextField(String label, String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable widget for Dropdown
  Widget _buildDropdown(String label, List<String> items, String? value, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            value: value,
            hint: Text('-- Pilih $label --'),
            items: items
                .map((e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),
                    ))
                .toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
