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
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Reset'),
        ),
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
                            Text(data['nama'] ?? '',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text('PJ: ${data['pj']} • ${data['tanggal']}',
                                style: const TextStyle(color: Colors.grey, fontSize: 13)),
                          ],
                        ),
                      ),
                      Icon(
                        isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
              if (isExpanded)
                Column(
                  children: [
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Kategori: ${data['kategori']}',
                              style: const TextStyle(fontWeight: FontWeight.w500)),
                          const SizedBox(height: 8),
                          Text(data['deskripsi'] ?? 'Tidak ada deskripsi.'),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 30,
                                child: OutlinedButton(
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    foregroundColor: Colors.deepPurple,
                                  ),
                                  child: const Text('Detail', style: TextStyle(fontSize: 12)),
                                ),
                              ),
                              const SizedBox(width: 6),
                              SizedBox(
                                height: 30,
                                child: OutlinedButton(
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    foregroundColor: Colors.deepPurple,
                                  ),
                                  child: const Text('Edit', style: TextStyle(fontSize: 12)),
                                ),
                              ),
                              const SizedBox(width: 6),
                              SizedBox(
                                height: 30,
                                child: ElevatedButton(
                                  onPressed: () {},
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
