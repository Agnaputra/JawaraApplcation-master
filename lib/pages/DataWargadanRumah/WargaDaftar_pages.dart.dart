import 'package:flutter/material.dart';

class WargadaftarPages extends StatefulWidget {
  const WargadaftarPages({super.key});

  @override
  State<WargadaftarPages> createState() => _WargadaftarPagesState();
}

class _WargadaftarPagesState extends State<WargadaftarPages> {
  String? selectedGender;
  String? selectedStatusDomisili;
  String? selectedStatusHidup;
  final TextEditingController namaController = TextEditingController();

  final List<Map<String, dynamic>> dataWarga = [
    {
      'no': 1,
      'nama': 'Varizky Naldiba Rimra',
      'nik': '1371111011030005',
      'keluarga': 'Keluarga Varizky Naldiba Rimra',
      'jenisKelamin': 'Perempuan',
      'statusDomisili': 'Aktif',
      'statusHidup': 'Hidup',
    },
    {
      'no': 2,
      'nama': 'Rendha Putra Rahmadya',
      'nik': '3505111512040002',
      'keluarga': 'Keluarga Rendha Putra Rahmadya',
      'jenisKelamin': 'Laki-laki',
      'statusDomisili': 'Aktif',
      'statusHidup': 'Hidup',
    },
    {
      'no': 3,
      'nama': 'Raudhil Firdaus Naufal',
      'nik': '3201122501050002',
      'keluarga': 'Keluarga Raudhil Firdaus Naufal',
      'jenisKelamin': 'Laki-laki',
      'statusDomisili': 'Aktif',
      'statusHidup': 'Wafat',
    },
  ];

  final List<String> genderList = ['Laki-laki', 'Perempuan'];
  final List<String> statusList = ['Aktif', 'Tidak Aktif'];
  final List<String> keluargaList = ['Keluarga 1', 'Keluaraga 2', 'Keluarga 3'];

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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter Penerimaan Warga',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTextField('Nama', namaController),
                  const SizedBox(height: 16),
                  _buildDropdown('Jenis Kelamin', selectedGender, genderList, (value) {
                    setState(() => selectedGender = value);
                  }),
                  const SizedBox(height: 16),
                  _buildDropdown('Status Domisili', selectedStatusDomisili, statusList, (value) {
                    setState(() => selectedStatusDomisili = value);
                  }),
                  const SizedBox(height: 16),
                  _buildDropdown('Keluarga', selectedStatusHidup, keluargaList, (value) {
                    setState(() => selectedStatusHidup = value);
                  }),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            namaController.clear();
                            selectedGender = null;
                            selectedStatusDomisili = null;
                            selectedStatusHidup = null;
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
                        onPressed: () => Navigator.pop(context),
                        // style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF635BFF)),
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
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Cari $label...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String? selectedValue, List<String> options, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: selectedValue,
          hint: Text('-- Pilih $label --'),
          decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
          items: options.map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'aktif':
        return Colors.green.shade100;
      case 'tidak aktif':
        return Colors.red.shade100;
      case 'hidup':
        return Colors.green.shade100;
      case 'wafat':
        return Colors.grey.shade300;
      default:
        return Colors.grey.shade100;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'aktif':
        return Colors.green.shade700;
      case 'tidak aktif':
        return Colors.red.shade700;
      case 'hidup':
        return Colors.green.shade700;
      case 'wafat':
        return Colors.grey.shade700;
      default:
        return Colors.black87;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _showFilterDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF635BFF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.all(12),
                ),
                child: const Icon(Icons.filter_list, color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 10)],
                ),
                child: isMobile ? _buildMobileList() : _buildDesktopTable(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: dataWarga.length,
      itemBuilder: (context, index) {
        final warga = dataWarga[index];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.symmetric(vertical: 6),
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${warga['no']}. ${warga['nama']}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text("NIK: ${warga['nik']}"),
                Text("Keluarga: ${warga['keluarga']}"),
                Text("Jenis Kelamin: ${warga['jenisKelamin']}"),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildStatusChip(warga['statusDomisili']),
                    const SizedBox(width: 8),
                    _buildStatusChip(warga['statusHidup']),
                    const Spacer(),
                    const Icon(Icons.more_horiz, color: Colors.grey),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 1000,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: Colors.grey[100],
              child: const Row(
                children: [
                  Expanded(flex: 1, child: Text('NO', style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(flex: 2, child: Text('NAMA', style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(flex: 3, child: Text('NIK', style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(flex: 3, child: Text('KELUARGA', style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(flex: 2, child: Text('JENIS KELAMIN', style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(flex: 2, child: Text('STATUS DOMISILI', style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(flex: 2, child: Text('STATUS HIDUP', style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(flex: 1, child: Text('AKSI', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                itemCount: dataWarga.length,
                itemBuilder: (context, index) {
                  final warga = dataWarga[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(flex: 1, child: Text('${warga['no']}')),
                        Expanded(flex: 2, child: Text(warga['nama'])),
                        Expanded(flex: 3, child: Text(warga['nik'])),
                        Expanded(flex: 3, child: Text(warga['keluarga'])),
                        Expanded(flex: 2, child: Text(warga['jenisKelamin'])),
                        Expanded(flex: 2, child: _buildStatusChip(warga['statusDomisili'])),
                        Expanded(flex: 2, child: _buildStatusChip(warga['statusHidup'])),
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
    );
  }

  Widget _buildStatusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(status),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: _getStatusTextColor(status),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
