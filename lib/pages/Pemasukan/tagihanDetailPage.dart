import 'package:flutter/material.dart';

class tagihanDetailPage extends StatefulWidget {
  final Map<String, dynamic> itemData;

  const tagihanDetailPage({Key? key, required this.itemData}) : super(key: key);

  @override
  State<tagihanDetailPage> createState() => _tagihanDetailPageState();
}

class _tagihanDetailPageState extends State<tagihanDetailPage> {
  int _selectedTabIndex = 0;

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
                          'Riwayat Pembayaran',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        _buildTabButtons(),
                        const SizedBox(height: 24),

                        IndexedStack(
                          index: _selectedTabIndex,
                          children: [
                            _buildDetailTab(), 
                            _buildRiwayatTab(), 
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
      ),
    );
  }

  Widget _buildTabButtons() {
    return Row(
      children: [

        ElevatedButton(
          onPressed: () => setState(() => _selectedTabIndex = 0),
          style: ElevatedButton.styleFrom(
            backgroundColor: _selectedTabIndex == 0 ? Colors.indigo : Colors.grey.shade100,
            foregroundColor: _selectedTabIndex == 0 ? Colors.white : Colors.black54,
            elevation: _selectedTabIndex == 0 ? 2 : 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text('Detail'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => setState(() => _selectedTabIndex = 1),
          style: ElevatedButton.styleFrom(
            backgroundColor: _selectedTabIndex == 1 ? Colors.indigo : Colors.grey.shade100,
            foregroundColor: _selectedTabIndex == 1 ? Colors.white : Colors.black54,
            elevation: _selectedTabIndex == 1 ? 2 : 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text('Riwayat Pembayaran'),
        ),
      ],
    );
  }

  Widget _buildDetailTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Verifikasi Pembayaran Iuran',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        _buildDetailRow('Kode Iuran', widget.itemData['kodeTagihan']),
        _buildDetailRow('Nama Iuran', widget.itemData['iuran']),
        _buildDetailRow('Kategori', 'Iuran Khusus'), 
        _buildDetailRow('Periode', _formatTanggal(widget.itemData['periode'])),
        _buildDetailRow('Nominal', 'Rp ${widget.itemData['nominal'].toStringAsFixed(2).replaceAll('.', ',')}'),
        _buildDetailRow('Status', widget.itemData['status']),
        _buildDetailRow('Nama KK', widget.itemData['namaKeluarga']),
        _buildDetailRow('Alamat', 'Blok A/9'), 
        _buildDetailRow('Metode Pembayaran', 'Belum tersedia'), 
        _buildDetailRow('Bukti', 'Belum ada bukti'), 
        
        const SizedBox(height: 24),
        // Form Alasan Penolakan
        const Text(
          'Tulis alasan penolakan...',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextFormField(
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Masukkan alasan jika Anda menolak pembayaran ini...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding: const EdgeInsets.all(12.0),
          ),
        ),
        const SizedBox(height: 24),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
              child: const Text('Setujui'),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
              child: const Text('Tolak'),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildRiwayatTab() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48.0),
      child: const Center(
        child: Text(
          'Belum ada riwayat pembayaran.',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ),
    );
  }

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
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}