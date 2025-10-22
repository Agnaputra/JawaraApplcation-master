import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class cetakLaporanPage extends StatefulWidget {
  const cetakLaporanPage({super.key});

  @override
  State<cetakLaporanPage> createState() => _cetakLaporanPageState();
}

class _cetakLaporanPageState extends State<cetakLaporanPage> {
  DateTime? _startDate;
  DateTime? _endDate;
  String _selectedJenis = 'Semua';

  final List<String> _jenisLaporan = ['Semua', 'Pemasukan', 'Pengeluaran'];

  // Fungsi untuk menampilkan date picker
  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  // Format tanggal
  String _formatDate(DateTime? date) {
    if (date == null) return '--/--/----';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  void _resetForm() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _selectedJenis = 'Semua';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cetak Laporan Keuangan',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),

                // Tanggal mulai dan akhir
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tanggal Mulai'),
                          const SizedBox(height: 8),
                          TextFormField(
                            readOnly: true,
                            controller: TextEditingController(
                              text: _formatDate(_startDate),
                            ),
                            decoration: InputDecoration(
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_startDate != null)
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () =>
                                          setState(() => _startDate = null),
                                    ),
                                  IconButton(
                                    icon: const Icon(Icons.calendar_today),
                                    onPressed: () => _selectDate(context, true),
                                  ),
                                ],
                              ),
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tanggal Akhir'),
                          const SizedBox(height: 8),
                          TextFormField(
                            readOnly: true,
                            controller: TextEditingController(
                              text: _formatDate(_endDate),
                            ),
                            decoration: InputDecoration(
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_endDate != null)
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () =>
                                          setState(() => _endDate = null),
                                    ),
                                  IconButton(
                                    icon: const Icon(Icons.calendar_today),
                                    onPressed: () =>
                                        _selectDate(context, false),
                                  ),
                                ],
                              ),
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Dropdown jenis laporan
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Jenis Laporan'),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedJenis,
                      items: _jenisLaporan
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedJenis = value!),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Tombol aksi
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // TODO: aksi cetak PDF
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Download PDF'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _resetForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
