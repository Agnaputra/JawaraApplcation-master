import 'package:flutter/material.dart';

import '../../widgets/filter_button.dart';
import 'tambahPengguna.dart';

class daftarPenggunaPage extends StatelessWidget {
  const daftarPenggunaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const ManajemenPenggunaSection();
}

class ManajemenPenggunaSection extends StatefulWidget {
  const ManajemenPenggunaSection({Key? key}) : super(key: key);

  @override
  State<ManajemenPenggunaSection> createState() => _ManajemenPenggunaSectionState();
}

class _ManajemenPenggunaSectionState extends State<ManajemenPenggunaSection> {
  final List<bool> _expanded = [];

  // Filters
  String _nameFilter = '';
  String? _statusFilter; // 'Diterima','Ditolak','Pending' or null

  final List<Map<String, String>> _allUsers = [
    {
      'name': 'charel',
      'nik': '123456789',
      'email': 'charel@example.com',
      'gender': 'Laki-laki',
      'status': 'Pending',
      'role': 'Warga',
      'phone': '' ,
      'photo': ''
    },
    {
      'name': 'agna',
      'nik': '987654321',
      'email': 'agna@example.com',
      'gender': 'Laki-laki',
      'status': 'Diterima',
      'role': 'Warga',
      'phone': '' ,
      'photo': ''
    },
    {
      'name': 'majid',
      'nik': '456789123',
      'email': 'majid@example.com',
      'gender': 'Laki-laki',
      'status': 'Ditolak',
      'role': 'Warga',
      'phone': '' ,
      'photo': ''
    },
    {
      'name': 'ridho',
      'nik': '321654987',
      'email': 'ridho@example.com',
      'gender': 'Laki-laki',
      'status': 'Pending',
      'role': 'Warga',
      'phone': '' ,
      'photo': ''
    },
    {
      'name': 'aqila',
      'nik': '654321987',
      'email': 'aqila@example.com',
      'gender': 'Perempuan',
      'status': 'Diterima',
      'role': 'Warga',
      'phone': '' ,
      'photo': ''
    },
  ];

  List<Map<String, String>> get _visible {
    return _allUsers.where((u) {
      final matchesName = _nameFilter.isEmpty || (u['name'] ?? '').toLowerCase().contains(_nameFilter.toLowerCase());
      final matchesStatus = _statusFilter == null || (u['status'] ?? '') == _statusFilter;
      return matchesName && matchesStatus;
    }).toList();
  }

  void _applyEdit(Map<String, String> result) {
    final nik = result['nik'];
    // Update the source list by nik, fallback to name if not found
    for (var i = 0; i < _allUsers.length; i++) {
      if (_allUsers[i]['nik'] == nik) {
        _allUsers[i] = Map<String, String>.from(result);
        break;
      }
    }

    // Recompute visible list and expansion state, then expand the edited item if visible
    setState(() {
      _ensureExpandedLength();
      final visIndex = _visible.indexWhere((u) => u['nik'] == nik);
      if (visIndex != -1) {
        // ensure array long enough
        if (_expanded.length <= visIndex) _expanded.addAll(List<bool>.filled(visIndex - _expanded.length + 1, false));
        _expanded[visIndex] = true;
      }
    });
  }

  void _ensureExpandedLength() {
    if (_expanded.length != _visible.length) {
      _expanded.clear();
      _expanded.addAll(List<bool>.filled(_visible.length, false));
      if (_expanded.isNotEmpty) _expanded[0] = true;
    }
  }

  void _showDetail(Map<String, String> u) {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
            title: Text((u['name'] ?? '').toLowerCase()),
          content: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Tingkat: ${u['role'] ?? ''}'),
              const SizedBox(height: 8),
              Text('NIK: ${u['nik'] ?? ''}'),
              const SizedBox(height: 8),
              Text('Email: ${u['email'] ?? ''}'),
              const SizedBox(height: 8),
              Text('No HP: ${u['phone'] ?? ''}'),
              const SizedBox(height: 8),
              Text('Jenis Kelamin: ${u['gender'] ?? ''}'),
              const SizedBox(height: 8),
              Text('Status Registrasi: ${u['status'] ?? ''}'),
              const SizedBox(height: 12),
              u['photo'] != null && (u['photo'] ?? '').isNotEmpty
                  ? Image.network(u['photo']!, height: 160, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox.shrink())
                  : Container(height: 160, color: Colors.grey.shade200, child: const Center(child: Icon(Icons.person, size: 64, color: Colors.grey))),
            ]),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(dialogCtx).pop(), child: const Text('Tutup')),
          ],
        );
      },
    );
  }

  void _showFilterDialog() {
    final nameCtrl = TextEditingController(text: _nameFilter);
    String? selStatus = _statusFilter;

    showDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (dCtx) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Filter Pengguna', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), IconButton(onPressed: () => Navigator.pop(dCtx), icon: const Icon(Icons.close))]),
              const SizedBox(height: 12),
              const Text('Nama'),
              TextField(controller: nameCtrl, decoration: const InputDecoration(hintText: 'Cari nama...')),
              const SizedBox(height: 12),
              const Text('Status'),
              DropdownButtonFormField<String?>(
                value: selStatus,
                items: const [
                  DropdownMenuItem(value: null, child: Text('-- Semua --')),
                  DropdownMenuItem(value: 'Diterima', child: Text('Diterima')),
                  DropdownMenuItem(value: 'Ditolak', child: Text('Ditolak')),
                  DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                ],
                onChanged: (v) => selStatus = v,
                decoration: const InputDecoration(),
              ),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _nameFilter = '';
                      _statusFilter = null;
                    });
                    Navigator.pop(dCtx);
                  },
                  child: const Text('Reset Filter'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _nameFilter = nameCtrl.text.trim();
                      _statusFilter = selStatus;
                    });
                    Navigator.pop(dCtx);
                  },
                  child: const Text('Terapkan'),
                ),
              ])
            ]),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _ensureExpandedLength();

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(padding: const EdgeInsets.only(right: 12.0), child: FilterButton(onPressed: _showFilterDialog, label: 'Filter'))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: _visible.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (ctx, i) {
            final u = _visible[i];
            final idx = i;
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(children: [
                InkWell(
                  onTap: () => setState(() {
                    if (_expanded.length > idx) _expanded[idx] = !_expanded[idx];
                  }),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Row(children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text((u['name'] ?? '').toLowerCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), const SizedBox(height: 4), Text(u['email'] ?? '', style: const TextStyle(color: Colors.grey))])),
                      // status chip color mapping: Menunggu -> orange, Diterima -> green, Ditolak -> yellow
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: (u['status'] == 'Diterima')
                              ? Colors.green[100]
                              : (u['status'] == 'Ditolak')
                                  ? Colors.yellow[100]
                                  : Colors.orange[100],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(u['status'] ?? '', style: TextStyle(color: (u['status'] == 'Diterima') ? Colors.green[800] : (u['status'] == 'Ditolak') ? Colors.yellow[800] : Colors.orange[800], fontSize: 12)),
                      ),
                      const SizedBox(width: 8),
                      Icon(_expanded.length > idx && _expanded[idx] ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.grey),
                    ]),
                  ),
                ),
                if (_expanded.length > idx && _expanded[idx])
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        const SizedBox(width: 4),
                        CircleAvatar(radius: 28, backgroundColor: Colors.grey.shade200, child: const Icon(Icons.person, size: 28)),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(u['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Text('Tingkat: ${u['role'] ?? ''}', style: const TextStyle(color: Colors.grey))])),
                      ]),
                      const SizedBox(height: 12),
                      _detailRow('NIK', u['nik'] ?? ''),
                      _detailRow('Email', u['email'] ?? ''),
                      _detailRow('No HP', u['phone'] ?? ''),
                      _detailRow('Jenis Kelamin', u['gender'] ?? ''),
                      _detailRow('Status Registrasi', u['status'] ?? ''),
                      const SizedBox(height: 12),
                                Row(children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () => _showDetail(u),
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.purple[100], foregroundColor: Colors.purple[800], elevation: 0),
                                      child: const Text('Lihat Detail'),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        final result = await Navigator.push<Map<String, String>?>(
                                          context,
                                          MaterialPageRoute(builder: (_) => TambahPenggunaSection(initialData: u)),
                                        );
                                        if (result == null) return;
                                        _applyEdit(result);
                                      },
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.purple[100], foregroundColor: Colors.purple[800], elevation: 0),
                                      child: const Text('Edit'),
                                    ),
                                  ),
                                ])
                    ]),
                  )
              ]),
            );
          },
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(children: [SizedBox(width: 140, child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold))), Expanded(child: Text(value))]),
    );
  }
}

