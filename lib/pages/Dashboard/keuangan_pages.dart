import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class KeuanganPage extends StatelessWidget {
  const KeuanganPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.compactCurrency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    // Dummy data
    final totalPemasukan = 50000000.0;
    final totalPengeluaran = 2112.0;
    final totalTransaksi = 5;

    final pemasukanBulanan = [
      {'bulan': 'Agu', 'total': 0},
      {'bulan': 'Okt', 'total': 50000000},
    ];

    final pengeluaranBulanan = [
      {'bulan': 'Okt', 'total': 2112},
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Dashboard Keuangan'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- Top Summary Cards ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _summaryCard(
                title: 'Total Pemasukan',
                value: '${currency.format(totalPemasukan)}',
                icon: Icons.trending_up,
                color: Colors.blue.withValues(alpha: 0.2),
              ),
              _summaryCard(
                title: 'Total Pengeluaran',
                value: '${currency.format(totalPengeluaran)}',
                icon: Icons.trending_down,
                color: Colors.green.withValues(alpha: 0.2),
              ),
              _summaryCard(
                title: 'Jumlah Transaksi',
                value: '$totalTransaksi',
                icon: Icons.receipt_long,
                color: Colors.yellow.withValues(alpha: 0.2),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // --- Pemasukan per Bulan ---
          _chartCard(
            title: ' Pemasukan per Bulan',
            color: Colors.blue.withValues(alpha: 0.05),
            chart: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        int index = value.toInt();
                        if (index >= 0 && index < pemasukanBulanan.length) {
                          return Text(
                            pemasukanBulanan[index]['bulan'].toString(),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                barGroups: pemasukanBulanan
                    .toList()
                    .asMap()
                    .entries
                    .map(
                      (e) => BarChartGroupData(
                        x: e.key,
                        barRods: [
                          BarChartRodData(
                            toY: (e.value['total'] as num).toDouble(),
                            color: Colors.blue,
                            width: 20,
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // --- Pengeluaran per Bulan ---
          _chartCard(
            title: ' Pengeluaran per Bulan',
            color: Colors.red.withValues(alpha: 0.05),
            chart: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        int index = value.toInt();
                        if (index >= 0 && index < pengeluaranBulanan.length) {
                          return Text(
                            pengeluaranBulanan[index]['bulan'].toString(),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                barGroups: pengeluaranBulanan
                    .toList()
                    .asMap()
                    .entries
                    .map(
                      (e) => BarChartGroupData(
                        x: e.key,
                        barRods: [
                          BarChartRodData(
                            toY: (e.value['total'] as num).toDouble(),
                            color: Colors.red,
                            width: 20,
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // --- Pemasukan Berdasarkan Kategori ---
          _chartCard(
            title: ' Pemasukan Berdasarkan Kategori',
            color: Colors.lightBlue.withValues(alpha: 0.1),
            chart: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: 100,
                    color: Colors.amber,
                    title: 'Pendapatan Lainnya',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // --- Pengeluaran Berdasarkan Kategori ---
          _chartCard(
            title: ' Pengeluaran Berdasarkan Kategori',
            color: Colors.green.withValues(alpha: 0.1),
            chart: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: 100,
                    color: Colors.orange,
                    title: 'Pemeliharaan Fasilitas',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget Kartu Ringkasan ---
  Widget _summaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: Colors.deepPurple),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget Card Chart ---
  Widget _chartCard({
    required String title,
    required Widget chart,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 12),
          SizedBox(height: 200, child: chart),
        ],
      ),
    );
  }
}
