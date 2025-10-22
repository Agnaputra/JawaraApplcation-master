import 'package:flutter/material.dart';

// --- BAGIAN 1: MODAL FILTER (STATEFUL) ---
class BroadcastFilterPage extends StatefulWidget {
  const BroadcastFilterPage({super.key});

  @override
  State<BroadcastFilterPage> createState() => _BroadcastFilterDialogState();
}

class _BroadcastFilterDialogState extends State<BroadcastFilterPage> {
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF7166F9),
            colorScheme: const ColorScheme.light(primary: Color(0xFF7166F9)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _resetDate() {
    setState(() {
      _selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    String dateText = _selectedDate == null
        ? '-- / -- / ----'
        : '${_selectedDate!.day.toString().padLeft(2, '0')}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.year}';

    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Filter Broadcast',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Judul Broadcast',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Cari judul broadcast...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tanggal Kirim',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextFormField(
                readOnly: true,
                controller: TextEditingController(text: dateText),
                onTap: () => _selectDate(context),
                decoration: InputDecoration(
                  hintText: '-- / -- / ----',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: _resetDate,
                      ),
                      const SizedBox(width: 4),
                      Container(
                        color: Colors.grey.shade300,
                        width: 1,
                        height: 24,
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_month, size: 20),
                        onPressed: () => _selectDate(context),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.all(16.0),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Reset Filter',
            style: TextStyle(color: Colors.black54),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7166F9),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Terapkan'),
        ),
      ],
    );
  }
}

// --- BAGIAN 2: TABEL DATA BROADCAST ---
class _BroadcastDaftarTable extends StatelessWidget {
  const _BroadcastDaftarTable({super.key});

  @override
  Widget build(BuildContext context) {
    const List<String> headers = ['NO', 'PENGIRIM', 'JUDUL', 'TANGGAL', 'AKSI'];
    final List<List<String>> dataRows = [
      ['1', 'Admin Jawara', 'Gotong Royong', '14 Oktober 2025'],
      ['2', 'Admin Jawara', 'Rapat Bulanan', '10 Oktober 2025'],
      ['3', 'Admin Jawara', 'Pengumuman Lomba', '05 Oktober 2025'],
    ];

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header tabel
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FA),
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: List.generate(headers.length, (index) {
                  return Expanded(
                    flex: index == 0 || index == headers.length - 1 ? 1 : 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 12.0,
                      ),
                      child: Text(
                        headers[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: Color(0xFF707070),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          // Data rows
          ...dataRows.map((row) {
            return IntrinsicHeight(
              child: Row(
                children: [
                  ...List.generate(row.length, (colIndex) {
                    return Expanded(
                      flex: colIndex == 0 ? 1 : 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 12.0,
                        ),
                        child: Text(
                          row[colIndex],
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    );
                  }),

                  // Aksi
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 8.0,
                      ),
                      child: PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.more_horiz,
                          color: Color(0xFF9097A6),
                        ),
                        onSelected: (String result) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('$result: ${row[2]}'),
                              backgroundColor: result == 'Hapus'
                                  ? Colors.red
                                  : const Color(0xFF7166F9),
                            ),
                          );
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'Lihat Detail',
                                child: Text('Lihat Detail'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'Edit',
                                child: Text('Edit'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'Hapus',
                                child: Text(
                                  'Hapus',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          const Divider(height: 1, color: Color(0xFFF0F0F5)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.arrow_left, color: Color(0xFFD6D3D6)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7166F9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '1',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_right, color: Color(0xFFD6D3D6)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- BAGIAN 3: HALAMAN UTAMA ---
class BroadcastDaftarPage extends StatelessWidget {
  const BroadcastDaftarPage({super.key});

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const BroadcastFilterPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF7166F9).withOpacity(0.9),
                  const Color(0xFFC4B8FD),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(Icons.campaign, color: Colors.white, size: 30),
                SizedBox(width: 15),
                Text(
                  'Daftar Broadcast',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Tombol filter
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () => _showFilterDialog(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF7166F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.filter_alt,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Tabel data
          const _BroadcastDaftarTable(),
        ],
      ),
    );
  }
}
