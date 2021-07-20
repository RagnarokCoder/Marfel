

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:paleteria_marfel/Graficas/ProduccionTotal.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Produccion extends StatefulWidget {
  @override
  _ProduccionState createState() => _ProduccionState();
}

String _date = "Selecciona una fecha";
int currentPage = 1;
List produccion = [];
List filteredProduccion = [];
List sabordepaleta = [];
String producto;

var totaldeunsabor = 0;
var totaldeunsabor2 = 0;
String dia = "";
String mes = "";
String year = "";
List nombredepaletas = [];

List totaldepaletas = [];

class _ProduccionState extends State<Produccion> {
  getInventario() async {
    var url = 'https://api-paleteria-marfel.herokuapp.com/api/v1/production';
    final response = await http.get(url, headers: {
      'content-type': 'application/json',
      'Accept': 'application/json',
    });

    return json.decode(response.body)['data']['production'];
  }

  @override
  void initState() {
    getInventario().then((body) {
      produccion = filteredProduccion = body;


      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
           Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProduccionTotal()),
                                    );
        },
        child: Icon(
          Icons.inventory,
          size: 26.0,
        ),
      )
    ),
        ],
        backgroundColor: colorPrincipal,
        elevation: 5,
        title: Text("Detalles"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _selector(),
          Container(
              margin: EdgeInsets.only(bottom: 20, left: 100, right: 100),
              child: Text(
                "Total de paletas: " + totaldeunsabor.toString(),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              )),
          Container(
              margin: EdgeInsets.only(bottom: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 60.0,
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              theme: DatePickerTheme(
                                  containerHeight: 210.0,
                                  backgroundColor: Colors.white),
                              minTime: DateTime(1900, 1, 1),
                              maxTime: DateTime.now(), onConfirm: (date) {
                            print('confirm $date');
                            _date = '${date.day}/${date.month}/${date.year}';
                            setState(() {
                              dia = date.day.toString();
                              mes = date.month.toString();
                              year = date.year.toString();
                              filteredProduccion = produccion
                                  .where((country) => country['Sabor'].contains(
                                      produccion[currentPage]["Sabor"]))
                                  .where((country) =>
                                      country['Dia'].toString().contains(dia))
                                  .where((country) =>
                                      country['Mes'].toString().contains(mes))
                                  .where((country) =>
                                      country['Año'].toString().contains(year))
                                  .toList();
                            });
                          }, currentTime: DateTime.now());
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "  $_date",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17.0,
                                              fontStyle: FontStyle.normal),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Icon(
                                Icons.date_range,
                                color: Colors.black45,
                              )
                            ],
                          ),
                        ),
                        color: Colors.white,
                      ),
                    ),
                    // datetime()
                  ],
                ),
              )),
          Container(
            margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Sabor",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Text(
                  "Cantidad",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Text(
                  "Molde",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Text(
                  "Fecha",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            padding: EdgeInsets.all(1),
            child: filteredProduccion.length > 0
                ? ListView.builder(
                    itemCount: filteredProduccion.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                          padding: EdgeInsets.all(7.0),
                          child: Container(
                              height: MediaQuery.of(context).size.height * 0.05,
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(5),
                                        child: Text(
                                          filteredProduccion[index]['Sabor'],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.all(5),
                                        child: Text(
                                          filteredProduccion[index]['Cantidad']
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.all(5),
                                        child: Text(
                                          filteredProduccion[index]['Molde']
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.all(5),
                                        child: Text(
                                          filteredProduccion[index]['Dia']
                                                  .toString() +
                                              "/" +
                                              filteredProduccion[index]['Mes']
                                                  .toString() +
                                              "/" +
                                              filteredProduccion[index]['Año']
                                                  .toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                      height: 5, color: Colors.grey.shade600)
                                ],
                              )));
                    })
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                height: 200,
                width: 350,
                child: SfCartesianChart(
                  isTransposed: false,
                  primaryXAxis: CategoryAxis(),
                  primaryYAxis: NumericAxis(),
                  series: <ChartSeries>[
                    ColumnSeries<SalesData, String>(
                        dataSource: getColumnData(),
                        xValueMapper: (SalesData sales, _) => sales.x,
                        yValueMapper: (SalesData sales, _) => sales.y,
                        sortingOrder: SortingOrder.ascending,
                        sortFieldValueMapper: (SalesData data, _) => data.y,
                        width: .1,
                        pointColorMapper: (SalesData sales, _) => Colors.black,
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                        ))
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget _pageItem(String name, dynamic position) {
    var _alignment;
    final selected = TextStyle(
      fontSize: 25.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
    final unselected = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.normal,
      color: Colors.black.withOpacity(0.4),
    );

    if (position == currentPage) {
      _alignment = Alignment.center;
    } else if (position > currentPage) {
      _alignment = Alignment.centerRight;
    } else {
      _alignment = Alignment.centerLeft;
    }

    return Align(
      alignment: _alignment,
      child: Text(
        name,
        style: position == currentPage ? selected : unselected,
      ),
    );
  }

  Widget _selector() {
    return SizedBox.fromSize(
      size: Size.fromHeight(70.0),
      child: PageView(
        onPageChanged: (newPage) {
          setState(() {
            currentPage = newPage;

            filteredProduccion = produccion
                .where((country) =>
                    country['Sabor'].contains(produccion[currentPage]["Sabor"]))
                .toList();

            totaldeunsabor = 0;
            for (int i = 0; i < filteredProduccion.length; i++) {
              totaldeunsabor += filteredProduccion[i]["Cantidad"];
            }
          });
        },
        children: <Widget>[
          for (int i = 0; i < produccion.length; i++)
            _pageItem(produccion[i]["Sabor"].toString(), i)
        ],
      ),
    );
  }
}

class SalesData {
  String x;
  dynamic y;
  SalesData(this.x, this.y);
}

dynamic getColumnData() {
  List<SalesData> columnData = <SalesData>[
    for (int i = 0; i < filteredProduccion.length; i++)
      SalesData(filteredProduccion[i]["Dia"].toString(),
          filteredProduccion[i]["Cantidad"]),
  ];

  return columnData;
}
