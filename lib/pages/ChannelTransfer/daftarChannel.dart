import 'dart:io';
import 'package:flutter/material.dart';
import 'tambahChannel.dart';
// import 'tambahChannel.dart'; // removed: list should not show add button

class daftarChannelPage extends StatelessWidget {
  const daftarChannelPage({super.key});

  @override
  Widget build(BuildContext context) => const ChannelListSection();
}

class ChannelListSection extends StatefulWidget {
  const ChannelListSection({Key? key}) : super(key: key);

  @override
  State<ChannelListSection> createState() => _ChannelListSectionState();
}

class _ChannelListSectionState extends State<ChannelListSection> {
  final List<bool> _expanded = [];

  final List<Map<String, String>> _channels = [
    {
      'name': 'BCA',
      'type': 'Bank',
      'owner': 'PT. Bank Central Asia Tbk',
      'thumbnail': '',
      'account': '1234567890',
      'qr': '',
      'desc': '',
    },
    {
      'name': 'Dana',
      'type': 'E-Wallet',
      'owner': 'Dana Indonesia',
      'thumbnail': '',
      'account': '081234567890',
      'qr': '',
      'desc': '',
    },
    {
      'name': 'QRIS RT',
      'type': 'QRIS',
      'owner': 'RT 05',
      'thumbnail': '',
      'account': '',
      'qr': '',
      'desc': '',
    },
  ];

  List<Map<String, String>> get _visible => _channels;

  void _ensureExpandedLength() {
    if (_expanded.length != _visible.length) {
      _expanded.clear();
      _expanded.addAll(List<bool>.filled(_visible.length, false));
      if (_expanded.isNotEmpty) _expanded[0] = true;
    }
  }

  void _showDetail(Map<String, String> c) {
    showDialog<void>(
      context: context,
      builder: (dCtx) => AlertDialog(
        title: Text('Detail Transfer Channel'),
        content: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 8),
            Text('Nama Channel: ${c['name'] ?? ''}'),
            const SizedBox(height: 8),
            Text('Tipe Channel: ${c['type'] ?? ''}'),
            const SizedBox(height: 8),
            Text('Nomor Rekening / Akun: ${c['account'] ?? ''}'),
            const SizedBox(height: 8),
            Text('Nama Pemilik: ${c['owner'] ?? ''}'),
            const SizedBox(height: 12),
            const Text('Thumbnail:'),
            const SizedBox(height: 8),
            (c['thumbnail'] != null && (c['thumbnail'] ?? '').isNotEmpty)
                ? Image.network(c['thumbnail']!, width: 120, height: 120, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox.shrink())
                : Container(width: 120, height: 120, color: Colors.grey.shade200, child: const Center(child: Icon(Icons.image, size: 48, color: Colors.grey))),
            const SizedBox(height: 12),
            const Text('QR:'),
            const SizedBox(height: 8),
            (c['qr'] != null && (c['qr'] ?? '').isNotEmpty)
                ? Image.network(c['qr']!, width: 120, height: 160, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox.shrink())
                : Container(width: 120, height: 160, color: Colors.grey.shade200, child: const Center(child: Icon(Icons.qr_code, size: 48, color: Colors.grey))),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dCtx), child: const Text('Tutup')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _ensureExpandedLength();

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Channel')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: _visible.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (ctx, i) {
            final c = _visible[i];
            final idx = i;
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(children: [
                InkWell(
                  onTap: () => setState(() => _expanded[idx] = !_expanded[idx]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Row(children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.grey.shade200,
            child: (c['thumbnail'] != null && (c['thumbnail'] ?? '').isNotEmpty)
              ? ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: (c['thumbnail']!.startsWith('http'))
                  ? Image.network(c['thumbnail']!, width: 48, height: 48, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.image))
                  : Image.file(File(c['thumbnail']!), width: 48, height: 48, fit: BoxFit.cover),
                )
              : const Icon(Icons.image, color: Colors.grey),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(c['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), const SizedBox(height: 4), Text('${c['type'] ?? ''} • ${c['owner'] ?? ''} • ${c['account'] ?? ''}', style: const TextStyle(color: Colors.grey))])),
                      const SizedBox(width: 8),
                      Icon(_expanded[idx] ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.grey),
                    ]),
                  ),
                ),
                if (_expanded.length > idx && _expanded[idx])
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(c['desc'] ?? ''),
                      const SizedBox(height: 12),
                      Row(children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _showDetail(c),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple[100], foregroundColor: Colors.purple[800], elevation: 0),
                            child: const Text('Lihat Detail'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () async {
                            final result = await Navigator.push<Map<String, String>?>(context, MaterialPageRoute(builder: (_) => TambahChannelPage(initialData: c)));
                            if (result == null) return;
                            setState(() {
                              _channels[idx] = {
                                'name': result['name'] ?? '',
                                'type': result['type'] ?? '',
                                'owner': result['owner'] ?? '',
                                'thumbnail': result['thumbnail'] ?? '',
                                'account': result['account'] ?? '',
                                'qr': result['qr'] ?? '',
                                'desc': result['desc'] ?? '',
                              };
                            });
                          },
                          child: const Text('Edit'),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                          onPressed: () async {
                            final cfm = await showDialog<bool>(
                              context: context,
                              builder: (d) => AlertDialog(
                                title: const Text('Hapus Channel?'),
                                content: const Text('Yakin ingin menghapus channel ini?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(d, false), child: const Text('Batal')),
                                  TextButton(onPressed: () => Navigator.pop(d, true), child: const Text('Hapus')),
                                ],
                              ),
                            );
                            if (cfm != true) return;
                            setState(() => _channels.removeAt(idx));
                          },
                          child: const Text('Hapus'),
                        ),
                      ])
                    ]),
                  )
              ]),
            );
          },
        ),
      ),
    );
  }
}
