import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icon_badge/icon_badge.dart';

import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';
import 'package:paleteria_marfel/Producci%C3%B3n/VistaProduccion.dart';
import 'package:paleteria_marfel/Ventas/Carrito.dart';
import 'package:paleteria_marfel/Ventas/NuevaVenta.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:yudiz_modal_sheet/yudiz_modal_sheet.dart';
import 'productos_ventas.dart';

class VistaVentas extends StatefulWidget {
  final String usuario;
  VistaVentas({Key key, this.usuario}) : super(key: key);
  @override
  _VistaVentasState createState() => _VistaVentasState(usuario: usuario);
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

class _VistaVentasState extends State<VistaVentas> {
  final String usuario;
  _VistaVentasState({this.usuario});

  @override
  Widget build(BuildContext context) {
    getCarr();
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
                              height: height * 6 / 7,
                              child: Orden(),
                            );
                          },
                          context: context);
                    },
                  ),
                ],
              ),
            ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        drawer: CustomAppBar(
          usuario: widget.usuario,
        ),
        body: _tableCards());
  }

  Widget _tableCards() {
    return ListView(children: [
      CurvedListItemWhite(
        title: 'Paletas',
        time: '',
        asset: "assets/paletaPor.jpg",
        color: Colors.white,
        nextColor: colorPrincipal,
        press: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SalesProducts(
                    categoria: "Paleta",
                    usuario: usuario,
                  )));
        },
      ),
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

  Future<void> getCarr() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('carrito') == null) prefs.setString('carrito', '[]');
    String carr = prefs.getString('carrito');
    if (carr != '') carrito = json.decode(carr);
  }
}
