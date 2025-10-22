import 'package:flutter/material.dart';
import 'package:jawaraapllication/pages/Pemasukan/tagihanDetailPage.dart.'; 

class tagihanPage extends StatefulWidget {
  const tagihanPage({super.key});

  @override
  State<tagihanPage> createState() => _tagihanPageState();
}

class _tagihanPageState extends State<tagihanPage> {
  final List<Map<String, dynamic>> _data = [
    {
      "no": 1,
      "namaKeluarga": "Keluarga Habibie Ed Dien",
      "statusKeluarga": "Aktif",
      "iuran": "Mingguan",
      "kodeTagihan": "IR175458A501",
      "nominal": 10.00,
      "periode": DateTime(2025, 10, 8),
      "status": "Belum Dibayar",
    },
    {
      "no": 2,
      "namaKeluarga": "Keluarga Habibie Ed Dien",
      "statusKeluarga": "Aktif",
      "iuran": "Mingguan",
      "kodeTagihan": "IR185702KX01",
      "nominal": 10.00,
      "periode": DateTime(2025, 10, 15),
      "status": "Belum Dibayar",
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 2.0,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildActionBar(),
                  const SizedBox(height: 16),
                  _buildDataTable(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () {
            _showFilterDialog(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.all(12),
          ),
          child: const Icon(Icons.filter_list),
        ),
        const SizedBox(width: 16),
        OutlinedButton(
          onPressed: () {
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text('Cetak PDF'),
        ),
      ],
    );
  }

  Widget _buildDataTable() {
    return LayoutBuilder(
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
                DataColumn(label: Text('NAMA KELUARGA')),
                DataColumn(label: Text('STATUS KELUARGA')),
                DataColumn(label: Text('IURAN')),
                DataColumn(label: Text('KODE TAGIHAN')),
                DataColumn(label: Text('NOMINAL')),
                DataColumn(label: Text('PERIODE')),
                DataColumn(label: Text('STATUS')),
                DataColumn(label: Text('AKSI')),
              ],
              rows: _data.map((item) {
                return DataRow(
                  cells: [
                    DataCell(Text(item['no'].toString())),
                    DataCell(Text(item['namaKeluarga'])),
                    DataCell(_buildStatusChip(item['statusKeluarga'])),
                    DataCell(Text(item['iuran'])),
                    DataCell(Text(item['kodeTagihan'])),
                    DataCell(Text(
                        'Rp ${item['nominal'].toStringAsFixed(2).replaceAll('.', ',')}')),
                    DataCell(Text(_formatTanggal(item['periode']))),
                    DataCell(_buildStatusChip(item['status'])),
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
                                builder: (context) => tagihanDetailPage(itemData: item),
                              ),
                            );
                          } else if (value == 'edit') {
                          } else if (value == 'hapus') {
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'detail',
                            child: Text('Detail'),
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
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    Color textColor;
    String text = status;
    switch (status.toLowerCase()) {
      case 'aktif':
        chipColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;
      case 'belum dibayar':
        chipColor = Colors.amber.shade100;
        textColor = Colors.amber.shade800;
        break;
      default:
        chipColor = Colors.grey.shade200;
        textColor = Colors.grey.shade800;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
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
}

class _FilterDialog extends StatefulWidget {
  const _FilterDialog({Key? key}) : super(key: key);

  @override
  State<_FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<_FilterDialog> {

  String? _selectedStatusPembayaran;
  String? _selectedStatusKeluarga;
  String? _selectedKeluarga;
  String? _selectedIuran;
  final _periodeController = TextEditingController();

  final List<String> _statusPembayaranList = [
    'Belum Dibayar', 'Menunggu Bukti', 'Menunggu Verifikasi', 'Diterima', 'Ditolak'
  ];
  final List<String> _statusKeluargaList = ['Aktif', 'Nonaktif'];
  final List<String> _keluargaList = [
    'Keluarga Habibie Ed Dien', 'Keluarga Mara Nunez', 'Keluarga Raudhil Firdaus Naufal', 'Keluarga varizky naldiba rimra', 'Keluarga Anti Micin'
  ];
  final List<String> _iuranList = [
    'Agustusan', 'Mingguan', 'Bersih Desa', 'Kerja Bakti', 'Harian'
  ];

  @override
  void dispose() {
    _periodeController.dispose();
    super.dispose();
  }

  void _resetFilter() {
    setState(() {
      _selectedStatusPembayaran = null;
      _selectedStatusKeluarga = null;
      _selectedKeluarga = null;
      _selectedIuran = null;
      _periodeController.clear();
    });
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      String formattedDate =
          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      setState(() {
        controller.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      titlePadding: const EdgeInsets.fromLTRB(24, 16, 12, 0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Filter Tagihan Warga',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
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
              _buildDropdownField(
                label: 'Status Pembayaran',
                hint: '-- Pilih Status --',
                value: _selectedStatusPembayaran,
                items: _statusPembayaranList,
                onChanged: (newValue) {
                  setState(() => _selectedStatusPembayaran = newValue);
                },
              ),
              const SizedBox(height: 16),
              _buildDropdownField(
                label: 'Status Keluarga',
                hint: '-- Pilih Status Keluarga --',
                value: _selectedStatusKeluarga,
                items: _statusKeluargaList,
                onChanged: (newValue) {
                  setState(() => _selectedStatusKeluarga = newValue);
                },
              ),
              const SizedBox(height: 16),
              _buildDropdownField(
                label: 'Keluarga',
                hint: '-- Pilih Keluarga --',
                value: _selectedKeluarga,
                items: _keluargaList,
                onChanged: (newValue) {
                  setState(() => _selectedKeluarga = newValue);
                },
              ),
              const SizedBox(height: 16),
              _buildDropdownField(
                label: 'Iuran',
                hint: '-- Pilih Iuran --',
                value: _selectedIuran,
                items: _iuranList,
                onChanged: (newValue) {
                  setState(() => _selectedIuran = newValue);
                },
              ),
              const SizedBox(height: 16),
              _buildDateField(
                context: context,
                controller: _periodeController,
                label: 'Periode (Bulan & Tahun)',
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      actions: [
        TextButton(
          onPressed: _resetFilter,
          child: const Text('Reset Filter'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text('Terapkan'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          hint: Text(hint),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          ),
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            hintText: '-- / -- / ----',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today_outlined),
              onPressed: () => _selectDate(context, controller),
            ),
          ),
          onTap: () => _selectDate(context, controller),
        ),
      ],
    );
  }
}