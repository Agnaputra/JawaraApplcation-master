import 'package:flutter/material.dart';

class MutasiTambah extends StatefulWidget {
  /// Optional list of family names to populate the family dropdown.
  final List<String>? families;
  /// If provided, used to prefill the form for editing.
  final Map<String, String>? initialData;

  const MutasiTambah({super.key, this.families, this.initialData});

  @override
  State<MutasiTambah> createState() => _MutasiTambahState();
}

class _MutasiTambahState extends State<MutasiTambah> {
  final _formKey = GlobalKey<FormState>();

  String? _jenis; // 'Pindah Masuk' or 'Pindah Keluar'
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
    );
    if (picked != null) setState(() => _tanggal = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final result = {
      'type': _jenis ?? '',
      'family': _keluarga ?? '',
      'alasan': _alasan ?? '',
      'date': _tanggal != null ? _tanggal!.toIso8601String().split('T').first : DateTime.now().toIso8601String().split('T').first,
    };

    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Mutasi Keluarga')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _jenis,
                decoration: const InputDecoration(labelText: 'Jenis Mutasi'),
                items: const [
                  DropdownMenuItem(value: 'Pindah Masuk', child: Text('Pindah Masuk')),
                  DropdownMenuItem(value: 'Pindah Keluar', child: Text('Pindah Keluar')),
                ],
                validator: (v) => v == null || v.isEmpty ? 'Pilih jenis mutasi' : null,
                onChanged: (v) => setState(() => _jenis = v),
                onSaved: (v) => _jenis = v,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _keluarga,
                decoration: const InputDecoration(labelText: 'Keluarga'),
                items: _families.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                validator: (v) => v == null || v.isEmpty ? 'Pilih keluarga' : null,
                onChanged: (v) => setState(() => _keluarga = v),
                onSaved: (v) => _keluarga = v,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Alasan Mutasi'),
                maxLines: 2,
                onSaved: (v) => _alasan = v,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'Tanggal Mutasi'),
                      child: InkWell(
                        onTap: _pickDate,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(_tanggal != null ? _tanggal!.toLocal().toIso8601String().split('T').first : 'Pilih tanggal'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(onPressed: _pickDate, child: const Text('Pilih')),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
                  const SizedBox(width: 12),
                  ElevatedButton(onPressed: _save, child: const Text('Simpan')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}