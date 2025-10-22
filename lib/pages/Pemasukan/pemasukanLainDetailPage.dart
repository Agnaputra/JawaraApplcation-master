import 'package:flutter/material.dart';

class pemasukanLainDetailPage extends StatelessWidget {
  final Map<String, dynamic> itemData;

  const pemasukanLainDetailPage({Key? key, required this.itemData}) : super(key: key);

  String _formatTanggal(DateTime tanggal) {
    final List<String> namaBulan = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${tanggal.day} ${namaBulan[tanggal.month - 1]} ${tanggal.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tombol "Kembali"
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
                          'Detail Pemasukan Lain',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),

                        _buildDetailRow(
                          'Nama Pemasukan',
                          itemData['nama'],
                        ),
                        _buildDetailRow(
                          'Kategori',
                          itemData['jenis'],
                        ),
                        _buildDetailRow(
                          'Tanggal Transaksi',
                          _formatTanggal(itemData['tanggal']),
                        ),
                        _buildDetailRow(
                          'Jumlah',
                          itemData['nominal'],
                          isAmount: true, 
                        ),
                        _buildDetailRow(
                          'Tanggal Terverifikasi',
                          '--', 
                        ),
                        _buildDetailRow(
                          'Verifikator',
                          'Admin Jawara', 
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isAmount = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isAmount ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}