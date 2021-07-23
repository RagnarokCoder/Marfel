import 'dart:math';

import 'package:flutter/material.dart';
import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';
import 'package:paleteria_marfel/Graficas/VistaGraficas2.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class VistaGraficas extends StatefulWidget {
  final String usuario;
  VistaGraficas({Key key, this.usuario}) : super(key: key);
  @override
  _VistaGraficasState createState() => _VistaGraficasState();
}

class _VistaGraficasState extends State<VistaGraficas> {
  List<charts.Series> seriesList;
  String dropdownValue;
  static List<charts.Series<Sales, String>> _createRandomData() {
    final random = Random();

    final desktopSalesData = [
      Sales('Vainilla', random.nextInt(100)),
      Sales('Limón', random.nextInt(100)),
      Sales('Beso de Angel', random.nextInt(100)),
      Sales('Chocolate', random.nextInt(100))
    ];

    final tabletSalesData = [
      Sales('Vainilla', random.nextInt(100)),
      Sales('Limón', random.nextInt(100)),
      Sales('Beso de Angel', random.nextInt(100)),
      Sales('Chocolate', random.nextInt(100)),
   
    ];

    final mobileSalesData = [
      Sales('Vainilla', random.nextInt(100)),
      Sales('Limón', random.nextInt(100)),
      Sales('Beso de Angel', random.nextInt(100)),
      Sales('Chocolate', random.nextInt(100)),
     
    ];

    return [
      charts.Series<Sales, String>(
        id: 'Sales',
        domainFn: (Sales sales, _) => sales.year,
        measureFn: (Sales sales, _) => sales.sales,
        data: desktopSalesData,
        fillColorFn: (Sales sales, _) {
          return charts.MaterialPalette.blue.shadeDefault;
        },
      ),
      charts.Series<Sales, String>(
        id: 'Sales',
        domainFn: (Sales sales, _) => sales.year,
        measureFn: (Sales sales, _) => sales.sales,
        data: tabletSalesData,
        fillColorFn: (Sales sales, _) {
          return charts.MaterialPalette.gray.shadeDefault;
        },
      ),
      charts.Series<Sales, String>(
        id: 'Sales',
        domainFn: (Sales sales, _) => sales.year,
        measureFn: (Sales sales, _) => sales.sales,
        data: mobileSalesData,
        fillColorFn: (Sales sales, _) {
          return charts.MaterialPalette.blue.shadeDefault;
        },
      )
    ];
  }

  @override
  void initState() {
    super.initState();
    seriesList = _createRandomData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrincipal,
        elevation: 5,
        title: Text("Graficas"),
        centerTitle: true,
          actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.info,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => VistaGraficas2()),
                                    );
                },
              )
            ],
        
      ),
      drawer: CustomAppBar(usuario: widget.usuario,),
      body: ListView(
        children: [
          Container(
              child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(15),
            elevation: 10,
            child: Column(
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.fromLTRB(45, 10, 25, 0),
                  title: Text(
                    '223K',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  subtitle: Text(
                    'Ganancias del mes',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  trailing: Icon(
                    Icons.info,
                    color: colorPrincipal,
                    size: 40,
                  ),
                ),
              ],
            ),
          )),
          Container(
              height: 160,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.all(15),
                elevation: 10,
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(25, 10, 0, 0),
                      child: CircularPercentIndicator(
                        progressColor: Colors.pinkAccent[100],
                        percent: 0.5,
                        animation: true,
                        radius: 100.0,
                        lineWidth: 15.0,
                        circularStrokeCap: CircularStrokeCap.round,
                        center: Text(
                          "80%",
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(30, 40, 0, 0),
                          child: Text(
                            "Inventario",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          child: Text(
                            "12/03/2021",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )),
          Container(
              child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(15),
            elevation: 10,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 230, 0),
                  child: Text(
                    "Productos",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Row(children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 20, 0),
                    child: Text(
                      "Información sobre cada producto",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  DropdownButton<String>(
                      value: dropdownValue,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 25,
                      underline: SizedBox(),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      items: <String>['One', 'Two', 'Three', 'Four']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,style: TextStyle(color: Colors.black),),
                        );
                      }).toList()),
                ]),
                Container(
                    height: 300,
                    padding: EdgeInsets.all(20),
                    child: charts.BarChart(
                      seriesList,
                      animate: true,
                      vertical: true,
                      barGroupingType: charts.BarGroupingType.grouped,
                      defaultRenderer: charts.BarRendererConfig(
                        groupingType: charts.BarGroupingType.grouped,
                        strokeWidthPx: 1.0,
                      ),
                      domainAxis: charts.OrdinalAxisSpec(),
                    )),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class Sales {
  final String year;
  final int sales;

  Sales(this.year, this.sales);
}
