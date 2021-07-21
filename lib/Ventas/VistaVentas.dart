import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';
import 'package:paleteria_marfel/Ventas/NuevaVenta.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yudiz_modal_sheet/yudiz_modal_sheet.dart';

class VistaVentas extends StatefulWidget {
  @override
  _VistaVentasState createState() => _VistaVentasState();
}

bool icono = false;
List inventario = [];
List productos = [];
List filteredInventario = [];
List filteredProductos = [];
int _currentValue = 0;
int cantidadlimite = 10;
String molde = "Selecciona...";
String sabor = "Selecciona...";
String preciosabor = "";
dynamic total = 0;
dynamic totalfinal = 0;
int cantidad;
int nuevaCantidadInventario = 0;
List<Map<String, dynamic>> carrito = [];

getProductos() async {
  var url = 'https://api-paleteria-marfel.herokuapp.com/api/v1/product';
  final response = await http.get(url, headers: {
    'content-type': 'application/json',
    'Accept': 'application/json',
  });

  return json.decode(response.body)['data']['productos'];
}

class _VistaVentasState extends State<VistaVentas> {
  getInventario() async {
    var url = 'https://api-paleteria-marfel.herokuapp.com/api/v1/molde';
    final response = await http.get(url, headers: {
      'content-type': 'application/json',
      'Accept': 'application/json',
    });

    print(json.decode(response.body)['data']['moldes']);

    return json.decode(response.body);
  }

  @override
  void initState() {
    getInventario().then((body) {
      inventario = filteredInventario = body;

      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrincipal,
        elevation: 0,
        title: Text("Ventas"),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      drawer: CustomAppbar(),
      body: ListView(
        children: [
          _tableCards(),
        ],
      ),
    );
  }

  Widget _tableCards() {
    List<TableRow> rows = [];
    for (int i = 0; i < inventario.length; i += 2) {
      if ((i + 1) < inventario.length) {
        rows.add(TableRow(children: [
          CardMolde(molde: inventario[i]),
          CardMolde(molde: inventario[i + 1]),
        ]));
      } else {
        rows.add(TableRow(children: [
          CardMolde(molde: inventario[i]),
          Container(),
        ]));
      }
    }
    return Table(children: rows);
  }
}

class CardMolde extends StatelessWidget {
  final Map<String, dynamic> molde;

  const CardMolde({Key key, @required this.molde}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
          color: colorPrincipal, borderRadius: BorderRadius.circular(20)),
      width: width * .4,
      height: width * .4,
      margin: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              width: width * .25, child: Image(image: NetworkImage(_getUrl()))),
          Text(molde['nombre'].toString()),
        ],
      ),
    );
  }

  String _getUrl() {
    if (molde['img'] != '') return molde['img'];
    return 'https://socialistmodernism.com/wp-content/uploads/2017/07/placeholder-image.png?w=640';
  }
}
