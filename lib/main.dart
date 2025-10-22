import 'package:flutter/material.dart';
import 'pages/dashboard_page.dart';
import 'widgets/sidebar.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting(
    'id_ID',
    null,
  ); // Contoh untuk bahasa Indonesia
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistem RT RW',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const MainLayout(),
    );
  }
}

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  Widget _currentPage = const DashboardPage();

  void _navigateTo(Widget page) {
    setState(() {
      _currentPage = page;
    });
    Navigator.pop(context); // Tutup drawer saat navigasi
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      drawer: SideBar(
        onNavigate: _navigateTo,
      ), // Sidebar terpisah di widgets/sidebar.dart
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _currentPage,
      ),
      // Floating action button removed for penerimaanWargaPage: navigation
      // to the add page is done via the 'Tambah' button in the page itself.
      floatingActionButton: null,
    );
  }
}
