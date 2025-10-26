import 'package:flutter/material.dart';

// --- BAGIAN 1: MODAL FILTER (STATEFUL) ---
class _KegiatanFilterDialog extends StatefulWidget {
  const _KegiatanFilterDialog({super.key});

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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Filter Kegiatan', style: TextStyle(fontWeight: FontWeight.bold)),
          IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nama Kegiatan', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Cari kegiatan...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Tanggal Pelaksanaan', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextFormField(
              readOnly: true,
              controller: TextEditingController(text: dateText),
              onTap: () => _selectDate(context),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_month),
                  onPressed: () => _selectDate(context),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Kategori', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedKategori,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              hint: const Text('-- Pilih Kategori --'),
              items: kategoriOptions.map((e) {
                return DropdownMenuItem(value: e, child: Text(e));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedKategori = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Reset')),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
          child: const Text('Terapkan'),
        )
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
  final List<Map<String, String>> _allKegiatan = [
    {
      'nama': 'Gotong Royong Desa',
      'kategori': 'Komunitas & Sosial',
      'pj': 'Pak Budi',
      'tanggal': '12 Oktober 2025',
      'lokasi': 'Balai RT 01',
      'deskripsi': 'Kerja bakti membersihkan lingkungan dan selokan air.',
    },
    {
      'nama': 'Bakti Sosial Masjid',
      'kategori': 'Keagamaan',
      'pj': 'Bu Rina',
      'tanggal': '20 Oktober 2025',
      'lokasi': 'Masjid Al-Ikhlas',
      'deskripsi': 'Pembagian sembako untuk warga sekitar masjid.',
    },
    {
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
    Navigator.push(context, MaterialPageRoute(builder: (_) => KegiatanDetailPage(itemData: data)));
  }

  void _showEdit(BuildContext context, Map<String, String> data) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => KegiatanEditForm(initialData: data)));
  }

  @override
  Widget build(BuildContext context) {
    _ensureExpandedLength();

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _allKegiatan.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) {
        final data = _allKegiatan[i];
        final isExpanded = _expanded[i];

        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              // Header Card (Tappable)
              InkWell(
                onTap: () => setState(() => _expanded[i] = !_expanded[i]),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['nama'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text('PJ: ${data['pj']} • ${data['tanggal']}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                          ],
                        ),
                      ),
                      Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.grey),
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
                          Text(data['deskripsi'] ?? 'Tidak ada deskripsi.'),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Tombol Detail (Kompak)
                              SizedBox(
                                height: 30,
                                child: OutlinedButton(
                                  onPressed: () => _showDetail(context, data),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    foregroundColor: Colors.deepPurple,
                                  ),
                                  child: const Text('Detail', style: TextStyle(fontSize: 12)),
                                ),
                              ),
                              const SizedBox(width: 6),
                              // Tombol Edit (Kompak)
                              SizedBox(
                                height: 30,
                                child: OutlinedButton(
                                  onPressed: () => _showEdit(context, data),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    foregroundColor: Colors.deepPurple,
                                  ),
                                  child: const Text('Edit', style: TextStyle(fontSize: 12)),
                                ),
                              ),
                              const SizedBox(width: 6),
                              // Tombol Hapus (Kompak)
                              SizedBox(
                                height: 30,
                                child: ElevatedButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: Text('Aksi Hapus Dipicu.'),
                                      backgroundColor: Colors.red,
                                    ));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                  ),
                                  child: const Text('Hapus', style: TextStyle(fontSize: 12)),
                                ),
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

// --- BAGIAN 3: HALAMAN UTAMA ---
class KegiatanDaftarPage extends StatelessWidget {
  const KegiatanDaftarPage({super.key});

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const _KegiatanFilterDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Kegiatan'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: KegiatanListSection(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        mini: true,
        onPressed: () => _showFilterDialog(context),
        child: const Icon(Icons.filter_list, color: Colors.white),
      ),
    );
  }
}

// --- BAGIAN 4: DETAIL PAGE (Diperlukan untuk navigasi) ---
class KegiatanDetailPage extends StatelessWidget {
  final Map<String, String> itemData;
  const KegiatanDetailPage({super.key, required this.itemData});

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 15)),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Kegiatan'), backgroundColor: Colors.deepPurple),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _row('Nama Kegiatan', itemData['nama'] ?? '-'),
                _row('Kategori', itemData['kategori'] ?? '-'),
                _row('Penanggung Jawab', itemData['pj'] ?? '-'),
                _row('Tanggal Pelaksanaan', itemData['tanggal'] ?? '-'),
                _row('Lokasi', itemData['lokasi'] ?? '-'),
                _row('Deskripsi', itemData['deskripsi'] ?? '-'),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

// --- BAGIAN 5: EDIT FORM (SUDAH DIPERBAIKI) ---
class KegiatanEditForm extends StatefulWidget {
  final Map<String, String> initialData;
  const KegiatanEditForm({super.key, required this.initialData});

  @override
  State<KegiatanEditForm> createState() => _KegiatanEditFormState();
}

class _KegiatanEditFormState extends State<KegiatanEditForm> {
  late TextEditingController _namaController;
  late TextEditingController _deskripsiController;
  // Note: Untuk form lengkap, Anda harus menambahkan controller/state untuk PJ, Kategori, Tanggal, dll.

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data awal
    _namaController = TextEditingController(text: widget.initialData['nama'] ?? '');
    _deskripsiController = TextEditingController(text: widget.initialData['deskripsi'] ?? '');
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  void _onSave() {
    // Simulasi menyimpan data yang telah diubah
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kegiatan "${_namaController.text}" berhasil diubah!'),
        backgroundColor: Colors.deepPurple,
      ),
    );
    Navigator.pop(context); 
  }

  void _onReset() {
    // Mengembalikan ke data awal
    setState(() {
      _namaController.text = widget.initialData['nama'] ?? '';
      _deskripsiController.text = widget.initialData['deskripsi'] ?? '';
    });
  }
  
  Widget _buildTextField(TextEditingController controller, String label, String hint, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF454545))),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF0F0F5),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.deepPurple, width: 1.5)),
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit ${widget.initialData['nama'] ?? 'Kegiatan'}'), backgroundColor: Colors.deepPurple),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Formulir Edit Kegiatan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),

                // Nama Kegiatan
                _buildTextField(_namaController, 'Nama Kegiatan', 'Masukkan nama kegiatan'),
                const SizedBox(height: 5),

                // Deskripsi
                _buildTextField(_deskripsiController, 'Deskripsi', 'Tulis deskripsi event...', maxLines: 5),
                const SizedBox(height: 10),

                // Tombol Aksi
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _onSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                      ),
                      child: const Text('Simpan'),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: _onReset,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black54,
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
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
    );
  }
}