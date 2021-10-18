import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:paleteria_marfel/Grafica_Gastos/gasto_grafica.dart';
import 'package:paleteria_marfel/Grafica_ventas/venta_grafica.dart';
import 'package:paleteria_marfel/Graficas/GraficaGastos.dart';
import 'package:paleteria_marfel/HexaColors/HexColor.dart';
import 'package:fl_chart/fl_chart.dart';

class VistaGraficas2 extends StatefulWidget {
  final String usuario;
  VistaGraficas2({Key key, this.title, this.usuario}) : super(key: key);
  final String title;

  @override
  _VistaGraficas2State createState() => _VistaGraficas2State();
}

dynamic totalVentas = 0;
dynamic totalEmpleados = 0;
dynamic totalClientes = 0;
dynamic totalGastos = 0;
dynamic totalCompras = 0;
dynamic totalMenos = 0;
dynamic totalGanancias = 0;
Color colorPrincipal = HexColor("#3C9CA8");
NumberFormat f = new NumberFormat("#,##0.00", "es_US");

class _VistaGraficas2State extends State<VistaGraficas2> {
  final List<FlSpot> dummyData1 = [
    FlSpot(1, 1.4),
    FlSpot(2, 3.4),
    FlSpot(3, 2),
    FlSpot(4, 2.2),
    FlSpot(5, 1.8),
  ];

  @override
  void initState() {
    super.initState();
    //ventas
    FirebaseFirestore.instance
        .collection("Ventas")
        .where("Dia", isEqualTo: DateTime.now().day)
        .where("Mes", isEqualTo: DateTime.now().month)
        .where("Año", isEqualTo: DateTime.now().year)
        .snapshots()
        .listen((result) {
      totalVentas = 0;
      result.docs.forEach((result) {
        setState(() {
          totalVentas += result.data()['Total'];
        });
      });
    });
    //gastos
    FirebaseFirestore.instance
        .collection("Gastos")
        .where("Dia", isEqualTo: DateTime.now().day)
        .where("Mes", isEqualTo: DateTime.now().month)
        .where("Año", isEqualTo: DateTime.now().year)
        .snapshots()
        .listen((result) {
      totalGastos = 0;
      result.docs.forEach((result) {
        setState(() {
          totalGastos += result.data()['Cantidad'];
        });
      });
    });
    //Compras
    FirebaseFirestore.instance
        .collection("Compras")
        .where("Dia", isEqualTo: DateTime.now().day)
        .where("Mes", isEqualTo: DateTime.now().month)
        .where("Año", isEqualTo: DateTime.now().year)
        .snapshots()
        .listen((result) {
      totalCompras = 0;
      result.docs.forEach((result) {
        setState(() {
          totalCompras += result.data()['Costo'];
        });
      });
    });
    //trabajadores
    FirebaseFirestore.instance
        .collection("Empleados")
        .snapshots()
        .listen((result) {
      totalEmpleados = 0;
      result.docs.forEach((result) {
        setState(() {
          totalEmpleados += 1;
        });
      });
    });
    //clientes
    FirebaseFirestore.instance
        .collection("Clientes")
        .snapshots()
        .listen((result) {
      totalClientes = 0;
      result.docs.forEach((result) {
        setState(() {
          totalClientes += 1;
        });
      });
    });
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        totalMenos = totalGastos + totalCompras;
        totalGanancias = totalVentas - totalMenos;
      });
    });
  }

  Material myTextItems(String title, String subtitle) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: TextStyle(
                          fontSize: 20.0,
                          color: colorPrincipal,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      subtitle,
                      style: TextStyle(fontSize: 18.0, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Material myCircularItems(String title, String subtitle) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: TextStyle(
                          fontSize: 20.0,
                          color: colorPrincipal,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      subtitle,
                      style: TextStyle(fontSize: 18.0, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Material mychart1Items(String title, String priceVal, String subtitle) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(
                      title,
                      style: TextStyle(
                          fontSize: 20.0,
                          color: colorPrincipal,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(
                      priceVal,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.more_horiz, color: Colors.blueGrey),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Material mychart2Items(
      String title, String priceVal, Icon icon, String subtitle) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(
                      title,
                      style: TextStyle(
                          fontSize: 18.0,
                          color: colorPrincipal,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Row(
                        children: [
                          icon,
                          Text(
                            priceVal,
                            style:
                                TextStyle(fontSize: 15.0, color: Colors.black),
                          ),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.more_horiz, color: Colors.blueGrey),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: colorPrincipal,
        elevation: 5,
        title: Text("Graficas"),
        centerTitle: true,
      ),
      body: Container(
        color: Color(0xffE5E5E5),
        child: StaggeredGridView.count(
          crossAxisCount: 4,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          children: <Widget>[
            InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => venta_gastos()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: mychart1Items("Ventas Del Mes",
                      "\$${f.format(totalVentas)}", "Detalles"),
                )),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GraficaGastos()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: mychart1Items(
                    "Gastos Del Mes", "\$${f.format(totalMenos)}", "Detalles"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: myTextItems("Clientes", "$totalClientes"),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: myTextItems("Trabajadores", "$totalEmpleados"),
            ),
            InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LineChartSample1()),
                  );
                },
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: totalGanancias < 0
                        ? mychart2Items(
                            "Ganancias",
                            "\$${f.format(totalGanancias)}",
                            Icon(Icons.arrow_drop_down,
                                color: Colors.red.shade700),
                            "Detalles")
                        : mychart2Items(
                            "Ganancias",
                            "\$${f.format(totalGanancias)}",
                            Icon(Icons.arrow_drop_up,
                                color: Colors.green.shade700),
                            "Detalles"))),
          ],
          staggeredTiles: [
            StaggeredTile.extent(4, 250.0), //tamaño de cada widget
            StaggeredTile.extent(2, 250.0),
            StaggeredTile.extent(2, 115.0),
            StaggeredTile.extent(2, 115.0),
            StaggeredTile.extent(4, 200.0),
          ],
        ),
      ),
    );
  }
}
