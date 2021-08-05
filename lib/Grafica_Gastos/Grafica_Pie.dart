
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';



class PieGraphWidget1 extends StatefulWidget {
  final List<double> data;

  const PieGraphWidget1({Key key, this.data}) : super(key: key);

  @override
  _PieGraphWidget1State createState() => _PieGraphWidget1State();
}

class _PieGraphWidget1State extends State<PieGraphWidget1> {
  
   @override
  Widget build(BuildContext context) {
    List<Series<double, num>> series = [
      Series<double, int>(
        id: 'Gasto',
        domainFn: (value, index) => index,
        measureFn: (value, _) => value,
        data: widget.data,
        strokeWidthPxFn: (_, __) => 4,
      )
    ];

    return PieChart(series);
  }
}


