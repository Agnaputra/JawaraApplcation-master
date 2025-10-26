# jawaraapllication

Pembagian Jobdesk 
1. Dashboard all + Laporan keuangan (6 fitur) Erwan Majid
2. Data Warga + pengeluaran (7 fitur) Ridho Anfaal
3. Pemasukan + pesan warga (6 fitur) Aqilla Aprily
4. kegiatan & Broadcast+ mutasi keluarga (6 fitur) Agna Putra Prawira
5. penerimaan warga +log aktivitas + manajemen pengguna + chanel transfer (6 fitur) Charellino Kalingga Sadewo

***

## STATUS FITUR - AGNA PUTRA PRAWIRA (KEGIATAN & BROADCAST, MUTASI KELUARGA)

Berikut adalah daftar fungsionalitas yang telah diimplementasikan dalam modul ini, menggunakan **data dummy** dan skema warna **ungu tua solid** (Colors.deepPurple) untuk konsistensi UI.

### I. Kegiatan & Broadcast

| Feature | Goal | Implementation Details|
| :--- | :--- | :--- |
| **Daftar Broadcast** |  Views the history of announcements sent to residents. | Tampilan Card List yang responsif dengan mekanisme Expand/Collapse (setState). Filter diimplementasikan dengan ikon solid (Icons.filter_list). Dilengkapi aksi **Detail** (menuju halaman baru) dan **Edit** (menuju form edit). |
| **Tambah Broadcast** |  Creates and sends new announcements (including attachments). | Complete. The form is fully functional for Title, Message Content, and features file upload simulation (photos/documents). UI is consistent with the solid dark purple theme. |
| **Daftar Kegiatan** |  Manages the record of community events and meetings. | Complete & Modern UI. Implemented as an interactive Card List. Shows activity name, coordinator, and date. Supports Detail and Edit actions for maintenance. |
| **Tambah Kegiatan** |  Records details for new events. | Complete. A structured input form for Name, Category, Date (using DatePicker), Location, Coordinator, and Description. All form elements and action buttons use the solid dark purple theme. |

### II. Mutasi Keluarga

| Feature | Goal | Implementation Details |
| :--- | :--- | :--- |
| **Daftar Mutasi** |  Views the history of family move-in or move-out records. | Complete & Detailed. Implemented as an interactive Card List. The expanded section displays comprehensive transfer details, including Transfer Type, Family Name, Date, Reason, New/Old Address, and Reference Letter Number. The Edit button was removed as requested. |
| **Tambah Mutasi** |  Registers a new family transfer event. | Complete. A comprehensive input form for recording Transfer Type, Family, Transfer Date (with DatePicker), and Reason. The form styling is integrated with the project's consistent dark purple theme. |

