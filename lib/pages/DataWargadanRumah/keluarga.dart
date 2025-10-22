import 'package:flutter/material.dart';

class KeluargaPage extends StatefulWidget {
  const KeluargaPage({super.key});

  @override
  State<KeluargaPage> createState() => _KeluargaPageState();
}

class _KeluargaPageState extends State<KeluargaPage> {
  String? selectedStatus;
  String? selectedRumah;
  final TextEditingController namaController = TextEditingController();

  final List<Map<String, dynamic>> dataKeluarga = [
    {
      'no': 1,
      'namaKeluarga': 'Keluarga Varizky Naldiba Rimra',
      'kepalaKeluarga': 'Varizky Naldiba Rimra',
      'alamatRumah': 'Rumah 1',
      'statusKepemilikan': 'Pemilik',
      'status': 'Aktif',
    },
    {
      'no': 2,
      'namaKeluarga': 'Keluarga Arman Maulana',
      'kepalaKeluarga': 'Arman Maulana',
      'alamatRumah': 'Rumah 2',
      'statusKepemilikan': 'Kontrakan',
      'status': 'Tidak Aktif',
    },
    {
      'no': 3,
      'namaKeluarga': 'Keluarga Aditya Saputra',
      'kepalaKeluarga': 'Aditya Saputra',
      'alamatRumah': 'Rumah 3',
      'statusKepemilikan': 'Pemilik',
      'status': 'Aktif',
    },
  ];

  final List<String> rumahList = ['Rumah 1', 'Rumah 2', 'Rumah 3'];
  final List<String> statusList = ['Aktif', 'Tidak Aktif'];

  List<Map<String, dynamic>> get filteredData {
    return dataKeluarga.where((keluarga) {
      final matchNama = namaController.text.isEmpty ||
          keluarga['namaKeluarga']
              .toString()
              .toLowerCase()
              .contains(namaController.text.toLowerCase());
      final matchStatus = selectedStatus == null ||
          keluarga['status'] == selectedStatus;
      final matchRumah =
          selectedRumah == null || keluarga['alamatRumah'] == selectedRumah;
      return matchNama && matchStatus && matchRumah;
    }).toList();
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter Data Keluarga',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTextField('Nama Keluarga', namaController),
                  const SizedBox(height: 16),
                  _buildDropdown('Status', selectedStatus, statusList, (value) {
                    setState(() => selectedStatus = value);
                  }),
                  const SizedBox(height: 16),
                  _buildDropdown('Rumah', selectedRumah, rumahList, (value) {
                    setState(() => selectedRumah = value);
                  }),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            namaController.clear();
                            selectedStatus = null;
                            selectedRumah = null;
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
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          items: options
              .map((value) => DropdownMenuItem(value: value, child: Text(value)))
              .toList(),
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
      default:
        return Colors.black87;
    }
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

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.05),
                      blurRadius: 10,
                    )
                  ],
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
      itemCount: filteredData.length,
      itemBuilder: (context, index) {
        final keluarga = filteredData[index];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.symmetric(vertical: 6),
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${keluarga['no']}. ${keluarga['namaKeluarga']}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text("Kepala Keluarga: ${keluarga['kepalaKeluarga']}"),
                Text("Alamat Rumah: ${keluarga['alamatRumah']}"),
                Text("Status Kepemilikan: ${keluarga['statusKepemilikan']}"),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildStatusChip(keluarga['status']),
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
                  Expanded(flex: 3, child: Text('NAMA KELUARGA', style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(flex: 3, child: Text('KEPALA KELUARGA', style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(flex: 3, child: Text('ALAMAT RUMAH', style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(flex: 2, child: Text('STATUS KEPEMILIKAN', style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(flex: 2, child: Text('STATUS', style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(flex: 1, child: Text('AKSI', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  final keluarga = filteredData[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(flex: 1, child: Text('${keluarga['no']}')),
                        Expanded(flex: 3, child: Text(keluarga['namaKeluarga'])),
                        Expanded(flex: 3, child: Text(keluarga['kepalaKeluarga'])),
                        Expanded(flex: 3, child: Text(keluarga['alamatRumah'])),
                        Expanded(flex: 2, child: Text(keluarga['statusKepemilikan'])),
                        Expanded(flex: 2, child: _buildStatusChip(keluarga['status'])),
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
}

