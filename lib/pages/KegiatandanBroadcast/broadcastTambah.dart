import 'package:flutter/material.dart';

// --- BAGIAN 1: FORMULIR INPUT (STATEFUL) ---
class _BroadcastTambahForm extends StatefulWidget {
  const _BroadcastTambahForm({super.key});

  @override
  State<_BroadcastTambahForm> createState() => _BroadcastTambahFormState();
}

class _BroadcastTambahFormState extends State<_BroadcastTambahForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _pesanController = TextEditingController();

  // State dummy untuk simulasi file upload
  bool _isPhotoSelected = false;
  bool _isDocSelected = false;

  @override
  void dispose() {
    _judulController.dispose();
    _pesanController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _judulController.clear();
    _pesanController.clear();

    setState(() {
      _isPhotoSelected = false;
      _isDocSelected = false;
    });
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    // Simulasi keberhasilan UI
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Broadcast "${_judulController.text}" siap dikirim (UI OK)!',
        ),
        // Menggunakan Colors.deepPurple
        backgroundColor: Colors.deepPurple,
      ),
    );

    _resetForm();
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint, {
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF454545),
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF0F0F5),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                // Menggunakan Colors.deepPurple
                color: Colors.deepPurple,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
          validator: validator,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildFileUploadBox(
    String title,
    String subtitle,
    bool isSelected, {
    required VoidCallback onSimulateUpload,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF454545),
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: onSimulateUpload,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.green.withOpacity(0.1)
                  : const Color(0xFFF0F0F5),
              border: Border.all(
                color: isSelected ? Colors.green : const Color(0xFFD6D3D6),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: isSelected
                  ? const Text(
                      'File berhasil diunggah! (Simulasi)',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : Text(
                      'Upload ${title.split(' ')[0].toLowerCase()}',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Powered by PQRIA',
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildTextField(
            _judulController,
            'Judul Broadcast',
            'Masukkan judul broadcast',
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Judul wajib diisi' : null,
          ),
          _buildTextField(
            _pesanController,
            'Isi Broadcast',
            'Tulis isi broadcast di sini...',
            maxLines: 6,
            validator: (value) => (value == null || value.isEmpty)
                ? 'Isi pesan wajib diisi'
                : null,
          ),
          _buildFileUploadBox(
            'Foto',
            'Maksimal 10 gambar (.png/.jpg/.jpeg), ukuran maksimal 5MB per gambar.',
            _isPhotoSelected,
            onSimulateUpload: () {
              setState(() => _isPhotoSelected = !_isPhotoSelected);
            },
          ),
          _buildFileUploadBox(
            'Dokumen',
            'Maksimal 10 file (.pdf), ukuran maksimal 5MB per file.',
            _isDocSelected,
            onSimulateUpload: () {
              setState(() => _isDocSelected = !_isDocSelected);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  // Menggunakan Colors.deepPurple
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 5,
                ),
                child: const Text('Submit'),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: _resetForm,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
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
    );
  }
}

// --- BAGIAN 2: HALAMAN UTAMA ---
class BroadcastTambahPage extends StatelessWidget {
  const BroadcastTambahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            decoration: BoxDecoration(
              // Menggunakan warna solid Colors.deepPurple
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(Icons.campaign, color: Colors.white, size: 30),
                SizedBox(width: 15),
                Text(
                  'Buat Broadcast Baru',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: const _BroadcastTambahForm(),
            ),
          ),
        ],
      ),
    );
  }
}

