import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Orden extends StatefulWidget {
  Orden({Key key}) : super(key: key);

  @override
  _OrdenState createState() => _OrdenState();
}

class _OrdenState extends State<Orden> {
  _OrdenState();

  List carrito = [];
  Color colorButton = colorPrincipal;

  @override
  void initState() {
    super.initState();
    setCarrito();
  }

  @override
  Widget build(BuildContext context) {
    int total = 0;
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
              total += (carrito[index]['price']) * carrito[index]['count'];

              return _CardOrden(
                  delete: () {
                    setState(() {
                      delete(carrito[index]['molde'], carrito[index]['nombre']);
                    });
                  },
                  max: carrito[index]['max'],
                  counter: carrito[index]['count'],
                  name: carrito[index]['nombre'],
                  molde: carrito[index]['molde'],
                  price: carrito[index]['price']);
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
                '\$$total',
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
      carrito = json.decode(prefs.getString('carrito'));
    });
  }

  Future<void> delete(String name, String molde) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int index = carrito.indexWhere((element) =>
        element.containsValue(name) && element.containsValue(molde));
    carrito.removeAt(index);
    var carEncode = json.encode(carrito);
    prefs.setString('carrito', carEncode);
  }
}

class _CardOrden extends StatelessWidget {
  const _CardOrden(
      {Key key,
      @required this.counter,
      @required this.delete,
      @required this.name,
      @required this.price,
      @required this.molde,
      @required this.max})
      : super(key: key);
  final Function delete;
  final int price;
  final int counter;
  final int max;
  final String name;
  final String molde;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Container(
          child: Image(
              height: height * .06, image: AssetImage('assets/paletaPor.jpg')),
        ),
        Container(width: width * .3, child: Text(molde + ' ' + name)),
        CounterView(
          initNumber: counter,
          minNumber: 1,
          decreaseCallback: () => change(false),
          increaseCallback: () => change(true),
          maxNumber: max,
        ),
        Container(
            width: width * .2,
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

  change(bool choice) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List carrito = json.decode(prefs.getString('carrito'));
    int index = carrito.indexWhere((element) =>
        element.containsValue(name) && element.containsValue(molde));
    carrito = json.decode(prefs.getString('carrito'));
    if (choice) carrito[index]['count']++;
    if (!choice) carrito[index]['count']--;
    var carEncode = json.encode(carrito);
    prefs.setString('carrito', carEncode);
  }
}

class CounterView extends StatefulWidget {
  final int initNumber;
  final Function(int) counterCallback;
  final Function increaseCallback;
  final Function decreaseCallback;
  final int minNumber;
  final int maxNumber;
  CounterView(
      {this.initNumber,
      this.counterCallback,
      this.increaseCallback,
      this.decreaseCallback,
      this.minNumber,
      this.maxNumber});
  @override
  _CounterViewState createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  int _currentCount;
  Function _counterCallback;
  Function _increaseCallback;
  Function _decreaseCallback;
  int _minNumber;
  int _maxNumber;

  @override
  void initState() {
    _currentCount = widget.initNumber ?? 1;
    _counterCallback = widget.counterCallback ?? (int number) {};
    _increaseCallback = widget.increaseCallback ?? () {};
    _decreaseCallback = widget.decreaseCallback ?? () {};
    _minNumber = widget.minNumber ?? 0;
    _maxNumber = widget.maxNumber ?? 100;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20),
      width: MediaQuery.of(context).size.width * .18,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _createIncrementDicrementButton(Icons.remove, () => _dicrement()),
          Text(_currentCount.toString()),
          _createIncrementDicrementButton(Icons.add, () => _increment()),
        ],
      ),
    );
  }

  void _increment() {
    setState(() {
      if (_currentCount < _maxNumber) {
        _currentCount++;
        _counterCallback(_currentCount);
        _increaseCallback();
      }
    });
  }

  void _dicrement() {
    setState(() {
      if (_currentCount > _minNumber) {
        _currentCount--;
        _counterCallback(_currentCount);
        _decreaseCallback();
      }
    });
  }

  Widget _createIncrementDicrementButton(IconData icon, Function onPressed) {
    return RawMaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      constraints: BoxConstraints(minWidth: 25.0, minHeight: 25.0),
      onPressed: onPressed,
      elevation: 2.0,
      fillColor: colorPrincipal,
      child: Icon(
        icon,
        color: Colors.black,
        size: 12.0,
      ),
      shape: CircleBorder(),
    );
  }
}
