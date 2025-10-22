import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class KependudukanPage extends StatelessWidget {
  const KependudukanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      appBar: AppBar(
        title: const Text("Data Kependudukan"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Total Cards
            Row(
              children: [
                _buildInfoCard("Total Keluarga", "7", Colors.blue[100]!),
                const SizedBox(width: 8),
                _buildInfoCard("Total Penduduk", "9", Colors.green[100]!),
              ],
            ),
            const SizedBox(height: 10),

            // Status Penduduk
            _buildChartSection(
              title: "Status Penduduk",
              color: Colors.yellow[100]!,
              data: {"Aktif": 78, "Nonaktif": 22},
              colors: [Colors.green, Colors.brown],
            ),

            // Jenis Kelamin
            _buildChartSection(
              title: "Jenis Kelamin",
              color: Colors.purple[100]!,
              data: {"Laki-laki": 89, "Perempuan": 11},
              colors: [Colors.blue, Colors.red],
            ),

            // Pekerjaan
            _buildChartSection(
              title: "Pekerjaan Penduduk",
              color: Colors.pink[100]!,
              data: {"Lainnya": 100},
              colors: [Colors.deepPurple],
            ),

            // Peran dalam Keluarga
            _buildChartSection(
              title: "Peran dalam Keluarga",
              color: Colors.blue[100]!,
              data: {"Kepala Keluarga": 78, "Anak": 11, "Anggota Lain": 11},
              colors: [Colors.blue, Colors.pinkAccent, Colors.green],
            ),

            // Agama
            _buildChartSection(
              title: "Agama",
              color: Colors.red[100]!,
              data: {"Islam": 50, "Katolik": 50},
              colors: [Colors.blue, Colors.red],
            ),

            // Pendidikan
            _buildChartSection(
              title: "Pendidikan",
              color: Colors.teal[100]!,
              data: {"Sarjana/Diploma": 100},
              colors: [Colors.grey[700]!],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartSection({
    required String title,
    required Color color,
    required Map<String, double> data,
    required List<Color> colors,
  }) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 160,
              child: Row(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 25,
                        sections: _generatePieSections(data, colors),
                      ),
                    ),
                  ),
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        borderData: FlBorderData(show: false),
                        gridData: const FlGridData(show: false),
                        titlesData: const FlTitlesData(show: false),
                        barGroups: _generateBarGroups(data, colors),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _generatePieSections(
    Map<String, double> data,
    List<Color> colors,
  ) {
    int i = 0;
    return data.entries.map((e) {
      final color = colors[i % colors.length];
      i++;
      return PieChartSectionData(
        color: color,
        value: e.value,
        title: "${e.key}\n${e.value.toStringAsFixed(0)}%",
        radius: 45,
        titleStyle: const TextStyle(fontSize: 10, color: Colors.white),
      );
    }).toList();
  }

  List<BarChartGroupData> _generateBarGroups(
    Map<String, double> data,
    List<Color> colors,
  ) {
    int i = 0;
    return data.entries.map((e) {
      final color = colors[i % colors.length];
      i++;
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: e.value,
            color: color,
            width: 18,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }
}
