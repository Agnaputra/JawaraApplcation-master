import 'package:flutter/material.dart';

// --- BAGIAN 1: MODAL FILTER (STATEFUL) ---
class BroadcastFilterPage extends StatefulWidget {
  const BroadcastFilterPage({super.key});

  @override
  State<BroadcastFilterPage> createState() => _BroadcastFilterDialogState();
}

class _BroadcastFilterDialogState extends State<BroadcastFilterPage> {
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.deepPurple,
            colorScheme: const ColorScheme.light(primary: Colors.deepPurple),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _resetDate() {
    setState(() {
      _selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    String dateText = _selectedDate == null
        ? '-- / -- / ----'
        : '${_selectedDate!.day.toString().padLeft(2, '0')}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.year}';

    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Filter Broadcast',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Judul Broadcast',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Cari judul broadcast...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Tanggal Kirim',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextFormField(
                readOnly: true,
                controller: TextEditingController(text: dateText),
                onTap: () => _selectDate(context),
                decoration: InputDecoration(
                  hintText: '-- / -- / ----',
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: _resetDate,
                      ),
                      const SizedBox(width: 4),
                      Container(
                          color: Colors.grey.shade300, width: 1, height: 24),
                      IconButton(
                        icon: const Icon(Icons.calendar_month, size: 20),
                        onPressed: () => _selectDate(context),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.all(16.0),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: OutlinedButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          ),
          child: const Text('Reset Filter'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          ),
          child: const Text('Terapkan'),
        ),
      ],
    );
  }
}

// --- BAGIAN 2: LIST DATA BROADCAST ---
class BroadcastListSection extends StatefulWidget {
  const BroadcastListSection({super.key});

  @override
  State<BroadcastListSection> createState() => _BroadcastListSectionState();
}

class _BroadcastListSectionState extends State<BroadcastListSection> {
  final List<Map<String, String>> _allBroadcasts = [
    {
      'no': '1',
      'pengirim': 'Admin Jawara',
      'judul': 'Gotong Royong Perbaikan Fasilitas',
      'pesan':
          'Harap seluruh warga hadir untuk gotong royong perbaikan fasilitas umum di hari Minggu jam 08:00.',
      'tanggal': '14 Oktober 2025',
      'lampiran_gambar': 'gambar_gotong_royong.jpg',
      'lampiran_dokumen': '',
    },
    {
      'no': '2',
      'pengirim': 'Admin Jawara',
      'judul': 'Rapat Bulanan RT',
      'pesan':
          'Rapat bulanan RT akan diadakan malam ini. Dimohon kehadiran Bapak/Ibu.',
      'tanggal': '10 Oktober 2025',
      'lampiran_gambar': '',
      'lampiran_dokumen': 'dokumen_rapat.pdf',
    },
    {
      'no': '3',
      'pengirim': 'Admin Jawara',
      'judul': 'Pengumuman Lomba 17-an',
      'pesan':
          'Pendaftaran lomba 17 Agustus akan dibuka minggu depan. Segera daftar!',
      'tanggal': '05 Oktober 2025',
      'lampiran_gambar': '',
      'lampiran_dokumen': '',
    },
  ];

  final List<bool> _expanded = [];

  void _ensureExpandedLength() {
    if (_expanded.length != _allBroadcasts.length) {
      _expanded.clear();
      _expanded.addAll(List<bool>.filled(_allBroadcasts.length, false));
    }
  }

  void _showDetail(BuildContext context, Map<String, String> data) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BroadcastDetailPage(itemData: data)),
    );
  }

  void _showEdit(BuildContext context, Map<String, String> data) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BroadcastEditForm(initialData: data)),
    );
  }

  @override
  Widget build(BuildContext context) {
    _ensureExpandedLength();

    return ListView.separated(
      itemCount: _allBroadcasts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) {
        final data = _allBroadcasts[i];
        final isExpanded = _expanded[i];

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              InkWell(
                onTap: () => setState(() => _expanded[i] = !_expanded[i]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['judul'] ?? '',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                            const SizedBox(height: 4),
                            Text('Dari: ${data['pengirim']} • ${data['tanggal']}',
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                      Icon(
                          isExpanded
                              ? Icons.expand_less
                              : Icons.expand_more,
                          color: Colors.grey),
                    ],
                  ),
                ),
              ),
              if (isExpanded)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data['pesan'] ?? '-',
                            style: const TextStyle(fontSize: 14)),
                        const SizedBox(height: 12),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton(
                                onPressed: () => _showDetail(context, data),
                                style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    foregroundColor: Colors.deepPurple),
                                child: const Text('Detail',
                                    style: TextStyle(fontSize: 13)),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton(
                                onPressed: () => _showEdit(context, data),
                                style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    foregroundColor: Colors.deepPurple),
                                child: const Text('Edit',
                                    style: TextStyle(fontSize: 13)),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Aksi Hapus Dipicu.'),
                                    backgroundColor: Colors.red,
                                  ));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                ),
                                child: const Text('Hapus',
                                    style: TextStyle(fontSize: 13)),
                              ),
                            ])
                      ]),
                ),
            ],
          ),
        );
      },
    );
  }
}

// --- BAGIAN 3: HALAMAN UTAMA ---
class BroadcastDaftarPage extends StatelessWidget {
  const BroadcastDaftarPage({super.key});

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const BroadcastFilterPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Broadcast'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: BroadcastListSection(),
      ),
      floatingActionButton: FloatingActionButton(
        mini: true, // Tombol lebih kecil
        onPressed: () => _showFilterDialog(context),
        backgroundColor: Colors.deepPurple,
        elevation: 6,
        child: const Icon(Icons.filter_list, size: 22, color: Colors.white),
      ),
    );
  }
}

// --- BAGIAN 4: DETAIL PAGE ---
class BroadcastDetailPage extends StatelessWidget {
  final Map<String, String> itemData;
  const BroadcastDetailPage({super.key, required this.itemData});

  Widget _row(String label, String value, {bool isFile = false}) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(
            value.isEmpty
                ? '-'
                : (isFile ? 'File: $value' : value),
            style: TextStyle(
                color: isFile ? Colors.blue : Colors.black, fontSize: 15),
          ),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Detail Broadcast'),
          backgroundColor: Colors.deepPurple),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _row('Judul', itemData['judul'] ?? ''),
                _row('Isi Pesan', itemData['pesan'] ?? ''),
                _row('Tanggal Publikasi', itemData['tanggal'] ?? ''),
                _row('Dibuat oleh', itemData['pengirim'] ?? ''),
                _row('Lampiran Gambar',
                    itemData['lampiran_gambar'] ?? '',
                    isFile: true),
                _row('Lampiran Dokumen',
                    itemData['lampiran_dokumen'] ?? '',
                    isFile: true),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

// --- BAGIAN 5: EDIT FORM ---
class BroadcastEditForm extends StatefulWidget {
  final Map<String, String> initialData;
  const BroadcastEditForm({super.key, required this.initialData});

  @override
  State<BroadcastEditForm> createState() => _BroadcastEditFormState();
}

class _BroadcastEditFormState extends State<BroadcastEditForm> {
  late TextEditingController _judulController;
  late TextEditingController _pesanController;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.initialData['judul']);
    _pesanController = TextEditingController(text: widget.initialData['pesan']);
  }

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Broadcast berhasil diperbarui!'),
      backgroundColor: Colors.deepPurple,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Edit Broadcast'),
          backgroundColor: Colors.deepPurple),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TextField(
            controller: _judulController,
            decoration:
                const InputDecoration(labelText: 'Judul Broadcast'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _pesanController,
            maxLines: 5,
            decoration:
                const InputDecoration(labelText: 'Isi Broadcast'),
          ),
          const SizedBox(height: 20),
          Row(children: [
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
              ),
              child: const Text('Simpan'),
            ),
            const SizedBox(width: 10),
            OutlinedButton(
              onPressed: () {
                _judulController.clear();
                _pesanController.clear();
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
              ),
              child: const Text('Reset'),
            ),
          ]),
        ]),
      ),
    );
  }
}
