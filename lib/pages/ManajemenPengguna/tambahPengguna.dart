import 'package:flutter/material.dart';

class TambahPenggunaSection extends StatefulWidget {
  final Map<String, String>? initialData;

  const TambahPenggunaSection({Key? key, this.initialData}) : super(key: key);

  @override
  State<TambahPenggunaSection> createState() => _TambahPenggunaSectionState();
}

class _TambahPenggunaSectionState extends State<TambahPenggunaSection> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _roleController;
  late TextEditingController _nikController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  String _gender = 'Laki-laki';
  String _status = 'Pending';
  String _role = 'Warga';

  @override
  void initState() {
    super.initState();
    final d = widget.initialData ?? {};
    _nameController = TextEditingController(text: d['name'] ?? '');
  _roleController = TextEditingController(text: d['role'] ?? '');
  _role = d['role'] ?? _role;
    _nikController = TextEditingController(text: d['nik'] ?? '');
    _emailController = TextEditingController(text: d['email'] ?? '');
    _phoneController = TextEditingController(text: d['phone'] ?? '');
    _passwordController = TextEditingController(text: '');
    _confirmPasswordController = TextEditingController(text: '');
    _gender = d['gender'] ?? _gender;
    _status = d['status'] ?? _status;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _nikController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;
    final result = {
      'name': _nameController.text.trim(),
      'role': _role,
      'nik': _nikController.text.trim(),
      'email': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
      'gender': _gender,
      'status': _status,
      'password': _passwordController.text.trim(), // empty if not changed
    };
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.initialData == null ? 'Tambah Pengguna' : 'Edit Pengguna')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Harap isi nama' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nikController,
                decoration: const InputDecoration(labelText: 'NIK'),
              ),
              const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                          keyboardType: TextInputType.emailAddress,
                        ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _gender,
                items: const [
                  DropdownMenuItem(value: 'Laki-laki', child: Text('Laki-laki')),
                  DropdownMenuItem(value: 'Perempuan', child: Text('Perempuan')),
                ],
                onChanged: (v) => setState(() => _gender = v ?? _gender),
                decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _status,
                items: const [
                  DropdownMenuItem(value: 'Diterima', child: Text('Diterima')),
                  DropdownMenuItem(value: 'Ditolak', child: Text('Ditolak')),
                  DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                ],
                onChanged: (v) => setState(() => _status = v ?? _status),
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password Baru'),
                obscureText: true,
                // optional: only validate confirmation if user enters a new password
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(labelText: 'Konfirmasi Password Baru'),
                obscureText: true,
                validator: (v) {
                  final pass = _passwordController.text;
                  final conf = v ?? '';
                  if (pass.isNotEmpty && pass != conf) return 'Konfirmasi password tidak cocok';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _role,
                decoration: const InputDecoration(labelText: 'Role'),
                items: const [
                  DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                  DropdownMenuItem(value: 'Ketua RW', child: Text('Ketua RW')),
                  DropdownMenuItem(value: 'Ketua RT', child: Text('Ketua RT')),
                  DropdownMenuItem(value: 'Sekretaris', child: Text('Sekretaris')),
                  DropdownMenuItem(value: 'Bendahara', child: Text('Bendahara')),
                  DropdownMenuItem(value: 'Warga', child: Text('Warga')),
                ],
                onChanged: (v) => setState(() => _role = v ?? _role),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
                  const SizedBox(width: 12),
                  ElevatedButton(onPressed: _onSave, child: const Text('Simpan')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Backwards-compatible wrapper expected by the sidebar navigation.
class tambahPenggunaPage extends StatelessWidget {
  const tambahPenggunaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const TambahPenggunaSection();
}
