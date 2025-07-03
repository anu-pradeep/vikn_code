import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'colors.dart';

class RevenueChart extends StatelessWidget {
  const RevenueChart({super.key});

  @override
  Widget build(BuildContext context) {
    final List<RevenueData> chartData = [
      RevenueData('01', 0),
      RevenueData('02', 1000),
      RevenueData('03', 3200),
      RevenueData('04', 2100),
      RevenueData('05', 1800),
      RevenueData('06', 2600),
      RevenueData('07', 2300),
      RevenueData('08', 3000),
    ];

    return SfCartesianChart(
      backgroundColor: Colors.transparent,
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        labelStyle:  TextStyle(
          color: CustomColors.whiteColor,
          fontSize: 10,
          fontFamily: 'PoppinsRegular',
        ),
        axisLine: AxisLine(color: CustomColors.whiteColor),
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        isVisible: false,
        minimum: 0,
        maximum: 4000,
      ),
      series: [
        SplineAreaSeries<RevenueData, String>(
          dataSource: chartData,
          xValueMapper: (RevenueData data, _) => data.day,
          yValueMapper: (RevenueData data, _) => data.amount,
          splineType: SplineType.natural,
          gradient: LinearGradient(
            colors: [Colors.blue.withOpacity(0.4), Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderColor: CustomColors.blueColor,
          borderWidth: 2,
        ),
      ],
    );
  }
}

class RevenueData {
  final String day;
  final double amount;

  RevenueData(this.day, this.amount);
}
