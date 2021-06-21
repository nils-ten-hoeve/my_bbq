import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphPage extends StatelessWidget {
  final List<_HeaterMeterData> data = [
    _HeaterMeterData('12:05', 107, 30, 10, 10, 10, 100),
    _HeaterMeterData('12:06', 107, 40, 11, 11, 11, 100),
    _HeaterMeterData('12:07', 107, 70, 12, 12, 12, 100),
    _HeaterMeterData('12:08', 107, 100, 13, 13, 13, 50),
    _HeaterMeterData('12:09', 107, 107, 14, 14, 14, 100)
  ];

  GraphPage();

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        //TODO zoomPanBehavior: ,
        // Chart title
        //title: ChartTitle(text: 'Half yearly sales analysis'),
        // Enable legend
        // legend: Legend(isVisible: true),
        // Enable tooltip
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <ChartSeries<_HeaterMeterData, String>>[
          AreaSeries<_HeaterMeterData, String>(
            dataSource: data,
            xValueMapper: (_HeaterMeterData data, _) => data.time,
            yValueMapper: (_HeaterMeterData data, _) => data.out,
            name: 'Out',
            // Enable data label
            //dataLabelSettings: DataLabelSettings(isVisible: false)
          ),
          LineSeries<_HeaterMeterData, String>(
            dataSource: data,
            xValueMapper: (_HeaterMeterData data, _) => data.time,
            yValueMapper: (_HeaterMeterData data, _) => data.pitTemperature,
            name: 'Pit Temperature',
            // Enable data label
            //dataLabelSettings: DataLabelSettings(isVisible: false)
          ),
          LineSeries<_HeaterMeterData, String>(
            dataSource: data,
            xValueMapper: (_HeaterMeterData data, _) => data.time,
            yValueMapper: (_HeaterMeterData data, _) =>
                data.setPointTemperature,
            name: 'Set Point Temperature',
            // Enable data label
            //dataLabelSettings: DataLabelSettings(isVisible: false)
          ),
          LineSeries<_HeaterMeterData, String>(
            dataSource: data,
            xValueMapper: (_HeaterMeterData data, _) => data.time,
            yValueMapper: (_HeaterMeterData data, _) => data.probe1Temperature,
            name: 'Probe 1 Temperature',
            // Enable data label
            //dataLabelSettings: DataLabelSettings(isVisible: false)
          ),
        ]);
  }
}

class _HeaterMeterData {
  _HeaterMeterData(
      this.time,
      this.setPointTemperature,
      this.pitTemperature,
      this.probe1Temperature,
      this.probe2Temperature,
      this.probe3Temperature,
      this.out);

  final String time;
  final double setPointTemperature;
  final double pitTemperature;
  final double probe1Temperature;
  final double probe2Temperature;
  final double probe3Temperature;
  final double out;
}
