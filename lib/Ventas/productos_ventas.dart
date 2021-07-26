import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';
import 'package:paleteria_marfel/Ventas/Carrito.dart';
import 'package:shared_preferences/shared_preferences.dart';

List carrito = [];

class SalesProducts extends StatefulWidget {
  final String categoria;
  const SalesProducts({Key key, @required this.categoria}) : super(key: key);

  @override
  _SalesProductsState createState() =>
      _SalesProductsState(categoria: categoria);
}

class _SalesProductsState extends State<SalesProducts> {
  final String categoria;
  int documents = 0;
  _SalesProductsState({this.categoria});

  @override
  void initState() {
    super.initState();
    setCarrito();
    FirebaseFirestore.instance
        .collection("Inventario")
        .snapshots()
        .listen((result) {
      documents = 0;
      result.docs.forEach((result) {
        setState(() {
          if (result.data()['Limitar'] != null &&
              result.data()['Categoria'] == categoria &&
              result.data()['Pendiente'] == true) {
            if (result.data()['Limitar'] < result.data()['Cantidad']) {
              documents = documents + 1;
            }
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title: Text(categoria),
          centerTitle: true,
          backgroundColor: colorPrincipal,
          actions: [
            Stack(
              children: <Widget>[
                IconBadge(
                  icon: Icon(
                    Icons.shopping_cart,
                    size: width * .07,
                    color: Colors.white,
                  ),
                  itemCount: 1,
                  badgeColor: Colors.red,
                  itemColor: colorPrincipal,
                  hideZero: true,
                  onTap: () {
                    showModalBottomSheet(
                        builder: (BuildContext context) {
                          return Container(
                            width: width,
                            height: height * 6 / 7,
                            child: Orden(delete: deleteCarrito()),
                          );
                        },
                        context: context);
                  },
                ),
              ],
            ),
          ]),
      drawer: CustomAppbar(),
      body: ListView(
        children: [
          _return(context),
          Container(
            height: height * .82,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Inventario")
                    .where("Categoria", isEqualTo: categoria)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("Cargando Productos...");
                  }
                  int length = snapshot.data.docs.length;
                  return GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, //columnas
                      mainAxisSpacing: 10.0, //espacio entre cards
                      crossAxisSpacing: 10,
                      childAspectRatio: 1, // largo de la card
                    ),
                    itemCount: length,
                    itemBuilder: (BuildContext context, int index) {
                      final DocumentSnapshot doc = snapshot.data.docs[index];
                      print(doc.toString());
                      if (doc.data()['Imagen'] != null) {
                        return CardMolde(
                          title: doc.data()['NombreProducto'],
                          img: doc.data()['Imagen'],
                          molde: doc.data()['Molde'],
                        );
                      }
                      return CardMolde(
                          title: doc.data()['NombreProducto'],
                          molde: doc.data()['Molde'],
                          img:
                              'http://atrilco.com/wp-content/uploads/2017/11/ef3-placeholder-image.jpg');
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }

  Future setCarrito() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      carrito = json.decode(prefs.getString('carrito'));
    });
  }

  Container _return(BuildContext context) {
    return Container(
      width: 50,
      margin: EdgeInsets.only(top: 10, left: 10, right: 300),
      alignment: Alignment.topLeft,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Row(
          children: [
            Icon(
              Icons.arrow_back_ios,
              color: colorPrincipal,
            ),
            Text(
              'Moldes',
              style:
                  TextStyle(color: colorPrincipal, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  deleteCarrito() {
    carrito = [];
  }
}

class CardMolde extends StatelessWidget {
  final String title;
  final String img;
  final String molde;
  const CardMolde(
      {Key key, @required this.title, @required this.img, this.molde})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Container(
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
                        Icons.add,
                        color: colorPrincipal,
                      ),
                      onPressed: () {
                        addItem();
                      },
                    ))
              ],
            ),
            Container(
                width: width * .25, child: Image(image: NetworkImage(img))),
            Container(child: Text(title)),
            Container(
                margin: EdgeInsets.only(bottom: width * .05),
                child: Text(title)),
          ],
        ),
      ),
    );
  }

  Future<void> addItem() async {
    if (carrito.where((element) => element[title]) != null) {
      carrito.add({
        'nombre': title,
        'img': img,
        'molde': molde,
        'count': 1,
        'price': 14
      });
    } else {
      int index = carrito.indexWhere((element) => element.containsValue(title));

      carrito[index].update('count', (value) => value++);
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String carr = json.encode(carrito);
    await prefs.setString('carrito', carr);
    print(prefs.getString('carrito'));
  }
}
