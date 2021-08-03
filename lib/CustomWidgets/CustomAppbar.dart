import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paleteria_marfel/Clientes/VistaClientes.dart';
import 'package:paleteria_marfel/Compras/VistaComprasList.dart';
import 'package:paleteria_marfel/FirebaseAuth/Authentication_Service.dart';
import 'package:paleteria_marfel/Gastos/VistaGastos.dart';
import 'package:paleteria_marfel/Graficas/VistaGraficas.dart';
import 'package:paleteria_marfel/HexaColors/HexColor.dart';
import 'package:paleteria_marfel/Inventario/VistaInventario.dart';
import 'package:paleteria_marfel/InventarioStock/InventarioMp.dart';
import 'package:paleteria_marfel/Personal/VistaPersonal.dart';
import 'package:paleteria_marfel/Producci%C3%B3n/VistaProduccion.dart';
import 'package:paleteria_marfel/Ventas/VistaVentas.dart';
import 'package:provider/provider.dart';
import 'package:yudiz_modal_sheet/yudiz_modal_sheet.dart';


class CustomAppBar extends StatefulWidget {
  final String usuario;
  CustomAppBar({Key key, this.usuario}) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

Color colorPrincipal = HexColor("#80DEEA");
int tipoAcceso = 0;
String user;

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  void initState() {
    super.initState();

    var parts = widget.usuario.split("_");
    var prefix = parts[0].trim();

    print(prefix);

    if (widget.usuario.toString().toUpperCase() == "ADMIN@MARFEL.COM" ||
        widget.usuario.toString() == "$prefix" + "_admin@marfel.com") {
      tipoAcceso = 1;
      user = "Admin";
    }
    if (widget.usuario.toString().toUpperCase() == "VENTAS@MARFEL.COM" ||
        widget.usuario.toString() == "$prefix" + "_ventas@marfel.com") {
      tipoAcceso = 2;
      user = "Ventas";
    }
    if (widget.usuario.toString().toUpperCase() == "INVENTARIO@MARFEL.COM" ||
        widget.usuario.toString() == "$prefix" + "_inventario@marfel.com") {
      tipoAcceso = 3;
      user = "Inventario";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      
      children: <Widget>[
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.38,
          padding: EdgeInsets.only(left: 5, right: 5),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width * 0.65,
                  height: MediaQuery.of(context).size.height * 0.30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage('assets/marfelLogoProt.png',
                        
                        ),
                        fit: BoxFit.fill),
                  )),
            Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("${widget.usuario}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Text("$user",
                          ),
                          ],
                        )
                      )        
            ],
          )
        ),
        Divider(
                    height: 12,
                    color: colorPrincipal,
                    indent: 15,
                    endIndent: 15,
                    thickness: 0.7,
                  ),
        Container(
            height: MediaQuery.of(context).size.height * 0.81,
            color: Colors.white,
            child: Column(children: <Widget>[
              tipoAcceso == 1 || tipoAcceso == 2
                  ? ListTile(
                      leading:  Icon(FontAwesomeIcons.tag, color: Colors.black, size: 20),
                      title: Text('VENTAS',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: VistaVentas(
                                  usuario: widget.usuario,
                                )));
                      },
                    )
                  : SizedBox(),
              tipoAcceso == 1
                  ? ListTile(
                      leading: Icon(FontAwesomeIcons.shoppingBag, color: Colors.black, size: 20),
                      title: Text('COMPRAS',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: VistaCompraLista(
                                  usuario: widget.usuario,
                                )));
                      },
                    )
                  : SizedBox(),
                  tipoAcceso == 1
                  ? ListTile(
                      leading: Icon(FontAwesomeIcons.dollarSign, color: Colors.black, size: 20),
                      title: Text('GASTOS',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: VistaGastos(
                                  usuario: widget.usuario,
                                )));
                      },
                    )
                  : SizedBox(),
                  Divider(
                    height: 12,
                    color: colorPrincipal,
                    indent: 30,
                    endIndent: 30,
                    thickness: 1.1,
                  ),
              tipoAcceso == 1 || tipoAcceso == 3
                  ? ListTile(
                      leading: Icon(FontAwesomeIcons.box, color: Colors.black, size: 20),
                      title: Text('STOCK',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: InventarioMp(
                                  usuario: widget.usuario,
                                )));
                      },
                    )
                  : SizedBox(),
              
              tipoAcceso == 1 || tipoAcceso == 3
                  ? ListTile(
                      leading: Icon(FontAwesomeIcons.pallet, color: Colors.black, size: 20),
                      title: Text('INVENTARIO',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: VistaInventario(
                                  usuario: widget.usuario,
                                )));
                      },
                    )
                  : SizedBox(),
              tipoAcceso == 1
                  ? ListTile(
                      leading: Icon(FontAwesomeIcons.truckLoading, color: Colors.black, size: 20),
                      title: Text('PRODUCCIÓN',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: VistaProduccion(
                                  usuario: widget.usuario,
                                )));
                      },
                    )
                  : SizedBox(),
                  Divider(
                    height: 12,
                    color: colorPrincipal,
                    indent: 30,
                    endIndent: 30,
                    thickness: 1.1,
                  ),
              tipoAcceso == 1
                  ? ListTile(
                      leading: Icon(FontAwesomeIcons.chartArea, color: Colors.black, size: 20),
                      title: Text('GRAFICAS',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: VistaGraficas(
                                  usuario: widget.usuario,
                                )));
                      },
                    )
                  : SizedBox(),
              tipoAcceso == 1
                  ? ListTile(
                      leading: Icon(FontAwesomeIcons.userFriends, color: Colors.black, size: 20),
                      title: Text('CLIENTES',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: VistaClientes(
                                  usuario: widget.usuario,
                                )));
                      },
                    )
                  : SizedBox(),
              tipoAcceso == 1
                  ? ListTile(
                      leading: Icon(FontAwesomeIcons.peopleCarry, color: Colors.black, size: 20),
                      title: Text('PERSONAL',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: VistaPersonal(
                                  usuario: widget.usuario,
                                )));
                      },
                    )
                  : SizedBox(),
                  Divider(
                    height: 12,
                    color: colorPrincipal,
                    indent: 30,
                    endIndent: 30,
                    thickness: 1.1,
                  ),
              SizedBox(
                height: 25,
              ),

                   ListTile(
                      leading: Icon(FontAwesomeIcons.signOutAlt, color: Colors.black, size: 20),
                      title: Text('Cerrar Sesión',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      onTap: () {
                        cerrarSesion(context);
                      },
                    )
            ])),
      ],
    ));
  }

  cerrarSesion(BuildContext context) {
    YudizModalSheet.show(
        context: context,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50))),
          height: 100,
          child: Center(
              child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Text(
                "¿Desea Cerrar Sesión?",
                style: (TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton.icon(
                      color: Colors.transparent,
                      elevation: 0,
                      onPressed: () {
                        context.read<AuthenticationService>().signOut();

                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.check_circle,
                        color: colorPrincipal,
                      ),
                      label: Text(
                        "Confirmar",
                        style: TextStyle(color: Colors.black),
                      )),
                ],
              )
            ],
          )),
        ),
        direction: YudizModalSheetDirection.BOTTOM);
  }
}
