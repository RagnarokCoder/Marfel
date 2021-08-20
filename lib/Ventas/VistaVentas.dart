import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';
import 'package:paleteria_marfel/Ventas/Carrito.dart';
import 'dart:convert';
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

int cantidadlimite = 10;
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
                      size: 22,
                      color: Colors.white,
                    ),
                    itemCount: carrito.length,
                    badgeColor: Colors.red,
                    itemColor: colorPrincipal,
                    hideZero: true,
                    onTap: () {
                      print(carrito);
                      totalfinal = 0;
                      buildCarrito(context);
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

  buildCarrito(BuildContext context) {
    YudizModalSheet.show(
        context: context,
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .66,
            child: Orden(),
          );
        }),
        direction: YudizModalSheetDirection.BOTTOM);
  }

  Widget _tableCards() {
    return ListView(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * .82,
          child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("Molde").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Image.asset("assets/marfelLoad.gif"),
                  );
                }
                int length = snapshot.data.docs.length;
                return GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, //columnas
                    mainAxisSpacing: 10.0, //espacio entre cards
                    crossAxisSpacing: 10,
                    childAspectRatio: 1, // largo de la card
                  ),
                  itemCount: length,
                  itemBuilder: (BuildContext context, int index) {
                    final DocumentSnapshot doc = snapshot.data.docs[index];
                    print(doc.toString());
                    if (doc.data()['img'] != null) {
                      return Molde(
                        title: doc.data()['nombre'],
                        img: doc.data()['img'],
                        function: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SalesProducts(
                                    categoria: doc.data()['nombre'],
                                    usuario: widget.usuario,
                                  )));
                        },
                      );
                    }
                    return Molde(
                        title: doc.data()['nombre'],
                        img:
                            'http://atrilco.com/wp-content/uploads/2017/11/ef3-placeholder-image.jpg');
                  },
                );
              }),
        ),
      ],
    );
  }

  Future<void> getCarr() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('carrito') == null) prefs.setString('carrito', '[]');
    String carr = prefs.getString('carrito');
    if (carr != '') carrito = json.decode(carr);
  }
}

class Molde extends StatelessWidget {
  final String title;
  final Function function;
  final String img;
  const Molde({
    Key key,
    @required this.title,
    @required this.img,
    this.function,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return InkWell(
        onTap: function,
        child: Container(
          width: width * .4,
          height: width * .4,
          margin: EdgeInsets.all(10),
          child: Material(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            elevation: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        margin: EdgeInsets.only(right: 10),
                        child: IconButton(
                          icon: Icon(
                            Icons.check,
                            color: colorPrincipal,
                          ),
                          onPressed: () {},
                        ))
                  ],
                ),
                Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: width * .25,
                    child: Image(image: NetworkImage(img))),
                Container(child: Text(title)),
              ],
            ),
          ),
        ));
  }
}
