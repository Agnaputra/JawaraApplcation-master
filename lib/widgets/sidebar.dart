import 'package:flutter/material.dart';

import 'package:jawaraapllication/pages/dashboard_page.dart';
import 'package:jawaraapllication/main.dart';

//dashboard
// import 'package:jawaraapllication/pages/datawarga_page.dart';
import 'package:jawaraapllication/pages/Dashboard/keuangan_pages.dart';
import 'package:jawaraapllication/pages/Dashboard/kegiatan_pages.dart';
import 'package:jawaraapllication/pages/Dashboard/Kependudukan_pages.dart';

//channel transfer
import 'package:jawaraapllication/pages/ChannelTransfer/tambahChannel.dart';
import 'package:jawaraapllication/pages/ChannelTransfer/daftarChannel.dart';

//data warga & rumah
import 'package:jawaraapllication/pages/DataWargadanRumah/keluarga.dart';
import 'package:jawaraapllication/pages/DataWargadanRumah/rumahDaftar.dart';
import 'package:jawaraapllication/pages/DataWargadanRumah/rumahTambah.dart';
import 'package:jawaraapllication/pages/DataWargadanRumah/wargaTambah.dart';
import 'package:jawaraapllication/pages/DataWargadanRumah/WargaDaftar_pages.dart.dart';

//kegiatan & broadcast
import 'package:jawaraapllication/pages/KegiatandanBroadcast/kegiatanDaftar.dart';
import 'package:jawaraapllication/pages/KegiatandanBroadcast/kegiatanTambah.dart';
import 'package:jawaraapllication/pages/KegiatandanBroadcast/broadcastDaftar.dart';
import 'package:jawaraapllication/pages/KegiatandanBroadcast/broadcastTambah.dart';

//laporan keuangan
import 'package:jawaraapllication/pages/LaporanKeuangan/semuaPemasukan.dart';
import 'package:jawaraapllication/pages/LaporanKeuangan/semuaPengeluaran.dart';
import 'package:jawaraapllication/pages/LaporanKeuangan/cetakLaporan.dart';

//log aktifitas
import 'package:jawaraapllication/pages/LogAktivitas/semuaAktifitas.dart';

//manajemen pengguna
import 'package:jawaraapllication/pages/ManajemenPengguna/daftarPengguna.dart';
import 'package:jawaraapllication/pages/ManajemenPengguna/tambahPengguna.dart';

//mutasi keluarga
import 'package:jawaraapllication/pages/MutasiKeluarga/mutasiDaftar.dart';
import 'package:jawaraapllication/pages/MutasiKeluarga/mutasiTambah.dart';

//pemasukan
import 'package:jawaraapllication/pages/Pemasukan/kategoriIuran.dart';
import 'package:jawaraapllication/pages/Pemasukan/tagihIuran.dart';
import 'package:jawaraapllication/pages/Pemasukan/tagihan.dart';
import 'package:jawaraapllication/pages/Pemasukan/pemasukanLainDaftar.dart';
import 'package:jawaraapllication/pages/Pemasukan/pemasukanLainTambah.dart';

//penerimaan warga
import 'package:jawaraapllication/pages/PenerimaanWarga/penerimaanWarga.dart';

//pengeluaran
import 'package:jawaraapllication/pages/Pengeluaran/pengeluaranDaftar.dart';
import 'package:jawaraapllication/pages/Pengeluaran/pengeluaranTambah.dart';

//pesan warga
import 'package:jawaraapllication/pages/PesanWarga/infoAspirasi.dart';

//import 'package:jawaraapllication/pages/KegiatandanBroadcast/broadcastTambah.dart';

class SideBar extends StatelessWidget {
  final Function(Widget) onNavigate;
  const SideBar({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF9FAFB),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.menu_book, color: Colors.indigo),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Jawara Pintar 3',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Menu',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),

            // ======================
            //   MENU UTAMA
            // ======================
            Expanded(
              child: ListView(
                children: [
                  // DASHBOARD
                  ExpansionTile(
                    leading: Icon(Icons.dashboard_outlined),
                    title: Text('Dashboard'),
                    childrenPadding: EdgeInsets.only(left: 48),
                    children: [
                      ListTile(
                        leading: Icon(Icons.account_balance_wallet_outlined),
                        title: Text('Keuangan'),
                        onTap: () {
                          onNavigate(const KeuanganPage());
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.event_available_outlined),
                        title: Text('Kegiatan'),
                        onTap: () {
                          onNavigate(const KegiatanPage());
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.people_alt_outlined),
                        title: Text('Kependudukan'),
                        onTap: () {
                          onNavigate(const KependudukanPage());
                        },
                      ),
                    ],
                  ),

                  // DATA WARGA & RUMAH
                  ExpansionTile(
                    leading: Icon(Icons.groups_2_outlined),
                    title: Text('Data Warga & Rumah'),
                    childrenPadding: EdgeInsets.only(left: 48, bottom: 4),
                    children: [
                      ListTile(
                        leading: Icon(Icons.people_outline),
                        title: Text('Warga - Daftar'),
                        onTap: () {
                          onNavigate(const WargadaftarPages());
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.person_add_alt_1_outlined),
                        title: Text('Warga - Tambah'),
                        onTap: () {
                          onNavigate(const wargaTambahPage());
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.family_restroom_outlined),
                        title: Text('Keluarga'),
                        onTap: () {
                          onNavigate(const KeluargaPage());
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.house_outlined),
                        title: Text('Rumah - Daftar'),
                        onTap: () {
                          onNavigate(const rumahDaftarPage());
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.add_home_work_outlined),
                        title: Text('Rumah - Tambah'),
                        onTap: () {
                          onNavigate(const rumahTambahPage());
                        },
                      ),
                    ],
                  ),

                  // PEMASUKAN
                  ExpansionTile(
                    leading: Icon(Icons.attach_money_outlined),
                    title: Text('Pemasukan'),
                    childrenPadding: EdgeInsets.only(left: 48, bottom: 4),
                    children: [
                      ListTile(
                        leading: Icon(Icons.category_outlined),
                        title: Text('Kategori Iuran'),
                        onTap: () {
                          onNavigate(const KategoriiuranPages());
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.receipt_long_outlined),
                        title: Text('Tagih Iuran'),
                        onTap: () {
                          onNavigate(const tagihanIuranPage());
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.list_alt_outlined),
                        title: Text('Tagihan'),
                        onTap: () {
                          onNavigate(const tagihanPage());
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.add_card_outlined),
                        title: Text('Pemasukan Lain - Daftar'),
                        onTap: () {
                          onNavigate(const pemasukanLainPage());
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.add_circle_outline),
                        title: Text('Pemasukan Lain - Tambah'),
                        onTap: () {
                          onNavigate(const pemasukanLainTambahPage());
                        },
                      ),
                    ],
                  ),

                  // PENGELUARAN
                  ExpansionTile(
                    leading: Icon(Icons.money_off_csred_outlined),
                    title: Text('Pengeluaran'),
                    childrenPadding: EdgeInsets.only(left: 48, bottom: 4),
                    children: [
                      ListTile(
                        leading: Icon(Icons.list_alt_outlined),
                        title: Text('Daftar'),
                        onTap: () {
                          onNavigate(const pengeluaranDaftarPage());
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.add_circle_outline),
                        title: Text('Tambah'),
                        onTap: () {
                          onNavigate(const pengeluaranTambahPage());
                        },
                      ),
                    ],
                  ),

                  // LAPORAN
                  ExpansionTile(
                    leading: Icon(Icons.bar_chart_outlined),
                    title: Text('Laporan Keuangan'),
                    childrenPadding: EdgeInsets.only(left: 48, bottom: 4),
                    children: [
                      ListTile(
                        leading: Icon(Icons.trending_up_outlined),
                        title: Text('Semua Pemasukan'),
                        onTap: () {
                          onNavigate(const semuaPemasukanPage());
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.trending_down_outlined),
                        title: Text('Semua Pengeluaran'),
                        onTap: () {
                          onNavigate(const semuaPengeluaranPage());
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.print_outlined),
                        title: Text('Cetak Laporan'),
                        onTap: () {
                          onNavigate(const cetakLaporanPage());
                        },
                      ),
                    ],
                  ),

                  // KEGIATAN
                  ExpansionTile(
                    leading: Icon(Icons.event_note_outlined),
                    title: Text('Kegiatan & Broadcast'),
                    childrenPadding: EdgeInsets.only(left: 48, bottom: 4),
                    children: [
                      ListTile(
                        leading: Icon(Icons.event_note_outlined),
                        title: Text('Kegiatan - Daftar'),
                        onTap: () {
                          onNavigate(const KegiatanDaftarPage());
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.add_circle_outline),
                        title: Text('Kegiatan - Tambah'),
                        onTap: () {
                          onNavigate(const KegiatanTambahPage());
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.notifications_active_outlined),
                        title: Text('Broadcast - Daftar'),
                        onTap: () {
                          onNavigate(const BroadcastDaftarPage());
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.add_alert_outlined),
                        title: Text('Broadcast - Tambah'),
                        onTap: () {
                          onNavigate(const BroadcastTambahPage());
                        },
                      ),
                    ],
                  ),

                  // PESAN
                  ExpansionTile(
                    leading: Icon(Icons.chat_bubble_outline),
                    title: Text('Pesan Warga'),
                    childrenPadding: EdgeInsets.only(left: 48, bottom: 4),
                    children: [
                      ListTile(
                        leading: Icon(Icons.forum_outlined),
                        title: Text('Informasi Aspirasi'),
                        onTap: () {
                          onNavigate(const infoAspirasiPage());
                        },
                      ),
                    ],
                  ),

                  // PENERIMAAN
                  ExpansionTile(
                    leading: Icon(Icons.volunteer_activism_outlined),
                    title: Text('Penerimaan Warga'),
                    childrenPadding: EdgeInsets.only(left: 48, bottom: 4),
                    children: [
                      ListTile(
                        leading: Icon(Icons.volunteer_activism_outlined),
                        title: Text('Penerimaan Warga'),
                        onTap: () {
                          onNavigate(const penerimaanWargaPage());
                        },
                      ),
                    ],
                  ),

                  // MUTASI
                  ExpansionTile(
                    leading: Icon(Icons.compare_arrows_outlined),
                    title: Text('Mutasi Keluarga'),
                    childrenPadding: EdgeInsets.only(left: 48, bottom: 4),
                    children: [
                      ListTile(
                        leading: Icon(Icons.list_alt_outlined),
                        title: Text('Daftar'),
                        onTap: () {
                          onNavigate(const MutasiDaftarPage());
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.add_circle_outline),
                        title: Text('Tambah'),
                        onTap: () {
                          onNavigate(const MutasiTambah());
                        },
                      ),
                    ],
                  ),

                  // LOG
                  ExpansionTile(
                    leading: Icon(Icons.history_outlined),
                    title: Text('Log Aktifitas'),
                    childrenPadding: EdgeInsets.only(left: 48, bottom: 4),
                    children: [
                      ListTile(
                        leading: Icon(Icons.timeline_outlined),
                        title: Text('Semua Aktifitas'),
                        onTap: () {
                          onNavigate(const semuaAktifitas());
                        },
                      ),
                    ],
                  ),

                  // USER MANAGEMENT
                  ExpansionTile(
                    leading: Icon(Icons.admin_panel_settings_outlined),
                    title: Text('Manajemen Pengguna'),
                    childrenPadding: EdgeInsets.only(left: 48, bottom: 4),
                    children: [
                      ListTile(
                        leading: Icon(Icons.people_alt_outlined),
                        title: Text('Daftar Pengguna'),
                        onTap: () {
                          onNavigate(const daftarPenggunaPage());
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.person_add_alt_1_outlined),
                        title: Text('Tambah Pengguna'),
                        onTap: () {
                          onNavigate(const tambahPenggunaPage());
                        },
                      ),
                    ],
                  ),

                  // CHANNEL TRANSFER
                  ExpansionTile(
                    leading: Icon(Icons.sync_alt_outlined),
                    title: Text('Channel Transfer'),
                    childrenPadding: EdgeInsets.only(left: 48, bottom: 4),
                    children: [
                      ListTile(
                        leading: Icon(Icons.device_hub_outlined),
                        title: Text('Daftar Channel'),
                        onTap: () {
                          onNavigate(const daftarChannelPage());
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.add_link_outlined),
                        title: Text('Tambah Channel'),
                        onTap: () {
                          onNavigate(const tambahChannelPage());
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: PopupMenuButton<int>(
                offset: const Offset(0, -110), // controls popup position
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    enabled: false,
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.indigo,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Admin Jawara',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'admin1@gmail.com',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: const [
                        Icon(Icons.logout_outlined, color: Colors.black54),
                        SizedBox(width: 8),
                        Text('Log out'),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 1) {
                    Navigator.pushReplacement(context, 
                      MaterialPageRoute(builder: (context) => const MainLayout()),
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.indigo,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Admin Jawara',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              'admin1@gmail.com',
                              style: TextStyle(fontSize: 13, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black54),
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
