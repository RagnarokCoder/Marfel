import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Orden extends StatefulWidget {
  Orden({Key key}) : super(key: key);

  @override
  _OrdenState createState() => _OrdenState();
}

double total;

class _OrdenState extends State<Orden> {
  _OrdenState();

  List carrito = [];
  Color colorButton = colorPrincipal;

  get getTotal {
    total = 0;
    for (var i in carrito) {
      total += i['price'] * i['count'];
    }
    return total;
  }

  @override
  void initState() {
    super.initState();
    setCarrito();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            Container(margin: EdgeInsets.only(left: 10), child: Text('Orden:')),
            Spacer(),
            Container(
              margin: EdgeInsets.only(right: 10),
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      deleteCarrito();
                    });
                  },
                  icon: Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                  )),
            )
          ],
        ),
        Divider(),
        Container(
          width: width,
          height: height * 3 / 8,
          child: ListView.builder(
            itemCount: carrito.length,
            itemBuilder: (BuildContext context, int index) {
              return _CardOrden(
                  delete: () {
                    setState(() {
                      delete(carrito[index]['molde'], carrito[index]['nombre']);
                    });
                  },
                  state: () {
                    setState(() {
                      getTotal;
                    });
                  },
                  max: carrito[index]['max'],
                  counter: carrito[index]['count'],
                  name: carrito[index]['nombre'],
                  molde: carrito[index]['molde'],
                  price: carrito[index]['price'],
                  imagen: carrito[index]['img'],
                  id: carrito[index]['id']);
            },
          ),
        ),
        Divider(),
        Container(
          margin: EdgeInsets.all(10),
          child: Row(
            children: [
              Spacer(),
              Text(
                'Total:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: width * .01,
              ),
              Text(
                '\$$getTotal',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  _mostrarAlert(context);
                },
                child: Container(
                  margin: EdgeInsets.only(right: width * .04),
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: colorButton),
                  child: Text(
                    ' Pagar ',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void _mostrarAlert(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text('Compra'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('¿Los articulos estan correctos?'),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    _subirVenta();
                    Navigator.of(context).pop();
                  },
                  child: Text('si')),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('no')),
            ],
          );
        });
  }

  Future<void> deleteCarrito() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('carrito', '[]');
    print(prefs.getString('carrito'));
    carrito = [];
  }

  Future setCarrito() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getString('carrito') == null) prefs.setString('carrito', '[]');
      carrito = json.decode(prefs.getString('carrito'));
    });
  }

  Future<void> delete(String name, String molde) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int index = carrito.indexWhere((element) =>
        element.containsValue(name) && element.containsValue(molde));

    setState(() {
      carrito.removeAt(index);
      var carEncode = json.encode(carrito);
      prefs.setString('carrito', carEncode);
    });
  }

  Future<void> _subirVenta() async {
    var collection = FirebaseFirestore.instance.collection('Inventario');
    carrito.forEach((element) {
      collection
          .doc(element['id'])
          .update({'Cantidad': element["max"] - element['count']})
          .then((_) => print('Updated'))
          .catchError((error) => print('Update failed: $error'));
    });
    String date = DateTime.now().day.toString() +
        '/' +
        DateTime.now().month.toString() +
        '/' +
        DateTime.now().year.toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FirebaseFirestore.instance.collection("Ventas").add({
      "Productos": getCarrito(),
      "Dia": DateTime.now().day,
      "Mes": DateTime.now().month,
      "Año": DateTime.now().year,
      "Date": DateTime.now(),
      "FechaVenta": date,
      "Total": total,
      "Abonado": 0,
      "Pendiente": false,
      "Nombre": 'Juan'
    }).then((value) => {
          setState(() {
            carrito = [];

            prefs.setString('carrito', '[]');
          })
        });
  }

  getCarrito() {
    List<Map> carritoAux = [];
    carrito.forEach((element) {
      carritoAux.add({
        "Cantidad": element['count'],
        "Molde": element['molde'],
        "NombreProducto": element['nombre'],
        "Subtotal": element['count'] * element['price']
      });
    });
    return carritoAux;
  }
}

class _CardOrden extends StatefulWidget {
  const _CardOrden(
      {Key key,
      @required this.counter,
      @required this.delete,
      @required this.name,
      @required this.price,
      @required this.molde,
      @required this.max,
      @required this.id,
      this.state,
      this.imagen})
      : super(key: key);
  final Function delete;
  final Function state;
  final dynamic price;
  final int counter;
  final int max;
  final String name;
  final String id;
  final String molde;
  final String imagen;

  @override
  __CardOrdenState createState() => __CardOrdenState(counter);
}

class __CardOrdenState extends State<_CardOrden> {
  __CardOrdenState(this.counter);
  int counter;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Container(
          child:
              Image(height: height * .05, image: NetworkImage(widget.imagen)),
        ),
        Container(
            width: width * .3, child: Text(widget.molde + ' ' + widget.name)),
        Container(
          child: botoncitos(
            context: context,
            initNumber: counter,
            minNumber: 1,
            maxNumber: widget.max,
            add: () => change(true),
            rest: () => change(false),
          ),
        ),
        Container(
            width: width * .18,
            margin: EdgeInsets.only(left: height * .01),
            child: Text(' \$ ${widget.price} c/u')),
        Spacer(),
        IconButton(
            onPressed: () {
              widget.delete();
            },
            icon: Icon(
              Icons.delete_outlined,
              color: Colors.red,
            )),
      ],
    );
  }

  change(bool choice) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List carrito = json.decode(prefs.getString('carrito'));
    int index = carrito.indexWhere((element) =>
        element.containsValue(widget.name) &&
        element.containsValue(widget.molde));
    carrito = json.decode(prefs.getString('carrito'));
    print(carrito[index]['max']);
    if (choice) {
      if (carrito[index]['max'] > counter)
        setState(() {
          carrito[index]['count']++;
          counter++;
          widget.state();
        });
    }

    if (!choice) {
      if (counter > 1)
        setState(() {
          carrito[index]['count']--;
          counter--;
          widget.state();
        });
    }

    var carEncode = json.encode(carrito);
    prefs.setString('carrito', carEncode);
  }

  Widget botoncitos(
      {@required int maxNumber,
      @required int minNumber,
      @required int initNumber,
      @required BuildContext context,
      @required Function add,
      @required Function rest}) {
    var _currentCount = initNumber;
    return Container(
      margin: EdgeInsets.only(left: 10),
      width: MediaQuery.of(context).size.width * .2,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              rest();
            },
            child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * .06,
                height: MediaQuery.of(context).size.width * .06,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * .03),
                    color: colorPrincipal),
                child: Icon(Icons.remove)),
          ),
          Text(_currentCount.toString()),
          InkWell(
            onTap: () {
              add();
            },
            child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * .06,
                height: MediaQuery.of(context).size.width * .06,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * .03),
                    color: colorPrincipal),
                child: Icon(Icons.add)),
          ),
        ],
      ),
    );
  }
}
