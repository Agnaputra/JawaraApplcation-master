import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MutasiDaftarPage extends StatefulWidget {
  const MutasiDaftarPage({super.key});

  @override
  State<MutasiDaftarPage> createState() => _MutasiDaftarPageState();
}

class _MutasiDaftarPageState extends State<MutasiDaftarPage> {
  final List<bool> _expanded = [];

  String? _filterStatus;
  String? _filterFamily;

  final List<Map<String, String>> _all = [
    {
      'family': 'Keluarga A',
      'date': '2025-10-01',
      'type': 'Pindah Masuk',
      'alamat_baru': 'Jl. Kenanga No. 12, Bandung',
      'alasan': 'Pekerjaan',
    },
    {
      'family': 'Keluarga B',
      'date': '2025-09-15',
      'type': 'Pindah Keluar',
      'alamat_baru': 'Jl. Merpati No. 8, Jakarta',
      'alasan': 'Mengikuti keluarga',
    },
  ];

  List<Map<String, String>> get _visible => _all.where((m) {
        final matchesStatus =
            _filterStatus == null || m['type'] == _filterStatus;
        final matchesFamily =
            _filterFamily == null || m['family'] == _filterFamily;
        return matchesStatus && matchesFamily;
      }).toList();

  void _ensureExpandedLength() {
    if (_expanded.length != _visible.length) {
      _expanded.clear();
      _expanded.addAll(List<bool>.filled(_visible.length, false));
      if (_expanded.isNotEmpty) _expanded[0] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    _ensureExpandedLength();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Mutasi'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),

      // ✅ Tombol filter hanya ikon
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        onPressed: () => _showFilterDialog(context),
        tooltip: 'Filter',
        child: const Icon(Icons.filter_list),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: _visible.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final m = _visible[i];
            final type = m['type'] ?? '';
            final color = type == 'Pindah Masuk'
                ? Colors.green
                : type == 'Pindah Keluar'
                    ? Colors.red
                    : Colors.grey;

            return _buildCard(
              family: m['family'] ?? '',
              date: m['date'] ?? '',
              type: type,
              color: color,
              index: i,
            );
          },
        ),
      ),
    );
  }

  Widget _buildCard({
    required String family,
    required String date,
    required String type,
    required MaterialColor color,
    required int index,
  }) {
    final expanded = _expanded.length > index ? _expanded[index] : false;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() {
              if (_expanded.length > index) {
                _expanded[index] = !_expanded[index];
              }
            }),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          family,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tanggal: $date',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      type,
                      style: TextStyle(color: color[800], fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          if (expanded)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nama Keluarga: $family'),
                  Text('Tanggal Mutasi: $date'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Jenis Mutasi: '),
                      Chip(
                        label: Text(type),
                        backgroundColor: color[100],
                        labelStyle: TextStyle(color: color[800]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('Alamat Baru: ${_all[index]['alamat_baru'] ?? '-'}'),
                  Text('Alasan: ${_all[index]['alasan'] ?? '-'}'),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Edit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple[100],
                        foregroundColor: Colors.deepPurple[800],
                        elevation: 0,
                      ),
                      onPressed: () =>
                          _showEditDialog(context, index, _all[index]),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showEditDialog(
      BuildContext context, int index, Map<String, String> currentData) {
    final _formKey = GlobalKey<FormState>();
    final _familyController =
        TextEditingController(text: currentData['family'] ?? '');
    final _alamatController =
        TextEditingController(text: currentData['alamat_baru'] ?? '');
    final _alasanController =
        TextEditingController(text: currentData['alasan'] ?? '');
    String type = currentData['type'] ?? '';
    DateTime date =
        DateTime.tryParse(currentData['date'] ?? '') ?? DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Edit Data Mutasi',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _familyController,
                    decoration:
                        const InputDecoration(labelText: 'Nama Keluarga'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Harus diisi' : null,
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: type,
                    items: const [
                      DropdownMenuItem(
                          value: 'Pindah Masuk', child: Text('Pindah Masuk')),
                      DropdownMenuItem(
                          value: 'Pindah Keluar', child: Text('Pindah Keluar')),
                    ],
                    onChanged: (v) => type = v ?? '',
                    decoration:
                        const InputDecoration(labelText: 'Jenis Mutasi'),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Tanggal',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            date = picked;
                            setState(() {});
                          }
                        },
                      ),
                    ),
                    controller: TextEditingController(
                        text: DateFormat('yyyy-MM-dd').format(date)),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _alamatController,
                    decoration: const InputDecoration(labelText: 'Alamat Baru'),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _alasanController,
                    decoration: const InputDecoration(labelText: 'Alasan'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _all[index] = {
                      'family': _familyController.text,
                      'type': type,
                      'date': DateFormat('yyyy-MM-dd').format(date),
                      'alamat_baru': _alamatController.text,
                      'alasan': _alasanController.text,
                    };
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Data mutasi "${_familyController.text}" berhasil diperbarui!'),
                    backgroundColor: Colors.deepPurple,
                  ));
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
    String? selectedStatus = _filterStatus;
    String? selectedFamily = _filterFamily;

    final families =
        _all.map((e) => e['family']).whereType<String>().toSet().toList();

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter Mutasi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Status'),
                DropdownButtonFormField<String?>(
                  value: selectedStatus,
                  items: const [
                    DropdownMenuItem<String?>(
                        value: null, child: Text('-- Semua --')),
                    DropdownMenuItem<String?>(
                        value: 'Pindah Masuk', child: Text('Pindah Masuk')),
                    DropdownMenuItem<String?>(
                        value: 'Pindah Keluar', child: Text('Pindah Keluar')),
                  ],
                  onChanged: (v) => selectedStatus = v,
                ),
                const SizedBox(height: 12),
                const Text('Keluarga'),
                DropdownButtonFormField<String?>(
                  value: selectedFamily,
                  items: [
                    const DropdownMenuItem<String?>(
                        value: null, child: Text('-- Semua Keluarga --')),
                    ...families
                        .map((f) =>
                            DropdownMenuItem<String?>(value: f, child: Text(f)))
                        .toList(),
                  ],
                  onChanged: (v) => selectedFamily = v,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _filterStatus = null;
                          _filterFamily = null;
                        });
                        Navigator.pop(dialogContext);
                      },
                      child: const Text('Reset Filter'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _filterStatus = selectedStatus;
                          _filterFamily = selectedFamily;
                        });
                        Navigator.pop(dialogContext);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Terapkan'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
