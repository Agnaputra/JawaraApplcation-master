import 'package:flutter/material.dart';

class penerimaanWargaTambahPage extends StatefulWidget {
  final Map<String, String>? initialData;

  const penerimaanWargaTambahPage({super.key, this.initialData});

  @override
  State<penerimaanWargaTambahPage> createState() => _penerimaanWargaTambahPageState();
}

class _penerimaanWargaTambahPageState extends State<penerimaanWargaTambahPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nikController = TextEditingController();
  final _emailController = TextEditingController();
  String? _gender; // 'Laki-laki' or 'Perempuan'
  String? _status; // 'Menunggu','Diterima','Ditolak'

  @override
  void initState() {
    super.initState();
    final init = widget.initialData;
    if (init != null) {
      _nameController.text = init['name'] ?? '';
      _nikController.text = init['nik'] ?? '';
      _emailController.text = init['email'] ?? '';
      _gender = init['gender'];
      _status = init['status'];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nikController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      final map = {
        'name': _nameController.text.trim(),
        'nik': _nikController.text.trim(),
        'email': _emailController.text.trim(),
        'gender': _gender ?? 'Laki-laki',
        'status': _status ?? 'Menunggu',
      };
      Navigator.pop(context, map);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Penerimaan Warga')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nikController,
                decoration: const InputDecoration(labelText: 'NIK'),
                keyboardType: TextInputType.number,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'NIK wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
                  if (!v.contains('@')) return 'Email tidak valid';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
                items: const [
                  DropdownMenuItem(value: 'Laki-laki', child: Text('Laki-laki')),
                  DropdownMenuItem(value: 'Perempuan', child: Text('Perempuan')),
                ],
                onChanged: (v) => setState(() => _gender = v),
                validator: (v) => v == null ? 'Pilih jenis kelamin' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(labelText: 'Status Registrasi'),
                items: const [
                  DropdownMenuItem(value: 'Menunggu', child: Text('Menunggu')),
                  DropdownMenuItem(value: 'Diterima', child: Text('Diterima')),
                  DropdownMenuItem(value: 'Ditolak', child: Text('Ditolak')),
                ],
                onChanged: (v) => setState(() => _status = v),
                validator: (v) => v == null ? 'Pilih status' : null,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _save,
                    child: const Text('Simpan'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
