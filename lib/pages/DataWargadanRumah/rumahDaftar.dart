import 'package:flutter/material.dart';

class rumahDaftarPage extends StatefulWidget {
  const rumahDaftarPage({super.key});

  @override
  State<rumahDaftarPage> createState() => _rumahDaftarPageState();
}

class _rumahDaftarPageState extends State<rumahDaftarPage> {
  String? selectedStatus;
  String? selectedAlamat;
  final TextEditingController namaController = TextEditingController();

  final List<Map<String, dynamic>> dataRumah = [
    {
      'no': 1,
      'alamat': 'Jl. Merbabu',
      'status': 'Tersedia',
    },
    {
      'no': 2,
      'alamat': 'Griyashanta L.203',
      'status': 'Ditempati',
    },
    {
      'no': 3,
      'alamat': 'Jl. Baru Bangun',
      'status': 'Ditempati',
    },
  ];

  final List<String> statusList = ['Tersedia', 'Ditempati', 'Nonaktif'];

  List<String> get alamatList {
    final set = <String>{};
    for (final r in dataRumah) {
      if (r['alamat'] != null) set.add(r['alamat'].toString());
    }
    return set.toList();
  }

  List<Map<String, dynamic>> get filteredData {
    return dataRumah.where((rumah) {
      final matchNama = namaController.text.isEmpty ||
          rumah['alamat'].toString().toLowerCase().contains(namaController.text.toLowerCase());
      final matchStatus = selectedStatus == null || rumah['status'] == selectedStatus;
      final matchAlamat = selectedAlamat == null || rumah['alamat'] == selectedAlamat;
      return matchNama && matchStatus && matchAlamat;
    }).toList();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String? tempStatus = selectedStatus;
        String? tempAlamat = selectedAlamat;
        final TextEditingController tempNamaController = TextEditingController(text: namaController.text);

        return StatefulBuilder(
          builder: (context, setDialogState) {
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
                            'Filter Data Rumah',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Alamat / Kata kunci'),
                          const SizedBox(height: 4),
                          TextField(
                            controller: tempNamaController,
                            decoration: InputDecoration(
                              hintText: 'Cari alamat...',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Status'),
                          const SizedBox(height: 4),
                          DropdownButtonFormField<String>(
                            value: tempStatus,
                            hint: const Text('-- Pilih Status --'),
                            decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                            items: statusList.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                            onChanged: (v) => setDialogState(() => tempStatus = v),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              setState(() {
                                namaController.clear();
                                selectedStatus = null;
                                selectedAlamat = null;
                              });
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black87,
                              side: const BorderSide(color: Color(0xFFE0E0E0)),
                              backgroundColor: const Color(0xFFF7F8FB),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Reset Filter'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                namaController.text = tempNamaController.text;
                                selectedStatus = tempStatus;
                                selectedAlamat = tempAlamat;
                              });
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF635BFF),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              textStyle: const TextStyle(fontWeight: FontWeight.w600),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'tersedia':
        return Colors.green.shade100;
      case 'ditempati':
        return Colors.orange.shade100;
      case 'nonaktif':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'tersedia':
        return Colors.green.shade700;
      case 'ditempati':
        return Colors.orange.shade700;
      case 'nonaktif':
        return Colors.red.shade700;
      default:
        return Colors.black87;
    }
  }

  Widget _buildStatusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: _getStatusColor(status), borderRadius: BorderRadius.circular(12)),
      child: Text(status, style: TextStyle(color: _getStatusTextColor(status), fontWeight: FontWeight.w600)),
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
    final list = filteredData;
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final rumah = list[index];
        final alamat = rumah['alamat']?.toString() ?? '';
        final status = rumah['status']?.toString() ?? '';
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.symmetric(vertical: 6),
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("${rumah['no']}. $alamat", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 6),
              Text("Status: $status"),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildStatusChip(status),
                  const Spacer(),
                  const Icon(Icons.more_horiz, color: Colors.grey),
                ],
              ),
            ]),
          ),
        );
      },
    );
  }

  Widget _buildDesktopTable() {
    final list = filteredData;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 800,
        child: Column(children: [
          // header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: Colors.grey[100],
            child: const Row(children: [
              Expanded(flex: 1, child: Text('NO', style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(flex: 6, child: Text('ALAMAT', style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(flex: 3, child: Text('STATUS', style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(flex: 1, child: Text('AKSI', style: TextStyle(fontWeight: FontWeight.bold))),
            ]),
          ),
          const Divider(height: 1),

          Expanded(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final rumah = list[index];
                final alamat = rumah['alamat']?.toString() ?? '';
                final status = rumah['status']?.toString() ?? '';
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(children: [
                    Expanded(flex: 1, child: Text('${rumah['no']}')),
                    Expanded(flex: 6, child: Text(alamat)),
                    Expanded(flex: 3, child: _buildStatusChip(status)),
                    const Expanded(flex: 1, child: Icon(Icons.more_horiz)),
                  ]),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
