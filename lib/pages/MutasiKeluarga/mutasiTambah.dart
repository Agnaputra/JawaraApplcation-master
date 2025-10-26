import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MutasiTambah extends StatefulWidget {
  final List<String>? families;
  final Map<String, String>? initialData;

  const MutasiTambah({super.key, this.families, this.initialData});

  @override
  State<MutasiTambah> createState() => _MutasiTambahState();
}

class _MutasiTambahState extends State<MutasiTambah> {
  final _formKey = GlobalKey<FormState>();
  String? _jenis;
  String? _keluarga;
  String? _alasan;
  DateTime? _tanggal;

  @override
  void initState() {
    super.initState();
    final d = widget.initialData;
    if (d != null) {
      _jenis = d['type'];
      _keluarga = d['family'];
      _alasan = d['alasan'];
      try {
        _tanggal = DateTime.parse(d['date'] ?? '');
      } catch (_) {
        _tanggal = null;
      }
    }
  }

  List<String> get _families => widget.families ?? ['Keluarga A', 'Keluarga B'];

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggal ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.deepPurple,
            colorScheme:
                const ColorScheme.light(primary: Colors.deepPurple),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _tanggal = picked);
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _jenis = null;
      _keluarga = null;
      _alasan = null;
      _tanggal = null;
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final result = {
      'type': _jenis ?? '',
      'family': _keluarga ?? '',
      'alasan': _alasan ?? '',
      'date': _tanggal != null
          ? _tanggal!.toIso8601String().split('T').first
          : DateTime.now().toIso8601String().split('T').first,
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mutasi keluarga berhasil disimpan!'),
        backgroundColor: Colors.deepPurple,
      ),
    );

    Navigator.pop(context, result);
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required Function(T?) onChanged,
    String? Function(T?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: Color(0xFF454545))),
        const SizedBox(height: 5),
        DropdownButtonFormField<T>(
          value: value,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF0F0F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.deepPurple,
                width: 1.5,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          ),
          items: items,
          onChanged: onChanged,
          validator: validator,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    int maxLines = 1,
    required Function(String?) onSaved,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: Color(0xFF454545))),
        const SizedBox(height: 5),
        TextFormField(
          maxLines: maxLines,
          onSaved: onSaved,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF0F0F5),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: Colors.deepPurple, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    String dateText = _tanggal == null
        ? '-- / -- / ----'
        : DateFormat('dd-MM-yyyy').format(_tanggal!);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F5FB),
      appBar: AppBar(
        title: const Text('Tambah Mutasi Keluarga'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 3,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Formulir Mutasi Keluarga",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Jenis Mutasi
                  _buildDropdown<String>(
                    label: 'Jenis Mutasi',
                    value: _jenis,
                    items: const [
                      DropdownMenuItem(
                          value: 'Pindah Masuk', child: Text('Pindah Masuk')),
                      DropdownMenuItem(
                          value: 'Pindah Keluar', child: Text('Pindah Keluar')),
                    ],
                    onChanged: (v) => setState(() => _jenis = v),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Pilih jenis mutasi' : null,
                  ),

                  // Keluarga
                  _buildDropdown<String>(
                    label: 'Nama Keluarga',
                    value: _keluarga,
                    items: _families
                        .map((f) =>
                            DropdownMenuItem(value: f, child: Text(f)))
                        .toList(),
                    onChanged: (v) => setState(() => _keluarga = v),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Pilih keluarga' : null,
                  ),

                  // Alasan Mutasi
                  _buildTextField(
                    label: 'Alasan Mutasi',
                    hint: 'Contoh: Pindah tempat kerja atau studi',
                    maxLines: 3,
                    onSaved: (v) => _alasan = v,
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'Alasan mutasi wajib diisi'
                        : null,
                  ),

                  // Tanggal Mutasi
                  const Text(
                    'Tanggal Mutasi',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF454545)),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    readOnly: true,
                    controller: TextEditingController(text: dateText),
                    onTap: _pickDate,
                    decoration: InputDecoration(
                      hintText: '-- / -- / ----',
                      filled: true,
                      fillColor: const Color(0xFFF0F0F5),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Colors.deepPurple, width: 1.5),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.calendar_month,
                          color: Colors.deepPurple,
                        ),
                        onPressed: _pickDate,
                      ),
                    ),
                    validator: (value) =>
                        (_tanggal == null) ? 'Tanggal wajib diisi' : null,
                  ),
                  const SizedBox(height: 30),

                  // Tombol Aksi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 5,
                        ),
                        child: const Text('Simpan'),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton(
                        onPressed: _resetForm,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: const BorderSide(color: Colors.grey),
                        ),
                        child: const Text(
                          'Reset',
                          style: TextStyle(color: Colors.black54),
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
    );
  }
}
