import 'package:flutter/material.dart';

class tagihanIuranPage extends StatefulWidget {
  const tagihanIuranPage({super.key});

  @override
  State<tagihanIuranPage> createState() => _tagihanIuranPageState();
}

class _tagihanIuranPageState extends State<tagihanIuranPage> {
  String? _selectedIuran;

  final List<String> _jenisIuranList = [
    'Mingguan',
    'Bersih Desa',
    'Agustusan',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Tagih Iuran ke Semua Keluarga Aktif',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Jenis Iuran',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedIuran,
                    hint: const Text('-- Pilih Iuran --'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedIuran = newValue;
                      });
                    },
                    items: _jenisIuranList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text('Tagih Iuran'),
                      ),
                      const SizedBox(width: 16),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedIuran = null;
                          });
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey.shade700,
                           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                           shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(color: Colors.grey.shade300)
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
      ),
    );
  }
}