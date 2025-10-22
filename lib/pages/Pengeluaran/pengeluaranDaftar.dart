import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class pengeluaranDaftarPage extends StatefulWidget {
  const pengeluaranDaftarPage({super.key});

  @override
  State<pengeluaranDaftarPage> createState() => _pengeluaranDaftarPageState();
}

class _pengeluaranDaftarPageState extends State<pengeluaranDaftarPage> {
  String? selectedKategori;
  final TextEditingController namaController = TextEditingController();
  DateTime? dariTanggal;
  DateTime? sampaiTanggal;

  final List<Map<String, dynamic>> dataPengeluaran = [
    {
      'no': 1,
      'nama': 'Arka',
      'jenis': 'Operasional RT/RW',
      'tanggal': '17 Oktober 2025',
      'nominal': 'Rp 6,00',
    },
    {
      'no': 2,
      'nama': 'adsad',
      'jenis': 'Pemeliharaan Fasilitas',
      'tanggal': '02 Oktober 2025',
      'nominal': 'Rp 2.112,00',
    },
  ];

  final List<String> kategoriList = [
    'Operasional RT/RW',
    'Kegiatan Sosial',
    'Pemeliharaan Fasilitas',
    'Pembangunan',
    'Kegiatan Warga',
    'Lain-lain',
  ];

  Future<void> _pilihTanggal(BuildContext context, bool isDariTanggal) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isDariTanggal) {
          dariTanggal = picked;
        } else {
          sampaiTanggal = picked;
        }
      });
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter Pengeluaran',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  const Text('Nama'),
                  const SizedBox(height: 4),
                  TextField(
                    controller: namaController,
                    decoration: InputDecoration(
                      hintText: 'Cari nama...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Text('Kategori'),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    value: selectedKategori,
                    hint: const Text('-- Pilih Kategori --'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: kategoriList.map((kategori) {
                      return DropdownMenuItem(
                        value: kategori,
                        child: Text(kategori),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedKategori = value;
                      });
                    },
                  ),

                  const SizedBox(height: 16),
                  const Text('Dari Tanggal'),
                  const SizedBox(height: 4),
                  TextField(
                    readOnly: true,
                    onTap: () => _pilihTanggal(context, true),
                    decoration: InputDecoration(
                      hintText: dariTanggal == null
                          ? '--/--/----'
                          : DateFormat('d MMMM yyyy', 'id_ID').format(dariTanggal!),
                      suffixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Text('Sampai Tanggal'),
                  const SizedBox(height: 4),
                  TextField(
                    readOnly: true,
                    onTap: () => _pilihTanggal(context, false),
                    decoration: InputDecoration(
                      hintText: sampaiTanggal == null
                          ? '--/--/----'
                          : DateFormat('d MMMM yyyy', 'id_ID').format(dariTanggal!),
                      suffixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                      onPressed: () {
                          setState(() {
                            namaController.clear();
                            selectedKategori = null;
                            dariTanggal = null;
                            sampaiTanggal = null;
                          });
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        side: const BorderSide(color: Color(0xFFE0E0E0)),
                        backgroundColor: const Color(0xFFF7F8FB),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Reset Filter'),
                    ),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF635BFF), 
                          foregroundColor: Colors.white,            
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          textStyle: const TextStyle(fontWeight: FontWeight.w600),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: _showFilterDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(14),
                      ),
                      child: const Icon(Icons.filter_list, color: Colors.white),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                color: Colors.grey[100],
                child: Row(
                  children: const [
                    Expanded(flex: 1, child: Text('NO', style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(flex: 2, child: Text('NAMA', style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(flex: 3, child: Text('JENIS PENGELUARAN', style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(flex: 3, child: Text('TANGGAL', style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(flex: 2, child: Text('NOMINAL', style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(flex: 1, child: Text('AKSI', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
              ),

              const Divider(height: 1),

              Expanded(
                child: ListView.builder(
                  itemCount: dataPengeluaran.length,
                  itemBuilder: (context, index) {
                    final item = dataPengeluaran[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(flex: 1, child: Text(item['no'].toString())),
                          Expanded(flex: 2, child: Text(item['nama'])),
                          Expanded(flex: 3, child: Text(item['jenis'])),
                          Expanded(flex: 3, child: Text(item['tanggal'])),
                          Expanded(flex: 2, child: Text(item['nominal'])),
                          const Expanded(flex: 1, child: Icon(Icons.more_horiz)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}