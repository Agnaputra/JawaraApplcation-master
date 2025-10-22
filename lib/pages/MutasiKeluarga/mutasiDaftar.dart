import 'package:flutter/material.dart';
import 'mutasiTambah.dart';

class mutasiDaftar extends StatefulWidget {
  const mutasiDaftar({super.key});

  @override
  State<mutasiDaftar> createState() => _mutasiDaftarState();
}

class _mutasiDaftarState extends State<mutasiDaftar> {
  final List<bool> _expanded = [];

  String? _filterStatus;
  String? _filterFamily;

  final List<Map<String, String>> _all = [
    {
      'family': 'Keluarga A',
      'date': '2025-10-01',
      'type': 'Pindah Masuk',
      'alamat_baru': 'Jl. Kenanga No. 12, Bandung',
      'alasan': 'Pekerjaan'
    },
    {
      'family': 'Keluarga B',
      'date': '2025-09-15',
      'type': 'Pindah Keluar',
      'alamat_baru': 'Jl. Merpati No. 8, Jakarta',
      'alasan': 'Mengikuti keluarga'
    },
  ];

  List<Map<String, String>> get _visible => _all.where((m) {
        final matchesStatus = _filterStatus == null || m['type'] == _filterStatus;
        final matchesFamily = _filterFamily == null || m['family'] == _filterFamily;
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: OutlinedButton.icon(
              onPressed: () => _showFilterDialog(context),
              icon: const Icon(Icons.filter_list),
              label: const Text('Filter'),
            ),
          ),
        ],
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

  Widget _buildCard({required String family, required String date, required String type, required MaterialColor color, required int index}) {
    final expanded = _expanded.length > index ? _expanded[index] : false;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() {
              if (_expanded.length > index) _expanded[index] = !_expanded[index];
            }),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(family, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text('Tanggal: $date', style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: color[100], borderRadius: BorderRadius.circular(16)), child: Text(type, style: TextStyle(color: color[800], fontSize: 12))),
                  const SizedBox(width: 8),
                  Icon(expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.grey),
                ],
              ),
            ),
          ),
          if (expanded)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Nama Keluarga: $family'),
                Text('Tanggal Mutasi: $date'),
                const SizedBox(height: 8),
                Row(children: [
                  const Text('Jenis Mutasi: '),
                  Chip(label: Text(type), backgroundColor: color[100], labelStyle: TextStyle(color: color[800])),
                ]),
                const SizedBox(height: 12),
                // Show alamat baru and alasan when available
                if ((type == 'Pindah Masuk' || type == 'Pindah Keluar'))
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Alamat Baru: ${_all[index]['alamat_baru'] ?? '-'}'),
                      Text('Alasan: ${_all[index]['alasan'] ?? '-'}'),
                    ]),
                  ),
                _buildDetails(type),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      // prepare initial data for editing
                      final initial = Map<String, String>.from(_all[index]);
                      final result = await Navigator.push<Map<String, String>?>(
                        context,
                        MaterialPageRoute(builder: (_) => MutasiTambah(families: _all.map((e) => e['family'] ?? '').toSet().toList(), initialData: initial)),
                      );
                      if (result == null) return;

                      // try to match by family+date
                      final matchFamily = result['family'];
                      final matchDate = result['date'];
                      var applied = false;
                      for (var i = 0; i < _all.length; i++) {
                        if (_all[i]['family'] == matchFamily && _all[i]['date'] == matchDate) {
                          setState(() {
                            _all[i] = Map<String, String>.from(result);
                          });
                          applied = true;
                          break;
                        }
                      }
                      // fallback: replace by index
                      if (!applied) {
                        setState(() {
                          _all[index] = Map<String, String>.from(result);
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.purple[100], foregroundColor: Colors.purple[800], elevation: 0),
                    child: const Text('Edit'),
                  ),
                ),
              ]),
            ),
        ],
      ),
    );
  }

  Widget _buildDetails(String type) {
    switch (type) {
      case 'Pindah Masuk':
        return const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Alamat Asal: Jl. Merdeka No.10'), Text('No. Surat: PM-2025-001')]);
      case 'Pindah Keluar':
        return const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Alamat Tujuan: Jl. Raya'), Text('No. Surat: PK-2025-002')]);
      default:
        return const SizedBox.shrink();
    }
  }

  void _showFilterDialog(BuildContext context) {
    String? selectedStatus = _filterStatus;
    String? selectedFamily = _filterFamily;

    final families = _all.map((e) => e['family']).whereType<String>().toSet().toList();

    showDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Filter Mutasi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(onPressed: () => Navigator.pop(dialogContext), icon: const Icon(Icons.close)),
              ]),
              const SizedBox(height: 12),
              const Text('Status'),
              DropdownButtonFormField<String?>(
                value: selectedStatus,
                items: const [
                  DropdownMenuItem<String?>(value: null, child: Text('-- Semua --')),
                  DropdownMenuItem<String?>(value: 'Pindah Masuk', child: Text('Pindah Rumah')),
                  DropdownMenuItem<String?>(value: 'Pindah Keluar', child: Text('Keluar Perumahan')),
                ],
                onChanged: (v) => selectedStatus = v,
                decoration: const InputDecoration(),
              ),
              const SizedBox(height: 12),
              const Text('Keluarga'),
              DropdownButtonFormField<String?>(
                value: selectedFamily,
                items: [
                  const DropdownMenuItem<String?>(value: null, child: Text('-- Semua Keluarga --')),
                  ...families.map((f) => DropdownMenuItem<String?>(value: f, child: Text(f))).toList(),
                ],
                onChanged: (v) => selectedFamily = v,
                decoration: const InputDecoration(),
              ),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                TextButton(onPressed: () {
                  setState(() {
                    _filterStatus = null;
                    _filterFamily = null;
                  });
                  Navigator.pop(dialogContext);
                }, child: const Text('Reset Filter')),
                ElevatedButton(onPressed: () {
                  setState(() {
                    _filterStatus = selectedStatus;
                    _filterFamily = selectedFamily;
                  });
                  Navigator.pop(dialogContext);
                }, child: const Text('Terapkan')),
              ])
            ]),
          ),
        );
      },
    );
  }
}