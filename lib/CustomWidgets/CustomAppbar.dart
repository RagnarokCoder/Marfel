import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paleteria_marfel/Clientes/VistaClientes.dart';
import 'package:paleteria_marfel/Compras/VistaComprasList.dart';
import 'package:paleteria_marfel/Gastos/VistaGastos.dart';
import 'package:paleteria_marfel/Graficas/VistaGraficas.dart';
import 'package:paleteria_marfel/HexaColors/HexColor.dart';
import 'package:paleteria_marfel/Inventario/VistaInventario.dart';
import 'package:paleteria_marfel/InventarioStock/InventarioMp.dart';
import 'package:paleteria_marfel/Personal/VistaPersonal.dart';
import 'package:paleteria_marfel/Producci%C3%B3n/VistaProduccion.dart';
import 'package:paleteria_marfel/Ventas/VistaVentas.dart';

Color colorPrincipal = HexColor("#80DEEA");

class CustomAppbar extends StatelessWidget {
  final String titulo;
  const CustomAppbar({
    Key key,
    this.titulo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.19,
          padding: EdgeInsets.only(left: 30, right: 30, top: 30),
          color: colorPrincipal,
          child: Center(
            child: Column(children: <Widget>[
              Container(
                  width: 150,
                  height: MediaQuery.of(context).size.height * 0.15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage('assets/icono_provisional.png'),
                        fit: BoxFit.fill),
                  )),
            ]),
          ),
        ),
        Container(
            height: MediaQuery.of(context).size.height * 0.81,
            color: colorPrincipal,
            child: Column(children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.shopping_cart_rounded,
                  size: 25,
                  color: Colors.white,
                ),
                title: Text('VENTAS',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white)),
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: VistaVentas()));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.shopping_bag_sharp,
                  size: 25,
                  color: Colors.white,
                ),
                title: Text('COMPRAS',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white)),
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: VistaCompraLista()));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.storage_outlined,
                  size: 25,
                  color: Colors.white,
                ),
                title: Text('Stock',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white)),
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: InventarioMp()));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.monetization_on,
                  size: 25,
                  color: Colors.white,
                ),
                title: Text('GASTOS',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white)),
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: VistaGastos()));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.inventory,
                  size: 25,
                  color: Colors.white,
                ),
                title: Text('INVENTARIO',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white)),
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: VistaInventario()));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.work,
                  size: 25,
                  color: Colors.white,
                ),
                title: Text('PRODUCCIÓN',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white)),
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: VistaProduccion()));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.bar_chart,
                  size: 25,
                  color: Colors.white,
                ),
                title: Text('GRAFICAS',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white)),
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: VistaGraficas()));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                  size: 25,
                  color: Colors.white,
                ),
                title: Text('CLIENTES',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white)),
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: VistaClientes()));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.supervised_user_circle,
                  size: 25,
                  color: Colors.white,
                ),
                title: Text('PERSONAL',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white)),
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: VistaPersonal()));
                },
              ),
              Spacer(),
              ListTile(
                trailing: Wrap(
                  spacing: 200, // space between two icons
                  children: <Widget>[
                    Icon(
                      Icons.settings,
                      size: 25,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.login_outlined,
                      size: 25,
                      color: Colors.white,
                    ),
                  ],
                ),
              )
            ])),
      ],
    ));
  }
}
