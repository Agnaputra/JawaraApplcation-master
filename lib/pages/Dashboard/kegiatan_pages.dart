import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class KegiatanPage extends StatelessWidget {
  const KegiatanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9fb),
      appBar: AppBar(
        title: const Text("Dashboard Kegiatan"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- Total Kegiatan ---
          _infoCard(
            title: "Total Kegiatan",
            value: "1",
            subtitle: "Jumlah seluruh event yang sudah ada",
            color: Colors.blue.withValues(alpha: 0.2),
            icon: Icons.event_available,
          ),

          const SizedBox(height: 12),

          // --- Kegiatan per Kategori (Pie Chart) ---
          _chartCard(
            title: "Kegiatan per Kategori",
            color: Colors.green.withValues(alpha: 0.2),
            chart: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    color: Colors.blue,
                    value: 50,
                    title: "Komunitas & Sosial",
                    radius: 60,
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          //Kegiatan berdasarkan Waktu
          _infoListCard(
            title: "Kegiatan berdasarkan Waktu",
            color: Colors.yellow.withValues(alpha: 0.3),
            icon: Icons.access_time,
            items: const [
              {"label": "Sudah Lewat", "value": "1"},
              {"label": "Hari Ini", "value": "0"},
              {"label": "Akan Datang", "value": "0"},
            ],
          ),

          const SizedBox(height: 12),

          //Penanggung Jawab Terbanyak
          _infoCard(
            title: "Penanggung Jawab Terbanyak",
            value: "Pak",
            subtitle: "1 kegiatan",
            color: Colors.purple.withValues(alpha: 0.1),
            icon: Icons.person,
          ),

          const SizedBox(height: 12),

          //Kegiatan per Bulan (Bar Chart)
          _chartCard(
            title: "Kegiatan per Bulan (Tahun Ini)",
            color: Colors.pink.withValues(alpha: 0.2),
            chart: BarChart(
              BarChartData(
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 10:
                            return const Text("Okt");
                          default:
                            return const Text("");
                        }
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                barGroups: [
                  BarChartGroupData(
                    x: 10,
                    barRods: [
                      BarChartRodData(
                        toY: 1,
                        color: Colors.pinkAccent,
                        width: 24,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Widget untuk Info Card
  Widget _infoCard({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.black54, size: 36),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Widget untuk Info List (seperti waktu kegiatan)
  Widget _infoListCard({
    required String title,
    required Color color,
    required IconData icon,
    required List<Map<String, String>> items,
  }) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.black54),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...items.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text("${e['label']}: ${e['value']}"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Widget untuk Chart Card
  Widget _chartCard({
    required String title,
    required Color color,
    required Widget chart,
  }) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            SizedBox(height: 180, child: chart),
          ],
        ),
      ),
    );
  }
}
