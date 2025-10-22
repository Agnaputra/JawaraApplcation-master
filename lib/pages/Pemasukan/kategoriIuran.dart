import 'package:flutter/material.dart';

class KategoriiuranPages extends StatefulWidget {
  const KategoriiuranPages({super.key});

  @override
  State<KategoriiuranPages> createState() => _KategoriIuranPagesState();
}

class _KategoriIuranPagesState extends State<KategoriiuranPages> {
  final List<Map<String, dynamic>> _data = [
    {
      "no": 1,
      "nama": "Bersih Desa",
      "jenis": "Iuran Khusus",
      "nominal": 200000
    },
    {
      "no": 2,
      "nama": "Mingguan",
      "jenis": "Iuran Khusus",
      "nominal": 1200
    },
    {
      "no": 3,
      "nama": "Agustusan",
      "jenis": "Iuran Khusus",
      "nominal": 15000
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildInfoBox(),
              const SizedBox(height: 16),
              Card(
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.blue.shade300, width: 1.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info, color: Colors.blue.shade700, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black87, fontSize: 14, height: 1.5),
                children: [
                  const TextSpan(
                      text: 'Info: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const TextSpan(
                      text: 'Iuran Bulanan: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const TextSpan(
                      text: 'Dibayar setiap bulan sekali secara rutin.\n'),
                  const TextSpan(
                      text: 'Iuran Khusus: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const TextSpan(
                      text:
                          'Dibayar sesuai jadwal atau kebutuhan tertentu, misalnya iuran untuk acara khusus, renovasi, atau kegiatan lain yang tidak rutin.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            _showAddIuranDialog(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.all(12),
          ),
          child: const Icon(Icons.add),
        ),
        ElevatedButton(
          onPressed: () {},
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
                DataColumn(label: Text('NAMA IURAN')),
                DataColumn(label: Text('JENIS IURAN')),
                DataColumn(label: Text('NOMINAL')),
                DataColumn(label: Text('AKSI')),
              ],
              rows: _data.map((item) {
                return DataRow(
                  cells: [
                    DataCell(Text(item['no'].toString())),
                    DataCell(Text(item['nama'])),
                    DataCell(Text(item['jenis'])),
                    DataCell(Text('Rp ${item['nominal'].toString()},00')),
                    DataCell(
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_horiz),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onSelected: (String value) {
                          if (value == 'edit') {
                            _showEditIuranDialog(context, item);
                          } else if (value == 'detail') {
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'detail',
                            child: Text('Detail'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'edit',
                            child: Text('Edit'),
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

  void _showAddIuranDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return const _AddIuranDialog();
      },
    );
  }

  void _showEditIuranDialog(BuildContext context, Map<String, dynamic> iuranData) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return _EditIuranDialog(iuranData: iuranData);
      },
    );
  }
}

class _AddIuranDialog extends StatefulWidget {
  const _AddIuranDialog({Key? key}) : super(key: key);

  @override
  State<_AddIuranDialog> createState() => _AddIuranDialogState();
}

class _AddIuranDialogState extends State<_AddIuranDialog> {
  final _namaController = TextEditingController();
  final _jumlahController = TextEditingController();
  String? _selectedKategori;
  final List<String> _kategoriList = ['Iuran Khusus', 'Iuran Bulanan'];

  @override
  void dispose() {
    _namaController.dispose();
    _jumlahController.dispose();
    super.dispose();
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
            'Buat Iuran Baru',
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
              const Text('Masukkan data iuran baru dengan lengkap.'),
              const SizedBox(height: 24),
              _buildTextField(
                controller: _namaController,
                label: 'Nama Iuran',
                hint: 'Masukkan nama iuran',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _jumlahController,
                label: 'Jumlah',
                hint: 'Contoh: 50000',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              const Text(
                'Kategori Iuran',
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
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Batal'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text('Simpan'),
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
    TextInputType keyboardType = TextInputType.text,
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
          keyboardType: keyboardType,
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
}

class _EditIuranDialog extends StatefulWidget {
  final Map<String, dynamic> iuranData;
  const _EditIuranDialog({Key? key, required this.iuranData}) : super(key: key);

  @override
  State<_EditIuranDialog> createState() => _EditIuranDialogState();
}

class _EditIuranDialogState extends State<_EditIuranDialog> {
  // Controller untuk form
  late TextEditingController _namaController;
  late TextEditingController _jumlahController;
  String? _selectedKategori;
  final List<String> _kategoriList = ['Iuran Khusus', 'Iuran Bulanan'];

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.iuranData['nama']);
    _jumlahController =
        TextEditingController(text: widget.iuranData['nominal'].toString());
    _selectedKategori = widget.iuranData['jenis'];
  }

  @override
  void dispose() {
    _namaController.dispose();
    _jumlahController.dispose();
    super.dispose();
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
            'Edit Iuran',
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
              const Text('Ubah data iuran yang diperlukan.'),
              const SizedBox(height: 24),
              _buildTextField(
                controller: _namaController,
                label: 'Nama Iuran',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _jumlahController,
                label: 'Jumlah',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              
              const Text(
                'Kategori Iuran',
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
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Batal'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text('Simpan'),
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
    TextInputType keyboardType = TextInputType.text,
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
          keyboardType: keyboardType,
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
}