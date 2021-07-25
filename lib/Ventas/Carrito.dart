import 'package:flutter/material.dart';
import 'package:paleteria_marfel/CustomWidgets/Counter_number.dart';

class Orden extends StatefulWidget {
  Orden({Key key}) : super(key: key);

  @override
  _OrdenState createState() => _OrdenState();
}

class _OrdenState extends State<Orden> {
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
                  onPressed: () {},
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
          child: ListView(
            children: [
              _CardOrden(
                counter: 1,
                name: 'Paleta agua fresa',
                price: 14,
              ),
            ],
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
              Spacer(),
              Container(
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15), color: Colors.red),
                child: Text(
                  ' \$544 Pagar ',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _CardOrden extends StatelessWidget {
  const _CardOrden({
    Key key,
    @required this.counter,
    @required this.name,
    @required this.price,
  }) : super(key: key);
  final double price;
  final int counter;
  final String name;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Row(
      children: [
        Container(
          child: Image(
              height: height * .08, image: AssetImage('assets/paletaPor.jpg')),
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
