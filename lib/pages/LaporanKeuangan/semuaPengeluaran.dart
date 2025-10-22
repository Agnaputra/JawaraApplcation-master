import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class semuaPengeluaranPage extends StatelessWidget {
  const semuaPengeluaranPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data untuk contoh
    final pengeluaranList = [
      {
        'no': 1,
        'nama': 'Arka',
        'jenis': 'Operasional RT/RW',
        'tanggal': DateTime(2025, 10, 17, 2, 31),
        'nominal': 6.00,
      },
      {
        'no': 2,
        'nama': 'adsad',
        'jenis': 'Pemeliharaan Fasilitas',
        'tanggal': DateTime(2025, 10, 10, 1, 8),
        'nominal': 2112.00,
      },
    ];

    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 2,
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Tombol filter
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.filter_list),
                    label: const Text('Filter'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 800,
                    child: Column(
                      children: [
                        // Header
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: const [
                              SizedBox(
                                width: 40,
                                child: Text(
                                  'NO',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                width: 150,
                                child: Text(
                                  'NAMA',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                width: 200,
                                child: Text(
                                  'JENIS PENGELUARAN',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                width: 150,
                                child: Text(
                                  'TANGGAL',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                width: 120,
                                child: Text(
                                  'NOMINAL',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                width: 60,
                                child: Text(
                                  'AKSI',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),

                        // List data
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: pengeluaranList.length,
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) {
                            final item = pengeluaranList[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 4.0,
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 40,
                                    child: Text(item['no'].toString()),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: Text(item['nama'].toString()),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: Text(item['jenis'].toString()),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      DateFormat(
                                        'dd MMM yyyy HH:mm',
                                        'id_ID',
                                      ).format(item['tanggal'] as DateTime),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 120,
                                    child: Text(
                                      currencyFormatter.format(item['nominal']),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 60,
                                    child: PopupMenuButton<String>(
                                      onSelected: (value) {},
                                      itemBuilder: (context) => const [
                                        PopupMenuItem(
                                          value: 'detail',
                                          child: Text('Detail'),
                                        ),
                                        PopupMenuItem(
                                          value: 'edit',
                                          child: Text('Edit'),
                                        ),
                                        PopupMenuItem(
                                          value: 'hapus',
                                          child: Text('Hapus'),
                                        ),
                                      ],
                                      child: const Icon(Icons.more_vert),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Pagination
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '1',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
