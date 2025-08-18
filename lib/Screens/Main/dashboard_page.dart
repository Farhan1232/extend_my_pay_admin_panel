import 'package:extend_my_pay_admin_panel/Model/bill_model.dart';
import 'package:extend_my_pay_admin_panel/Provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:extend_my_pay_admin_panel/Widgets/admin_layout.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<BillModel> allBills = [];

  num totalPaidAmount = 0;
  int approvedCount = 0;
  int rejectedCount = 0;
  int totalBills = 0;

  bool isLoading = true;
  String selectedRange = 'Week';
  final List<String> timeRanges = ['Day', 'Week', 'Month', 'Year'];

  @override
  void initState() {
    super.initState();
    fetchBills();
  }

  Future<void> fetchBills() async {
    final snapshot = await FirebaseFirestore.instance.collection('bills').get();

    final bills = snapshot.docs
        .map((doc) => BillModel.fromMap(doc.data(), doc.id))
        .toList();

    setState(() {
      allBills = bills;
      totalBills = bills.length;
      approvedCount = bills.where((bill) => bill.status == 'approved').length;
      rejectedCount = bills.where((bill) => bill.status == 'rejected').length;
      totalPaidAmount = bills
          .where((bill) => bill.paid == true)
          .fold(0, (sum, bill) => sum + bill.dueAmount);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      screenTitle: "Dashboard",
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButton<String>(
                    value: selectedRange,
                    items: timeRanges.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedRange = newValue!;
                      });
                    },
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Welcome to your admin dashboard",
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  _buildMetricsGrid(),
                  SizedBox(height: 30.h),
                  _buildProfileStatusSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildMetricsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildMetricCard("Total Bills", totalBills.toString(), _buildGroupedBarChart())),
            SizedBox(width: 16.w),
            Expanded(child: _buildMetricCard("Approved Bills", approvedCount.toString(), _buildPieChartWithLegend())),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(child: _buildMetricCard("Rejected Bills", rejectedCount.toString(), _buildMultiLineChart())),
            SizedBox(width: 16.w),
            Expanded(child: _buildMetricCard("Total Paid", "\$${totalPaidAmount.toStringAsFixed(2)}", _buildVolumeChart())),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileStatusSection() {
    return Consumer<ProfileProvider>(
      builder: (context, prov, _) {
        if (prov.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final approved = prov.approvedCount;
        final rejected = prov.rejectedCount;
        final pending = prov.pendingCount;
        final total = approved + rejected + pending;

        return Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                "User Profiles",
                "$total total",
                _buildLineAreaChart(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMetricCard(String title, String value, Widget chart) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 4,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.grey[700])),
          SizedBox(height: 8.h),
          Text(value, style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: const Color(0xFFFF941A))),
          SizedBox(height: 20.h),
          SizedBox(height: 120.h, child: chart),
        ],
      ),
    );
  }

  List<FlSpot> getMockLineData() {
    switch (selectedRange) {
      case 'Day':
        return [FlSpot(0, 2), FlSpot(1, 2.2), FlSpot(2, 2.4)];
      case 'Month':
        return [FlSpot(0, 1), FlSpot(1, 3), FlSpot(2, 2.5), FlSpot(3, 4)];
      case 'Year':
        return [FlSpot(0, 1.5), FlSpot(1, 2), FlSpot(2, 2.8), FlSpot(3, 3.3), FlSpot(4, 4)];
      case 'Week':
      default:
        return [FlSpot(0, 1), FlSpot(1, 2), FlSpot(2, 1.5), FlSpot(3, 3)];
    }
  }

  Widget _buildGroupedBarChart() {
    return BarChart(
      BarChartData(
        barGroups: [
          BarChartGroupData(x: 0, barRods: [
            BarChartRodData(toY: 20, color: Colors.blue, width: 6.w),
            BarChartRodData(toY: 14, color: Colors.orange, width: 6.w),
            BarChartRodData(toY: 10, color: Colors.green, width: 6.w),
          ])
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  Widget _buildPieChartWithLegend() {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(value: approvedCount.toDouble(), color: Colors.green, radius: 40.r, title: ''),
          PieChartSectionData(value: rejectedCount.toDouble(), color: Colors.red, radius: 40.r, title: ''),
        ],
        sectionsSpace: 2,
        centerSpaceRadius: 30,
      ),
    );
  }

  Widget _buildMultiLineChart() {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: getMockLineData(),
            isCurved: true,
            color: Color.fromARGB(255, 235, 4, 4),
            barWidth: 3.w,
            dotData: FlDotData(show: false),
          ),
          LineChartBarData(
            spots: getMockLineData().reversed.toList(),
            isCurved: true,
            color: Color.fromARGB(255, 39, 7, 221),
            barWidth: 3.w,
            dotData: FlDotData(show: false),
          )
        ],
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  Widget _buildVolumeChart() {
    return BarChart(
      BarChartData(
        barGroups: [
          for (int i = 0; i < 5; i++)
            BarChartGroupData(x: i, barRods: [
              BarChartRodData(toY: (i + 1) * (selectedRange == 'Year' ? 10.0 : selectedRange == 'Month' ? 8.0 : 5.0), color: Colors.deepPurple, width: 10.w)
            ])
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  Widget _buildLineAreaChart() {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: getMockLineData(),
            isCurved: true,
            color: Color.fromARGB(255, 223, 245, 125).withOpacity(0.5),
            belowBarData: BarAreaData(show: true, color: Color(0xFFFF941A).withOpacity(0.3)),
            barWidth: 3.w,
            dotData: FlDotData(show: false),
          ),
        ],
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}