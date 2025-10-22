import 'package:flutter/material.dart';

// --- BAGIAN 1: MODAL FILTER (STATEFUL) ---
class _KegiatanFilterDialog extends StatefulWidget {
  _KegiatanFilterDialog({super.key});

  @override
  State<_KegiatanFilterDialog> createState() => _KegiatanFilterDialogState();
}

class _KegiatanFilterDialogState extends State<_KegiatanFilterDialog> {
  String? selectedKategori;
  DateTime? _selectedDate;

  final List<String> kategoriOptions = [
    'Komunitas & Sosial',
    'Keagamaan',
    'Pendidikan',
    'Lain-lain',
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            // Menggunakan Colors.deepPurple
            primaryColor: Colors.deepPurple,
            colorScheme: const ColorScheme.light(primary: Colors.deepPurple),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
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
            'Filter Kegiatan',
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
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Nama Kegiatan',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Cari kegiatan...',
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
                'Tanggal Pelaksanaan',
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
              const SizedBox(height: 16),

              const Text(
                'Kategori',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedKategori,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  isDense: true,
                ),
                hint: const Text('-- Pilih Kategori --'),
                items: kategoriOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedKategori = newValue;
                  });
                },
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
            // Menggunakan Colors.deepPurple
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

// --- BAGIAN 2: LIST DATA KEGIATAN (CARD MODEL) ---

class KegiatanListSection extends StatefulWidget {
  const KegiatanListSection({super.key});

  @override
  State<KegiatanListSection> createState() => _KegiatanListSectionState();
}

class _KegiatanListSectionState extends State<KegiatanListSection> {
  // Data Dummy Kegiatan
  final List<Map<String, String>> _allKegiatan = [
    {
      'no': '1',
      'nama': 'Gotong Royong Desa',
      'kategori': 'Komunitas & Sosial',
      'pj': 'Pak Budi',
      'tanggal': '12 Oktober 2025',
      'lokasi': 'Balai RT 01',
      'deskripsi': 'Kerja bakti membersihkan lingkungan dan selokan air.',
    },
    {
      'no': '2',
      'nama': 'Bakti Sosial Masjid',
      'kategori': 'Keagamaan',
      'pj': 'Bu Rina',
      'tanggal': '20 Oktober 2025',
      'lokasi': 'Masjid Al-Ikhlas',
      'deskripsi': 'Pembagian sembako untuk keluarga kurang mampu di sekitar masjid.',
    },
    {
      'no': '3',
      'nama': 'Pelatihan Menjahit',
      'kategori': 'Pendidikan',
      'pj': 'Agna Putra',
      'tanggal': '25 Oktober 2025',
      'lokasi': 'Sekretariat RW',
      'deskripsi': 'Pelatihan menjahit untuk pemuda-pemudi.',
    },
  ];

  final List<bool> _expanded = [];

  void _ensureExpandedLength() {
    if (_expanded.length != _allKegiatan.length) {
      _expanded.clear();
      _expanded.addAll(List<bool>.filled(_allKegiatan.length, false));
    }
  }

  void _showDetail(BuildContext context, Map<String, String> data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KegiatanDetailPage(itemData: data),
      ),
    );
  }

  void _showEdit(BuildContext context, Map<String, String> data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KegiatanEditForm(initialData: data),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _ensureExpandedLength();

    return ListView.separated(
      itemCount: _allKegiatan.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) {
        final data = _allKegiatan[i];
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
                      // Judul & PJ
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['nama'] ?? '',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'PJ: ${data['pj']} • ${data['tanggal']}',
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
                          Text('Kategori: ${data['kategori']}', style: const TextStyle(fontWeight: FontWeight.w500)),
                          const SizedBox(height: 8),
                          // Ringkasan Deskripsi
                          Text(data['deskripsi'] ?? 'Tidak ada deskripsi.'),
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
                                onPressed: () => _showEdit(context, data),
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

// --- BAGIAN 3: HALAMAN UTAMA (kegiatanDaftarPage) ---
class kegiatanDaftarPage extends StatelessWidget {
  const kegiatanDaftarPage({super.key});

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _KegiatanFilterDialog();
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
          // Header Halaman
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            decoration: BoxDecoration(
              // Warna solid Colors.deepPurple
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(Icons.list_alt, color: Colors.white, size: 30),
                SizedBox(width: 15),
                Text(
                  'Daftar Kegiatan',
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
                    Icons.filter_list, // Ikon filter yang diminta
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 15),

          // LIST DATA KEGIATAN
          const SizedBox(
            height: 500, // Memberikan tinggi tetap agar ListView dapat di-scroll
            child: KegiatanListSection(),
          ),
        ],
      ),
    );
  }
}

// --- BAGIAN 4: DETAIL PAGE (BARU - Mirip BroadcastDetailPage) ---

class KegiatanDetailPage extends StatelessWidget {
  final Map<String, String> itemData;
  const KegiatanDetailPage({super.key, required this.itemData});

  Widget _buildDetailRow(String label, String value) {
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
                        'Detail Kegiatan',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Detail Kegiatan
                      _buildDetailRow('Nama Kegiatan:', itemData['nama'] ?? '-'),
                      _buildDetailRow('Kategori:', itemData['kategori'] ?? '-'),
                      _buildDetailRow('Penanggung Jawab:', itemData['pj'] ?? '-'),
                      _buildDetailRow('Tanggal Pelaksanaan:', itemData['tanggal'] ?? '-'),
                      _buildDetailRow('Lokasi:', itemData['lokasi'] ?? '-'),
                      _buildDetailRow('Deskripsi:', itemData['deskripsi'] ?? '-'),
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

// --- BAGIAN 5: EDIT FORM (BARU - Mirip BroadcastEditForm) ---

class KegiatanEditForm extends StatefulWidget {
  final Map<String, String> initialData;
  const KegiatanEditForm({super.key, required this.initialData});

  @override
  State<KegiatanEditForm> createState() => _KegiatanEditFormState();
}

class _KegiatanEditFormState extends State<KegiatanEditForm> {
  late TextEditingController _namaController;
  late TextEditingController _deskripsiController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.initialData['nama']);
    _deskripsiController = TextEditingController(text: widget.initialData['deskripsi']);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  void _onSave() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kegiatan "${_namaController.text}" berhasil diperbarui!'),
        backgroundColor: Colors.deepPurple,
      ),
    );
    Navigator.of(context).pop();
  }

  void _onReset() {
    setState(() {
      _namaController.text = widget.initialData['nama'] ?? '';
      _deskripsiController.text = widget.initialData['deskripsi'] ?? '';
      // Tambahkan logika reset untuk field lain jika ada (kategori, tgl, dll)
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
                        'Edit Kegiatan',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Nama Kegiatan
                      _buildTextField(_namaController, 'Nama Kegiatan', 'Masukkan nama kegiatan'),
                      const SizedBox(height: 16),
                      
                      // Deskripsi Kegiatan
                      _buildTextField(_deskripsiController, 'Deskripsi Kegiatan', 'Tulis deskripsi kegiatan di sini...', maxLines: 6),
                      // Catatan: Field lain (Kategori, Tgl, PJ) dihilangkan untuk kesederhanaan, namun harus ditambahkan untuk fungsionalitas penuh.
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