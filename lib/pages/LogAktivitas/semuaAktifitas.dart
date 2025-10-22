
import 'package:flutter/material.dart';

class semuaAktifitas extends StatelessWidget {
  const semuaAktifitas({super.key});

  @override
  Widget build(BuildContext context) => const SemuaAktivitasSection();
}

class SemuaAktivitasSection extends StatefulWidget {
  const SemuaAktivitasSection({Key? key}) : super(key: key);

  @override
  State<SemuaAktivitasSection> createState() => SemuaAktivitasSectionState();
}

class SemuaAktivitasSectionState extends State<SemuaAktivitasSection> {
  final List<bool> _expanded = [];

  final List<Map<String, String>> _allAktivitas = [
    {
      'deskripsi': 'User login ke aplikasi',
      'aktor': 'Majid',
      'tanggal': '2025-10-21 08:12',
    },
    {
      'deskripsi': 'Menambah data channel transfer',
      'aktor': 'Charel',
      'tanggal': '2025-10-21 09:00',
    },
    {
      'deskripsi': 'Edit data pengguna',
      'aktor': 'Agna',
      'tanggal': '2025-10-20 17:45',
    },
    {
      'deskripsi': 'Menghapus data keluarga',
      'aktor': 'Majid',
      'tanggal': '2025-10-19 14:30',
    },
  ];

  // Filter fields
  String _filterDeskripsi = '';
  String _filterAktor = '';
  DateTime? _filterDariTanggal;
  DateTime? _filterSampaiTanggal;

  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _aktorController = TextEditingController();

  List<Map<String, String>> get _visible {
    return _allAktivitas.where((a) {
      final deskripsi = a['deskripsi']?.toLowerCase() ?? '';
      final aktor = a['aktor']?.toLowerCase() ?? '';
      final tanggalStr = a['tanggal'] ?? '';
      final tanggal = tanggalStr.isNotEmpty ? DateTime.tryParse(tanggalStr.replaceAll(' ', 'T')) : null;

      if (_filterDeskripsi.isNotEmpty && !deskripsi.contains(_filterDeskripsi.toLowerCase())) return false;
      if (_filterAktor.isNotEmpty && !aktor.contains(_filterAktor.toLowerCase())) return false;
      if (_filterDariTanggal != null && (tanggal == null || tanggal.isBefore(_filterDariTanggal!))) return false;
      if (_filterSampaiTanggal != null && (tanggal == null || tanggal.isAfter(_filterSampaiTanggal!))) return false;
      return true;
    }).toList();
  }

  void _ensureExpandedLength() {
    if (_expanded.length != _visible.length) {
      _expanded.clear();
      _expanded.addAll(List<bool>.filled(_visible.length, false));
      if (_expanded.isNotEmpty) _expanded[0] = true;
    }
  }

  void _resetFilters() {
    setState(() {
      _filterDeskripsi = '';
      _filterAktor = '';
      _filterDariTanggal = null;
      _filterSampaiTanggal = null;
      _deskripsiController.clear();
      _aktorController.clear();
    });
  }

  @override
  void dispose() {
    _deskripsiController.dispose();
    _aktorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _ensureExpandedLength();

    return Scaffold(
      appBar: AppBar(title: const Text('Semua Aktivitas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // FILTER BUTTON DI KANAN
            Row(
              children: [
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: () => _showFilterDialog(context),
                  icon: const Icon(Icons.filter_list),
                  label: const Text('Filter'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // LIST
            Expanded(
              child: _visible.isEmpty
                  ? const Center(child: Text('Tidak ada aktivitas ditemukan.'))
                  : ListView.separated(
                      itemCount: _visible.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (ctx, i) {
                        final a = _visible[i];
                        final idx = i;
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Column(children: [
                            InkWell(
                              onTap: () => setState(() => _expanded[idx] = !_expanded[idx]),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                child: Row(children: [
                                  Expanded(child: Text(a['deskripsi'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                                  const SizedBox(width: 8),
                                  Icon(_expanded[idx] ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.grey),
                                ]),
                              ),
                            ),
                            if (_expanded.length > idx && _expanded[idx])
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    DropdownButton<String>(
                                      value: a['aktor'],
                                      items: [DropdownMenuItem(value: a['aktor'], child: Text('Aktor: ${a['aktor']}'))],
                                      onChanged: null,
                                    ),
                                    DropdownButton<String>(
                                      value: a['tanggal'],
                                      items: [DropdownMenuItem(value: a['tanggal'], child: Text('Tanggal: ${a['tanggal']}'))],
                                      onChanged: null,
                                    ),
                                  ],
                                ),
                              )
                          ]),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Theme(
            data: Theme.of(context).copyWith(canvasColor: Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Filter Aktivitas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  const Text('Deskripsi'),
                  TextField(
                    controller: _deskripsiController,
                    decoration: const InputDecoration(hintText: 'Cari deskripsi...'),
                  ),
                  const SizedBox(height: 12),

                  const Text('Aktor / Pelaku'),
                  TextField(
                    controller: _aktorController,
                    decoration: const InputDecoration(hintText: 'Cari aktor...'),
                  ),
                  const SizedBox(height: 12),

                  const Text('Dari Tanggal'),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _filterDariTanggal ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          _filterDariTanggal = picked;
                        });
                        // Update display in dialog
                        (dialogContext as Element).markNeedsBuild();
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(),
                      child: Text(
                        _filterDariTanggal == null
                            ? '-- Pilih Tanggal --'
                            : '${_filterDariTanggal!.year}-${_filterDariTanggal!.month.toString().padLeft(2, '0')}-${_filterDariTanggal!.day.toString().padLeft(2, '0')}',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  const Text('Sampai Tanggal'),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _filterSampaiTanggal ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          _filterSampaiTanggal = picked;
                        });
                        // Update display in dialog
                        (dialogContext as Element).markNeedsBuild();
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(),
                      child: Text(
                        _filterSampaiTanggal == null
                            ? '-- Pilih Tanggal --'
                            : '${_filterSampaiTanggal!.year}-${_filterSampaiTanggal!.month.toString().padLeft(2, '0')}-${_filterSampaiTanggal!.day.toString().padLeft(2, '0')}',
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          _resetFilters();
                          Navigator.pop(dialogContext);
                        },
                        child: const Text('Reset Filter'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _filterDeskripsi = _deskripsiController.text;
                            _filterAktor = _aktorController.text;
                          });
                          Navigator.pop(dialogContext);
                        },
                        child: const Text('Terapkan'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}