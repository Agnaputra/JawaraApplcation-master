import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class TambahChannelPage extends StatefulWidget {
  final Map<String, String>? initialData;
  const TambahChannelPage({Key? key, this.initialData}) : super(key: key);

  @override
  State<TambahChannelPage> createState() => _TambahChannelPageState();
}

class _TambahChannelPageState extends State<TambahChannelPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  String? _type;
  final _accountCtrl = TextEditingController();
  final _ownerCtrl = TextEditingController();
  final _qrUrlCtrl = TextEditingController();
  final _thumbUrlCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();



  @override
  void initState() {
    super.initState();
    final d = widget.initialData ?? {};
    if (d.isNotEmpty) {
      _nameCtrl.text = d['name'] ?? '';
      _type = d['type'];
      _accountCtrl.text = d['account'] ?? '';
      _ownerCtrl.text = d['owner'] ?? '';
      _thumbUrlCtrl.text = d['thumbnail'] ?? '';
      _qrUrlCtrl.text = d['qr'] ?? '';
      _noteCtrl.text = d['desc'] ?? '';
    }
  }

  Future<String?> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null || result.files.isEmpty) return null;
    return result.files.first.path;
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;
    final result = {
      'name': _nameCtrl.text.trim(),
      'type': _type ?? '',
      'account': _accountCtrl.text.trim(),
      'owner': _ownerCtrl.text.trim(),
      'thumbnail': _thumbUrlCtrl.text.trim(),
      'qr': _qrUrlCtrl.text.trim(),
      'desc': _noteCtrl.text.trim(),
    };
    Navigator.of(context).pop(result);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _accountCtrl.dispose();
    _ownerCtrl.dispose();
    _qrUrlCtrl.dispose();
    _thumbUrlCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buat Transfer Channel')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text('Nama Channel', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(hintText: 'Contoh: BCA, Dana, QRIS RT'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Harap isi nama channel' : null,
              ),
              const SizedBox(height: 16),

              const Text('Tipe', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _type,
                items: const [
                  DropdownMenuItem(value: 'Bank', child: Text('Bank')),
                  DropdownMenuItem(value: 'E-Wallet', child: Text('E-Wallet')),
                  DropdownMenuItem(value: 'QRIS', child: Text('QRIS')),
                ],
                onChanged: (v) => setState(() => _type = v),
                decoration: const InputDecoration(hintText: '-- Pilih Tipe --'),
                validator: (v) => (v == null || v.isEmpty) ? 'Pilih tipe channel' : null,
              ),
              const SizedBox(height: 16),

              const Text('Nomor Rekening / Akun', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _accountCtrl,
                decoration: const InputDecoration(hintText: 'Contoh: 1234567890'),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 16),

              const Text('Nama Pemilik', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _ownerCtrl,
                decoration: const InputDecoration(hintText: 'Contoh: John Doe'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Harap isi nama pemilik' : null,
              ),
              const SizedBox(height: 16),

              const Text('QR', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(
                  child: TextFormField(
                    controller: _qrUrlCtrl,
                    decoration: const InputDecoration(hintText: 'Path file QR atau URL — kosongkan jika tidak ada'),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () async {
                    final p = await _pickFile();
                    if (p != null) setState(() => _qrUrlCtrl.text = p);
                  },
                  child: const Text('Pilih File'),
                )
              ]),
              const SizedBox(height: 16),

              const Text('Thumbnail', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(
                  child: TextFormField(
                    controller: _thumbUrlCtrl,
                    decoration: const InputDecoration(hintText: 'Path file thumbnail atau URL — kosongkan jika tidak ada'),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () async {
                    final p = await _pickFile();
                    if (p != null) setState(() => _thumbUrlCtrl.text = p);
                  },
                  child: const Text('Pilih File'),
                )
              ]),
              const SizedBox(height: 16),

              const Text('Catatan (Opsional)', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _noteCtrl,
                maxLines: 4,
                decoration: const InputDecoration(hintText: 'Contoh: Transfer hanya dari bank yang sama agar instan'),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                    style: TextButton.styleFrom(foregroundColor: Colors.purple),
                  ),
                  ElevatedButton(
                    onPressed: _onSave,
                    child: const Text('Simpan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[100],
                      foregroundColor: Colors.purple[800],
                      elevation: 0,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// Backwards compatible wrapper for navigation if used elsewhere
class tambahChannelPage extends StatelessWidget {
  const tambahChannelPage({super.key});

  @override
  Widget build(BuildContext context) => const TambahChannelPage();
}

// End of file
                                             