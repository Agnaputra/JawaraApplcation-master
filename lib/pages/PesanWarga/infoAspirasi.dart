import 'package:flutter/material.dart';
import 'package:jawaraapllication/pages/PesanWarga/infoAspirasiDetailPage.dart.'; 
import 'package:jawaraapllication/pages/PesanWarga/infoAspirasiEditPage.dart.';

class infoAspirasiPage extends StatefulWidget {
  const infoAspirasiPage({super.key});

  @override
  State<infoAspirasiPage> createState() => _infoAspirasiPageState();
}

class _infoAspirasiPageState extends State<infoAspirasiPage> {
  final List<Map<String, dynamic>> _data = [
    {
      "no": 1,
      "pengirim": 'Habibie Ed Dien',
      "judul": 'tes',
      "deskripsi": 'Ini adalah deskripsi untuk item tes.',
      "status": 'Diterima',
      "tanggalDibuat": DateTime(2025, 9, 28),
    },
    {
      "no": 2,
      "pengirim": 'Budi Santoso',
      "judul": 'Laporan Bulanan',
      "deskripsi": 'Deskripsi untuk laporan bulanan.',
      "status": 'Ditolak',
      "tanggalDibuat": DateTime(2025, 9, 27),
    },
    {
      "no": 3,
      "pengirim": 'Citra Lestari',
      "judul": 'Proposal Proyek',
      "deskripsi": 'Ini adalah proposal proyek A.',
      "status": 'Diproses',
      "tanggalDibuat": DateTime(2025, 9, 26),
    },
  ];

  final List<String> namaBulan = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  String _formatTanggal(DateTime tanggal) {
    return '${tanggal.day} ${namaBulan[tanggal.month - 1]} ${tanggal.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 2.0,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          _showFilterDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(12),
                          backgroundColor: Colors.indigo,
                        ),
                        child: const Icon(Icons.filter_list, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minWidth: constraints.maxWidth),
                            child: DataTable(
                              columnSpacing: 24.0,
                              headingTextStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                              columns: const [
                                DataColumn(label: Text('NO')),
                                DataColumn(label: Text('PENGIRIM')),
                                DataColumn(label: Text('JUDUL')),
                                DataColumn(label: Text('STATUS')),
                                DataColumn(label: Text('TANGGAL DIBUAT')),
                                DataColumn(label: Text('AKSI')),
                              ],
                              rows: _data.map((item) {
                                DateTime tanggal = item['tanggalDibuat'];
                                return DataRow(
                                  cells: [
                                    DataCell(Text(item['no'].toString())),
                                    DataCell(Text(item['pengirim'])),
                                    DataCell(Text(item['judul'])),
                                    DataCell(_buildStatusChip(item['status'])),
                                    DataCell(Text(_formatTanggal(tanggal))),
                                
                                    DataCell(
                                      PopupMenuButton<String>(
                                        icon: const Icon(Icons.more_horiz),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        onSelected: (String value) {
                                          if (value == 'detail') {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => infoAspirasiDetailPage(itemData: item),
                                              ),
                                            );
                                          } else if (value == 'edit') {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => infoAspirasiEditPage(itemData: item),
                                              ),
                                            );
                                          } else if (value == 'hapus') {
                                            _showDeleteConfirmDialog(context, item);
                                          }
                                        },
                                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                          const PopupMenuItem<String>(
                                            value: 'detail',
                                            child: Text('Detail'),
                                          ),
                                          const PopupMenuItem<String>(
                                            value: 'edit',
                                            child: Text('Edit'),
                                          ),
                                          const PopupMenuItem<String>(
                                            value: 'hapus',
                                            child: Text('Hapus'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildPagination(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    Color textColor;
    switch (status.toLowerCase()) {
      case 'diterima': chipColor = Colors.green.shade100; textColor = Colors.green.shade800; break;
      case 'ditolak': chipColor = Colors.red.shade100; textColor = Colors.red.shade800; break;
      case 'diproses': chipColor = Colors.orange.shade100; textColor = Colors.orange.shade800; break;
      default: chipColor = Colors.grey.shade200; textColor = Colors.grey.shade800;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: chipColor, borderRadius: BorderRadius.circular(20)),
      child: Text(status, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(icon: const Icon(Icons.chevron_left), onPressed: () {}),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
          ),
          child: const Text('1'),
        ),
        const SizedBox(width: 8),
        IconButton(icon: const Icon(Icons.chevron_right), onPressed: () {}),
      ],
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return const _FilterDialog();
      },
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, Map<String, dynamic> itemData) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          title: const Text('Hapus Data'),
          content: Text('Apakah Anda yakin ingin menghapus data "${itemData['judul']}"?'),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Hapus'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class _FilterDialog extends StatefulWidget {
  const _FilterDialog({Key? key}) : super(key: key);
  @override
  State<_FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<_FilterDialog> {
  final _judulController = TextEditingController();
  String? _selectedStatus;
  final List<String> _statusList = ['Diterima', 'Diproses', 'Ditolak'];
  @override
  void dispose() {
    _judulController.dispose();
    super.dispose();
  }
  void _resetFilter() {
    setState(() {
      _judulController.clear();
      _selectedStatus = null;
    });
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      titlePadding: const EdgeInsets.fromLTRB(24, 16, 12, 0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Filter Pesan Warga', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
            splashRadius: 20,
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFormTextField(
                controller: _judulController,
                label: 'Judul',
                hint: 'Cari judul...',
              ),
              const SizedBox(height: 16),
              const Text('Status', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                hint: const Text('-- Pilih Status --'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                ),
                onChanged: (String? newValue) {
                  setState(() { _selectedStatus = newValue; });
                },
                items: _statusList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value));
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      actions: [
        TextButton(onPressed: _resetFilter, child: const Text('Reset Filter')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          ),
          child: const Text('Terapkan'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
  Widget _buildFormTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          ),
        ),
      ],
    );
  }
}