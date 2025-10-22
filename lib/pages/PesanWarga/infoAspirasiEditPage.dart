import 'package:flutter/material.dart';
class infoAspirasiEditPage extends StatefulWidget {
  final Map<String, dynamic> itemData;

  const infoAspirasiEditPage({Key? key, required this.itemData}) : super(key: key);

  @override
  State<infoAspirasiEditPage> createState() => _infoAspirasiEditPageState();
}

class _infoAspirasiEditPageState extends State<infoAspirasiEditPage> {
  late TextEditingController _judulController;
  late TextEditingController _deskripsiController;
  String? _selectedStatus;
  final List<String> _statusList = ['Diterima', 'Diproses', 'Ditolak'];

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.itemData['judul']);
    _deskripsiController = TextEditingController(text: widget.itemData['deskripsi']);
    _selectedStatus = widget.itemData['status'];
  }

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.arrow_back, color: Colors.blue),
                label: const Text(
                  'Kembali',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 16),

              SizedBox(
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
                      children: [
                        const Text(
                          'Edit Informasi Aspirasi Warga',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 24),
                        
                        _buildFormTextField(
                          controller: _judulController,
                          label: 'Judul Pesan',
                          isReadOnly: true,
                        ),
                        const SizedBox(height: 16),
                        
                        _buildFormTextField(
                          controller: _deskripsiController,
                          label: 'Deskripsi Pesan',
                          isReadOnly: true,
                          maxLines: 4,
                        ),
                        const SizedBox(height: 16),
                        
                        const Text('Status', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedStatus,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                          onChanged: (String? newValue) {
                            setState(() { _selectedStatus = newValue; });
                          },
                          items: _statusList.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(value: value, child: Text(value));
                          }).toList(),
                        ),
                        const SizedBox(height: 24),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Update'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormTextField({
    required TextEditingController controller,
    required String label,
    bool isReadOnly = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: isReadOnly,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: isReadOnly,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          ),
        ),
      ],
    );
  }
}