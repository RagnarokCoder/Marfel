import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:paleteria_marfel/CustomWidgets/Counter_number.dart';
import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Orden extends StatefulWidget {
  Orden({Key key, this.delete}) : super(key: key);
  final Function delete;
  @override
  _OrdenState createState() => _OrdenState(delete: delete);
}

class _OrdenState extends State<Orden> {
  _OrdenState({this.delete});
  Function delete;
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
                  counter: carrito[index]['count'],
                  name: carrito[index]['nombre'],
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
}

class _CardOrden extends StatelessWidget {
  const _CardOrden({
    Key key,
    @required this.counter,
    @required this.name,
    @required this.price,
  }) : super(key: key);
  final int price;
  final int counter;
  final String name;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Row(
      children: [
        Container(
          child: Image(
              height: height * .06, image: AssetImage('assets/paletaPor.jpg')),
        ),
        Text(name),
        CounterView(
          initNumber: counter,
          minNumber: 1,
        ),
        Container(
            margin: EdgeInsets.only(left: height * .01),
            child: Text(' \$ $price c/u')),
        Spacer(),
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.delete_outlined,
              color: Colors.red,
            )),
      ],
    );
  }
}

class CounterView extends StatefulWidget {
  final int initNumber;
  final Function(int) counterCallback;
  final Function increaseCallback;
  final Function decreaseCallback;
  final int minNumber;
  CounterView(
      {this.initNumber,
      this.counterCallback,
      this.increaseCallback,
      this.decreaseCallback,
      this.minNumber});
  @override
  _CounterViewState createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  int _currentCount;
  Function _counterCallback;
  Function _increaseCallback;
  Function _decreaseCallback;
  int _minNumber;

  @override
  void initState() {
    _currentCount = widget.initNumber ?? 1;
    _counterCallback = widget.counterCallback ?? (int number) {};
    _increaseCallback = widget.increaseCallback ?? () {};
    _decreaseCallback = widget.decreaseCallback ?? () {};
    _minNumber = widget.minNumber ?? 0;
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
      _currentCount++;
      _counterCallback(_currentCount);
      _increaseCallback();
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
