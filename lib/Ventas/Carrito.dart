import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Orden extends StatefulWidget {
  Orden({Key key}) : super(key: key);

  @override
  _OrdenState createState() => _OrdenState();
}

dynamic total;

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

  int drop1 = 0;
  String cliente;
  List clientes;
  @override
  void initState() {
    super.initState();
    setCarrito();
  }

  var pendiente = false;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: 1,
        ),
        Row(
          children: [
            Container(margin: EdgeInsets.only(left: 10), child: Text('Orden:')),
            Spacer(),
            Flexible(
              flex: 3,
              fit: FlexFit.loose,
              child: CustomDropdown(
                borderRadius: 10,
                enabledColor: colorPrincipal,
                disabledIconColor: Colors.white,
                enabledIconColor: Colors.white,
                enableTextColor: Colors.white,
                elementTextColor: Colors.white,
                openColor: colorPrincipal,
                valueIndex: drop1,
                hint: "Cliente",
                items: [
                  for (var i in clientes) CustomDropdownItem(text: i),
                ],
                onChanged: (newValue) {
                  setState(() => drop1 = newValue);
                  Future.delayed(const Duration(milliseconds: 500), () {
                    setState(() {});
                  });
                },
              ),
            ),
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
              return cardItem(
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
                context: context,
                min: 0,
                max: carrito[index]['max'].round(),
                counter: carrito[index]['count'],
                name: carrito[index]['nombre'],
                molde: carrito[index]['molde'],
                price: carrito[index]['price'],
                imagen: carrito[index]['img'],
              );
            },
          ),
        ),
        Divider(),
        Container(
          margin: EdgeInsets.all(10),
          child: Row(
            children: [
              (drop1 != 0 && drop1 != (clientes.length))
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("pendiente"),
                        Container(
                          width: width * .3,
                          child: SwitchListTile(
                              title: Container(
                                  child: Text(
                                'N/S',
                                style: TextStyle(fontSize: 14),
                              )),
                              value: pendiente,
                              onChanged: (data) {
                                setState(() => pendiente = data);
                              }),
                        ),
                      ],
                    )
                  : SizedBox(),
              Spacer(),
              Text(
                'Total:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: width * .01,
              ),
              Text(
                '\$' + getTotal.toString(),
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
                drop1 != 0
                    ? Container(
                        width: 100,
                        child: SwitchListTile(
                            title: Text('a'),
                            value: pendiente,
                            onChanged: (data) {
                              setState(() => pendiente = data);
                            }),
                      )
                    : SizedBox(),
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
    clientes = prefs.getStringList("ListClients");
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
      collection
          .doc(element['id'])
          .update({'Vendidos': element['Vendidos'] + element['count']})
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
      "Pendiente": pendiente,
      "Nombre": clientes[drop1]
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

  Widget cardItem(
      {BuildContext context,
      Function delete,
      int max,
      int counter,
      String name,
      String imagen,
      String molde,
      int min,
      dynamic price,
      Function state}) {
    if (drop1 == 0 || drop1 == null) {
      if (counter >= 30) {
        int index = carrito.indexWhere((element) =>
            element.containsValue(name) && element.containsValue(molde));
        carrito[index]['price'] = carrito[index]['prices']['Mayoreo'];
      } else if (counter < 30) {
        int index = carrito.indexWhere((element) =>
            element.containsValue(name) && element.containsValue(molde));
        carrito[index]['price'] = carrito[index]['prices']['Menudeo'];
      }
    } else {
      if (counter >= 30) {
        int index = carrito.indexWhere((element) =>
            element.containsValue(name) && element.containsValue(molde));
        if (carrito[index]['prices'][clientes[drop1]]['Mayoreo'] != null) {
          carrito[index]['price'] =
              carrito[index]['prices'][clientes[drop1]]['Mayoreo'];
        } else {
          carrito[index]['price'] = carrito[index]['prices']['Mayoreo'];
        }
      } else if (counter < 30) {
        int index = carrito.indexWhere((element) =>
            element.containsValue(name) && element.containsValue(molde));
        print(carrito[index]['prices'][clientes[drop1]] != null);
        if (carrito[index]['prices'][clientes[drop1]] != null) {
          carrito[index]['price'] =
              carrito[index]['prices'][clientes[drop1]]['Menudeo'];
        } else {
          carrito[index]['price'] = carrito[index]['prices']['Menudeo'];
        }
      }
    }
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Container(
          child: Image(height: height * .05, image: NetworkImage(imagen)),
        ),
        Container(width: width * .3, child: Text(molde + ' ' + name)),
        Container(
          child: botoncitos(
              context: context,
              initNumber: counter,
              minNumber: 1,
              maxNumber: max,
              molde: molde,
              name: name),
        ),
        Container(
            width: width * .18,
            margin: EdgeInsets.only(left: height * .01),
            child: Text(' \$ $price c/u')),
        Spacer(),
        IconButton(
            onPressed: () {
              delete();
            },
            icon: Icon(
              Icons.delete_outlined,
              color: Colors.red,
            )),
      ],
    );
  }

  Widget botoncitos(
      {@required int maxNumber,
      @required int minNumber,
      @required int initNumber,
      @required BuildContext context,
      @required String name,
      @required String molde}) {
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
              setState(() {
                int index = carrito.indexWhere((element) =>
                    element.containsValue(name) &&
                    element.containsValue(molde));
                carrito[index]['count']--;
                initNumber--;
              });
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
              setState(() {
                int index = carrito.indexWhere((element) =>
                    element.containsValue(name) &&
                    element.containsValue(molde));
                carrito[index]['count']++;
                initNumber++;
              });
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
