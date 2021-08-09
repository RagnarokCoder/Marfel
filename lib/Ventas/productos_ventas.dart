import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';
import 'package:paleteria_marfel/Ventas/Carrito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yudiz_modal_sheet/yudiz_modal_sheet.dart';

List carrito = [];

class SalesProducts extends StatefulWidget {
  final String categoria;
  final String usuario;
  const SalesProducts({Key key, @required this.categoria, this.usuario})
      : super(key: key);

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
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

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
                    size: 22,
                    color: Colors.white,
                  ),
                  itemCount: carrito.length,
                  badgeColor: Colors.red,
                  itemColor: colorPrincipal,
                  hideZero: true,
                  onTap: () {
                    buildCarrito(context);
                  },
                ),
              ],
            ),
          ]),
      drawer: CustomAppBar(
        usuario: widget.usuario,
      ),
      body: ListView(
        children: [
          _return(context),
          Container(
            height: height * .82,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Inventario")
                    .where("Molde", isEqualTo: categoria)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Image.asset("assets/marfelLoad.gif"),
                    );
                  }
                  int length = snapshot.data.docs.length;
                  return GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, //columnas
                      mainAxisSpacing: 10.0, //espacio entre cards
                      crossAxisSpacing: 10,
                      childAspectRatio: .88, // largo de la card
                    ),
                    itemCount: length,
                    itemBuilder: (BuildContext context, int index) {
                      final DocumentSnapshot doc = snapshot.data.docs[index];
                      print(doc.toString());
                      if (doc.data()['Imagen'] != null) {
                        return CardMolde(
                          max: doc.data()['Cantidad'],
                          title: doc.data()['NombreProducto'],
                          img: doc.data()['Imagen'],
                          molde: doc.data()['Molde'],
                          id: doc.id,
                        );
                      }
                      return CardMolde(
                          max: doc.data()['Cantidad'],
                          title: doc.data()['NombreProducto'],
                          molde: doc.data()['Molde'],
                          id: doc.id,
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

  buildCarrito(BuildContext context) {
    YudizModalSheet.show(
        context: context,
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .6,
            child: Orden(),
          );
        }),
        direction: YudizModalSheetDirection.BOTTOM);
  }

  Future setCarrito() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if (prefs.getString('carrito') == null) prefs.setString('carrito', '[]');
      carrito = json.decode(prefs.getString('carrito'));
    });
  }

  Container _return(BuildContext context) {
    return Container(
      width: 50,
      height: 30,
      margin: EdgeInsets.only(top: 10, left: 10),
      alignment: Alignment.topLeft,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Row(
          children: [
            Icon(
              Icons.arrow_back_ios,
              size: 18,
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

  updateCarrito() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    carrito = json.decode(prefs.getString('carrito'));
  }
}

class CardMolde extends StatelessWidget {
  final String title;

  final String img;
  final String molde;
  final dynamic max;
  final String id;
  const CardMolde(
      {Key key,
      @required this.title,
      @required this.img,
      this.molde,
      @required this.max,
      this.id})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Container(
      width: width * .41,
      height: width * .41,
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
                width: width * .20, child: Image(image: NetworkImage(img))),
            Container(child: Text(title)),
            Container(
                margin: EdgeInsets.only(bottom: width * .05),
                child: Text(molde)),
          ],
        ),
      ),
    );
  }

  Future<void> addItem() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    carrito = json.decode(prefs.getString('carrito'));
    int index = carrito.indexWhere((element) =>
        element.containsValue(title) && element.containsValue(molde));
    if (index != -1) {
      carrito[index]['count']++;
    } else {
      carrito.add({
        'nombre': title,
        'img': img,
        'molde': molde,
        'count': 1,
        'price': 1.0,
        'max': max,
        'id': id
      });
    }

    String carr = json.encode(carrito);
    await prefs.setString('carrito', carr);
    print(prefs.getString('carrito'));
  }

  getPrices(String molde) async {
    var d;
    CollectionReference ref = FirebaseFirestore.instance.collection("Precios");
    var doc = await ref.where("nombre", isEqualTo: molde).get().then((value) {
      if (value.docs.isEmpty) {
        print("a" + value.docs.toString());
      }
      print("b" + value.docs[0]["mayoreo"].toString());
      d = value.docs[0]["mayoreo"];
      print(d);
      return d;
    });
  }
}
