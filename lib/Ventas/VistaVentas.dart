import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';
import 'package:paleteria_marfel/Producci%C3%B3n/VistaProduccion.dart';
import 'package:paleteria_marfel/Ventas/NuevaVenta.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:paleteria_marfel/Ventas/productos_ventas.dart';
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

    return json.decode(response.body)['data']['moldes'];
  }

  @override
  void initState() {
    getInventario().then((body) {
      inventario = body;
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
            backgroundColor: colorPrincipal,
            elevation: 0,
            title: Text("Ventas"),
            centerTitle: true,
            actions: [
              Stack(
                children: <Widget>[
                  IconBadge(
                    icon: Icon(
                      Icons.shopping_cart,
                      size: width * .07,
                      color: Colors.white,
                    ),
                    itemCount: 3,
                    badgeColor: Colors.red,
                    itemColor: colorPrincipal,
                    hideZero: true,
                    onTap: () {
                      print(carrito);
                      totalfinal = 0;
                      showModalBottomSheet(
                          builder: (BuildContext context) {
                            return Container(
                              width: width,
                              height: height * 5 / 6,
                            );
                          },
                          context: context);
                    },
                  ),
                ],
              ),
            ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        drawer: CustomAppbar(),
        body: _tableCards());
  }

  Widget _tableCards() {
    return ListView(children: [
      //CardMolde(title: inventario[0]['nombre'], img: inventario[0]['img']),

      CurvedListItem(
        title: 'Helado',
        time: '',
        asset: "assets/heladoPor.png",
        color: colorPrincipal,
        nextColor: Colors.white,
        press: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SalesProducts(
                    categoria: "Helado",
                  )));
        },
      ),
      CurvedListItemWhite(
        title: 'Bolis',
        time: '',
        asset: "assets/boliPor.jpg",
        color: Colors.white,
        nextColor: colorPrincipal,
        press: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SalesProducts(
                    categoria: "Bolis",
                  )));
        },
      ),
      CurvedListItem(
        title: 'Sandwich',
        time: '',
        asset: "assets/sandPor.jpg",
        color: colorPrincipal,
        nextColor: Colors.white,
        press: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SalesProducts(
                    categoria: "Sandwich",
                  )));
        },
      ),
      CurvedListItemWhite(
        title: 'Troles',
        time: '',
        asset: "assets/trolPor.jpg",
        color: Colors.white,
        nextColor: colorPrincipal,
        press: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SalesProducts(
                    categoria: "Troles",
                  )));
        },
      ),
    ]);
  }
}
