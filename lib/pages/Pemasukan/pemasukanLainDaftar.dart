import 'package:flutter/material.dart';
import 'package:jawaraapllication/pages/Pemasukan/pemasukanLainDetailPage.dart.';
class pemasukanLainPage extends StatefulWidget {
  const pemasukanLainPage({super.key});

  @override
  State<pemasukanLainPage> createState() => _pemasukanLainPageState();
}

class _pemasukanLainPageState extends State<pemasukanLainPage> {
  final List<Map<String, dynamic>> _data = [
    {
      "no": 1,
      "nama": "aaaaa",
      "jenis": "Dana Bantuan Pemerintah",
      "tanggal": DateTime(2025, 10, 15),
      "nominal": "Rp 11,00"
    },
    {
      "no": 2,
      "nama": "Joki by firman",
      "jenis": "Pendapatan Lainnya",
      "tanggal": DateTime(2025, 10, 13),
      "nominal": "Rp 49.999.997,00"
    },
    {
      "no": 3,
      "nama": "tes",
      "jenis": "Pendapatan Lainnya",
      "tanggal": DateTime(2025, 8, 12),
      "nominal": "Rp 10.000,00"
    },
  ];

  final List<String> namaBulan = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
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
                      _buildActionBar(),
                      const SizedBox(height: 16),
                      _buildDataTable(),
                      const SizedBox(height: 24),
                      _buildPagination(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionBar() {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
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
                DataColumn(label: Text('NAMA')),
                DataColumn(label: Text('JENIS PEMASUKAN')),
                DataColumn(label: Text('TANGGAL')),
                DataColumn(label: Text('NOMINAL')),
                DataColumn(label: Text('AKSI')),
              ],
              rows: _data.map((item) {
                DateTime tanggal = item['tanggal'];
                String tanggalFormatted =
                    '${tanggal.day} ${namaBulan[tanggal.month - 1]} ${tanggal.year}';
                return DataRow(
                  cells: [
                    DataCell(Text(item['no'].toString())),
                    DataCell(Text(item['nama'])),
                    DataCell(Text(item['jenis'])),
                    DataCell(Text(tanggalFormatted)),
                    DataCell(Text(item['nominal'])),
                    DataCell(
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_horiz),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onSelected: (String value) {
                          if (value == 'detail') {
                            // Navigasi ke halaman detail
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => pemasukanLainDetailPage(
                                  itemData: item, 
                                ),
                              ),
                            );
                          } else if (value == 'edit') {
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

  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {},
        ),
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
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {},
        ),
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
}

class _FilterDialog extends StatefulWidget {
  const _FilterDialog({Key? key}) : super(key: key);

  @override
  State<_FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<_FilterDialog> {
  final _namaController = TextEditingController();
  String? _selectedKategori;
  final _dariTanggalController = TextEditingController();
  final _sampaiTanggalController = TextEditingController();
  final List<String> _kategoriList = [
    'Dana Bantuan Pemerintah',
    'Pendapatan Lainnya'
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _dariTanggalController.dispose();
    _sampaiTanggalController.dispose();
    super.dispose();
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

  void _resetFilter() {
    setState(() {
      _namaController.clear();
      _selectedKategori = null;
      _dariTanggalController.clear();
      _sampaiTanggalController.clear();
    });
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
            'Filter Pemasukan Non Iuran',
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
              _buildTextField(
                controller: _namaController,
                label: 'Nama',
                hint: 'Cari nama...',
              ),
              const SizedBox(height: 16),
              const Text(
                'Kategori',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedKategori,
                hint: const Text('-- Pilih Kategori --'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedKategori = newValue;
                  });
                },
                items:
                    _kategoriList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              _buildDateField(
                context: context,
                controller: _dariTanggalController,
                label: 'Dari Tanggal',
              ),
              const SizedBox(height: 16),
              _buildDateField(
                context: context,
                controller: _sampaiTanggalController,
                label: 'Sampai Tanggal',
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
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
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          ),
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