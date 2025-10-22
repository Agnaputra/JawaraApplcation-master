import 'package:flutter/material.dart';
import 'penerimaan_warga_tambah.dart';
import '../../widgets/filter_button.dart';

class penerimaanWargaPage extends StatefulWidget {
  const penerimaanWargaPage({super.key});

  @override
  State<penerimaanWargaPage> createState() => _penerimaanWargaPageState();
}

class _penerimaanWargaPageState extends State<penerimaanWargaPage> {
  // Track which cards are expanded (kept in sync with `_registrations`)
  final List<bool> _expandedList = [];

  // Filter state
  String _filterName = '';
  String? _filterGender; // 'Laki-laki' or 'Perempuan'
  String? _filterStatus; // 'Menunggu','Diterima','Ditolak'

  // Registrations data (source of truth)
  final List<Map<String, String>> _allRegistrations = [
    {
      'name': 'charel',
      'nik': '123456789',
      'email': 'charel@example.com',
      'gender': 'Laki-laki',
      'status': 'Menunggu',
    },
    {
      'name': 'agna',
      'nik': '987654321',
      'email': 'agna@example.com',
      'gender': 'Laki-laki',
      'status': 'Diterima',
    },
    {
      'name': 'majid',
      'nik': '456789123',
      'email': 'majid@example.com',
      'gender': 'Laki-laki',
      'status': 'Ditolak',
    },
    {
      'name': 'ridho',
      'nik': '321654987',
      'email': 'ridho@example.com',
      'gender': 'Laki-laki',
      'status': 'Menunggu',
    },
    {
      'name': 'aqila',
      'nik': '654321987',
      'email': 'aqila@example.com',
      'gender': 'Perempuan',
      'status': 'Diterima',
    },
  ];

  // Derived (filtered) list
  List<Map<String, String>> get _registrations {
    return _allRegistrations.where((r) {
      final matchesName = _filterName.isEmpty || r['name']!.toLowerCase().contains(_filterName.toLowerCase());
      final matchesGender = _filterGender == null || r['gender'] == _filterGender;
      final matchesStatus = _filterStatus == null || r['status'] == _filterStatus;
      return matchesName && matchesGender && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Ensure expanded list has the same length as current registrations
    if (_expandedList.length != _registrations.length) {
      _expandedList.clear();
      _expandedList.addAll(List<bool>.filled(_registrations.length, false));
      if (_expandedList.isNotEmpty) _expandedList[0] = true;
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Top action row with Tambah and Filter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterButton(
                  icon: Icons.add,
                  label: 'Tambah',
                  onPressed: () async {
                    // Navigate to tambah page and await new registration map
                    final result = await Navigator.push<Map<String, String>?>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const penerimaanWargaTambahPage(),
                      ),
                    );
                    if (result != null) {
                      setState(() {
                        // Insert at the top
                        _allRegistrations.insert(0, result);
                        // Clear filters so new item is visible and re-sync expanded list
                        _filterName = '';
                        _filterGender = null;
                        _filterStatus = null;
                      });
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 0.0),
                child: OutlinedButton.icon(
                  onPressed: () => _showFilterDialog(context),
                  icon: const Icon(Icons.filter_list),
                  label: const Text('Filter'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Registrations list
          Expanded(
            child: ListView.separated(
              itemCount: _registrations.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final r = _registrations[i];
                // Map filtered item back to original list index (use NIK as identifier)
                final origIndex = _allRegistrations.indexWhere((e) => e['nik'] == r['nik']);
                final status = r['status']!;
                final statusColor = status == 'Menunggu'
                    ? Colors.amber
                    : status == 'Diterima'
                        ? Colors.green
                        : Colors.red;
                return _buildRegistrationCard(
                  name: r['name']!,
                  nik: r['nik']!,
                  email: r['email']!,
                  gender: r['gender']!,
                  registrationStatus: status,
                  statusColor: statusColor,
                  isExpanded: _expandedList[i],
                  index: i,
                  allIndex: origIndex,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Method to show the identity photo
  void _showIdentityPhoto(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: AppBar(
                  title: const Text("Foto Identitas"),
                  automaticallyImplyLeading: false,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              // const Padding(padding: EdgeInsets.all(16.0))
              Image.asset(
                'assets/images/placeholder.png',
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Handle image loading error
                  return const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Icon(Icons.broken_image, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          "Gambar tidak ditemukan",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Foto KTP/Identitas"),
              ),
            ],
          ),
        );
      },
    );
  }

  // Filter dialog implementation
  void _showFilterDialog(BuildContext context) {
    final nameController = TextEditingController(text: _filterName);
    String? selectedGender = _filterGender;
    String? selectedStatus = _filterStatus;

    showDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Theme(
            // Ensure dropdown menus use white background inside dialog
            data: Theme.of(context).copyWith(canvasColor: Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Filter Penerimaan Warga', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  const Text('Nama'),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(hintText: 'Cari nama...'),
                  ),
                  const SizedBox(height: 12),

                  const Text('Jenis Kelamin'),
                  DropdownButtonFormField<String?>(
                    value: selectedGender,
                    items: const [
                      DropdownMenuItem<String?>(value: null, child: Text('-- Pilih Jenis Kelamin --')),
                      DropdownMenuItem<String?>(value: 'Laki-laki', child: Text('Laki-laki')),
                      DropdownMenuItem<String?>(value: 'Perempuan', child: Text('Perempuan')),
                    ],
                    onChanged: (v) {
                      selectedGender = v;
                    },
                    decoration: const InputDecoration(),
                  ),
                  const SizedBox(height: 12),

                  const Text('Status'),
                  DropdownButtonFormField<String?>(
                    value: selectedStatus,
                    items: const [
                      DropdownMenuItem<String?>(value: null, child: Text('-- Pilih Status --')),
                      DropdownMenuItem<String?>(value: 'Menunggu', child: Text('Menunggu')),
                      DropdownMenuItem<String?>(value: 'Diterima', child: Text('Diterima')),
                      DropdownMenuItem<String?>(value: 'Ditolak', child: Text('Ditolak')),
                    ],
                    onChanged: (v) {
                      selectedStatus = v;
                    },
                    decoration: const InputDecoration(),
                  ),

                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Reset filters
                          setState(() {
                            _filterName = '';
                            _filterGender = null;
                            _filterStatus = null;
                          });
                          Navigator.pop(dialogContext);
                        },
                        child: const Text('Reset Filter'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _filterName = nameController.text;
                            _filterGender = selectedGender;
                            _filterStatus = selectedStatus;
                          });
                          Navigator.pop(dialogContext);
                        },
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
  }

  Widget _buildRegistrationCard({
    required String name,
    required String nik,
    required String email,
    required String gender,
    required String registrationStatus,
    required MaterialColor statusColor,
    required bool isExpanded,
    required int index,
    required int allIndex,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Header section (always visible)
          InkWell(
            onTap: () {
              setState(() {
                _expandedList[index] = !_expandedList[index];
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  // Left side: Name and status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "status: $registrationStatus",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Right side: Status chip and expand arrow
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      registrationStatus,
                      style: TextStyle(
                        color: statusColor[800],
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),

          // Expanded details section (only visible when expanded)
          if (isExpanded)
            Column(
              children: [
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Registration details
                      Text("NIK: $nik"),
                      Text("Email: $email"),
                      Text("Jenis Kelamin: $gender"),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text("Foto Identitas: "),
                          const Icon(Icons.image, size: 20),
                          TextButton(
                            onPressed: () {
                              // Open the identity photo
                              _showIdentityPhoto(context);
                            },
                            child: const Text('Lihat'),
                          ),
                        ],
                      ),

                      // Action buttons
                      const SizedBox(height: 16),
                      if (registrationStatus == 'Menunggu')
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  // Terima: set status to Diterima on original list
                                  setState(() {
                                    if (allIndex >= 0) _allRegistrations[allIndex]['status'] = 'Diterima';
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green[100],
                                  foregroundColor: Colors.green[800],
                                  elevation: 0,
                                ),
                                child: const Text('Terima'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  // Tolak: set status to Ditolak on original list
                                  setState(() {
                                    if (allIndex >= 0) _allRegistrations[allIndex]['status'] = 'Ditolak';
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red[100],
                                  foregroundColor: Colors.red[800],
                                  elevation: 0,
                                ),
                                child: const Text('Tolak'),
                              ),
                            ),
                          ],
                        )
                      else
                        Row(
                          children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      // Open edit form with initial data
                                      final initial = Map<String, String>.from(_allRegistrations[allIndex]);
                                      final result = await Navigator.push<Map<String, String>?>(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => penerimaanWargaTambahPage(initialData: initial),
                                        ),
                                      );
                                      if (result != null) {
                                        setState(() {
                                          _allRegistrations[allIndex] = result;
                                        });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.purple[100],
                                      foregroundColor: Colors.purple[800],
                                      elevation: 0,
                                    ),
                                    child: const Text('Edit'),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Popup menu to change status (Diterima <-> Ditolak)
                                PopupMenuButton<String>(
                                  tooltip: 'Ubah status',
                                  onSelected: (value) {
                                    setState(() {
                                      if (allIndex >= 0) _allRegistrations[allIndex]['status'] = value;
                                    });
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(value: 'Diterima', child: Text('Set Diterima')),
                                    const PopupMenuItem(value: 'Ditolak', child: Text('Set Ditolak')),
                                  ],
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.swap_horiz, size: 20, color: Colors.black54),
                                  ),
                                ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}