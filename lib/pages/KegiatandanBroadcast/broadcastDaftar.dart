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
              const Text(
                'Judul Broadcast',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Cari judul broadcast...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tanggal Kirim',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextFormField(
                readOnly: true,
                controller: TextEditingController(text: dateText),
                onTap: () => _selectDate(context),
                decoration: InputDecoration(
                  hintText: '-- / -- / ----',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: _resetDate,
                      ),
                      const SizedBox(width: 4),
                      Container(
                        color: Colors.grey.shade300,
                        width: 1,
                        height: 24,
                      ),
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
          child: const Text(
            'Reset Filter',
            style: TextStyle(color: Colors.black54),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Terapkan'),
        ),
      ],
    );
  }
}

// --- BAGIAN 2: LIST DATA BROADCAST (CARD MODEL) ---

class BroadcastListSection extends StatefulWidget {
  const BroadcastListSection({super.key});

  @override
  State<BroadcastListSection> createState() => _BroadcastListSectionState();
}

class _BroadcastListSectionState extends State<BroadcastListSection> {
  // Data Dummy untuk Card
  final List<Map<String, String>> _allBroadcasts = [
    {
      'no': '1',
      'pengirim': 'Admin Jawara',
      'judul': 'Gotong Royong Perbaikan Fasilitas',
      'pesan': 'Harap seluruh warga hadir untuk gotong royong perbaikan fasilitas umum di hari Minggu jam 08:00.',
      'tanggal': '14 Oktober 2025',
      'lampiran_gambar': 'gambar_gotong_royong.jpg',
      'lampiran_dokumen': '',
    },
    {
      'no': '2',
      'pengirim': 'Admin Jawara',
      'judul': 'Rapat Bulanan RT',
      'pesan': 'Rapat bulanan RT akan diadakan malam ini. Dimohon kehadiran Bapak/Ibu.',
      'tanggal': '10 Oktober 2025',
      'lampiran_gambar': '',
      'lampiran_dokumen': 'dokumen_rapat.pdf',
    },
    {
      'no': '3',
      'pengirim': 'Admin Jawara',
      'judul': 'Pengumuman Lomba 17-an',
      'pesan': 'Pendaftaran lomba 17 Agustus akan dibuka minggu depan. Segera daftar!',
      'tanggal': '05 Oktober 2025',
      'lampiran_gambar': '',
      'lampiran_dokumen': '',
    },
  ];

  final List<bool> _expanded = [];

  // Sinkronkan status expand dengan jumlah data
  void _ensureExpandedLength() {
    if (_expanded.length != _allBroadcasts.length) {
      _expanded.clear();
      _expanded.addAll(List<bool>.filled(_allBroadcasts.length, false));
    }
  }

  // Fungsi untuk navigasi ke halaman Detail
  void _showDetail(BuildContext context, Map<String, String> data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BroadcastDetailPage(itemData: data),
      ),
    );
  }

  // Fungsi untuk navigasi ke halaman Edit (BARU)
  void _showEdit(BuildContext context, Map<String, String> data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BroadcastEditForm(initialData: data),
      ),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              // Header Card (Tappable)
              InkWell(
                onTap: () => setState(() => _expanded[i] = !_expanded[i]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    children: [
                      // Judul & Pengirim
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['judul'] ?? '',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Dari: ${data['pengirim']} • ${data['tanggal']}',
                              style: const TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      // Ikon Expand
                      Icon(
                        isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),

              // Konten Detail (Expanded)
              if (isExpanded)
                Column(
                  children: [
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Ringkasan Pesan:', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          // Isi Pesan/Deskripsi Singkat
                          Text(
                            (data['pesan'] ?? '').length > 100 
                              ? (data['pesan'] ?? '').substring(0, 100) + '...' 
                              : data['pesan'] ?? 'Tidak ada ringkasan.',
                          ),
                          const SizedBox(height: 16),

                          // Tombol Aksi
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Tombol Detail
                              OutlinedButton(
                                onPressed: () => _showDetail(context, data),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.deepPurple,
                                ),
                                child: const Text('Detail'),
                              ),
                              const SizedBox(width: 8),
                              // Tombol Edit
                              OutlinedButton(
                                onPressed: () => _showEdit(context, data), // Menggunakan _showEdit
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.deepPurple,
                                ),
                                child: const Text('Edit'),
                              ),
                              const SizedBox(width: 8),
                              // Tombol Hapus (Elevated Button Merah)
                              ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Aksi Hapus Dipicu.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Hapus'),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                )
            ],
          ),
        );
      },
    );
  }
}


// --- BAGIAN 3: HALAMAN UTAMA (BroadcastDaftarPage) ---
class BroadcastDaftarPage extends StatelessWidget {
  const BroadcastDaftarPage({super.key});

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const BroadcastFilterPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            decoration: BoxDecoration(
              // Warna solid Colors.deepPurple
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(Icons.campaign, color: Colors.white, size: 30),
                SizedBox(width: 15),
                Text(
                  'Daftar Broadcast',
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

          // Tombol filter (Container solid dengan Icons.filter_list)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () => _showFilterDialog(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.filter_list,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 15),

          // LIST DATA
          const SizedBox(
            height: 500, // Memberikan tinggi tetap agar ListView dapat di-scroll
            child: BroadcastListSection(),
          ),
        ],
      ),
    );
  }
}

// --- BAGIAN 4: DETAIL PAGE (Tidak ada perubahan) ---
class BroadcastDetailPage extends StatelessWidget {
  final Map<String, String> itemData;
  const BroadcastDetailPage({super.key, required this.itemData});

  Widget _buildDetailRow(String label, String value, {bool isFile = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          if (isFile && value.isEmpty)
            const Text(
              'Tidak ada lampiran.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            )
          else if (isFile && value.isNotEmpty)
            Text(
              'File: $value',
              style: const TextStyle(fontSize: 16, color: Colors.blue),
            )
          else
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tombol Kembali
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
                        'Detail Broadcast',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Judul
                      _buildDetailRow('Judul:', itemData['judul'] ?? '-'),
                      
                      // Isi Pesan
                      _buildDetailRow('Isi Pesan:', itemData['pesan'] ?? '-'),

                      // Tanggal Publikasi
                      _buildDetailRow('Tanggal Publikasi:', itemData['tanggal'] ?? '-'),

                      // Dibuat oleh
                      _buildDetailRow('Dibuat oleh:', itemData['pengirim'] ?? '-'),

                      // Lampiran Gambar
                      _buildDetailRow('Lampiran Gambar:', itemData['lampiran_gambar'] ?? '', isFile: true),
                      
                      // Lampiran Dokumen
                      _buildDetailRow('Lampiran Dokumen:', itemData['lampiran_dokumen'] ?? '', isFile: true),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- BAGIAN 5: EDIT FORM (BARU) ---

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

  @override
  void dispose() {
    _judulController.dispose();
    _pesanController.dispose();
    super.dispose();
  }

  void _onSave() {
    // Simulasi menyimpan data yang telah diubah
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Broadcast "${_judulController.text}" berhasil diperbarui!'),
        backgroundColor: Colors.deepPurple,
      ),
    );
    // Kembali ke halaman daftar
    Navigator.of(context).pop();
  }

  void _onReset() {
    setState(() {
      _judulController.text = widget.initialData['judul'] ?? '';
      _pesanController.text = widget.initialData['pesan'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tombol Kembali
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
                        'Edit Broadcast',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Judul Broadcast
                      _buildTextField(_judulController, 'Judul Broadcast', 'Masukkan judul broadcast'),
                      const SizedBox(height: 16),
                      
                      // Isi Broadcast
                      _buildTextField(_pesanController, 'Isi Broadcast', 'Tulis isi broadcast di sini...', maxLines: 6),
                      const SizedBox(height: 24),

                      // Tombol Aksi (Submit & Reset)
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: _onSave,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Submit'),
                          ),
                          const SizedBox(width: 10),
                          OutlinedButton(
                            onPressed: _onReset,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black54,
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                              side: const BorderSide(color: Colors.grey),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Reset'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.deepPurple, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}