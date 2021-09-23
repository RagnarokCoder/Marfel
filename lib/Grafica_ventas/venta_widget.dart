import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'details_page.dart';
import 'package:intl/intl.dart';
import 'Grafica_Pie.dart';
import 'graph_widget.dart';

enum GraphType {
  LINES,
  PIE,
}
int i = 0;

class VentaWidget extends StatefulWidget {
  final List<DocumentSnapshot> documents;
  final dynamic total;
  final List<double> perDay;
  final Map<String, double> categories;
  final GraphType graphType;
  final int month;

  VentaWidget({Key key, @required this.month, this.graphType, this.documents})
      : total = documents
            .map((doc) => doc.data()['Total'])
            .fold(0.0, (a, b) => a + b),
        perDay = List.generate(30, (int index) {
          print(documents
                  .where((doc) => doc.data()['Dia'] == (index + 1))
                  .map((doc) => doc.data()['Total'])
                  .fold(0.0, (a, b) => a + b)
                  .toString() +
              "hola");
          return documents
              .where((doc) => doc.data()['Dia'] == (index + 1))
              .map((doc) => doc.data()['Total'])
              .fold(0.0, (a, b) => a + b);
        }),
        categories = documents.fold({}, (Map<String, double> map, document) {
          List<dynamic> productos = document.data()["Productos"];

          for (var i in productos) {
            if (!map.containsKey(i["Molde"] + " " + i["NombreProducto"])) {
              map[i["Molde"] + " " + i["NombreProducto"]] = 0.0;
            }
            map[i["Molde"] + " " + i["NombreProducto"]] += i["Subtotal"];
            print(i);
          }

          i++;
          return map;
        }),
        super(key: key);

  @override
  _VentaWidgetState createState() => _VentaWidgetState();
}

class _VentaWidgetState extends State<VentaWidget> {
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          _expenses(),
          _graph(),
          Container(
            color: Colors.black.withOpacity(0.3),
            height: 5.0,
          ),
          SizedBox(
            width: 5,
          ),
          _list(),
        ],
      ),
    );
  }

  Widget _expenses() {
    NumberFormat f = new NumberFormat("#,##0.00", "es_US");
    return Column(
      children: <Widget>[
        Text(
          "\$${f.format(widget.total)}",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 30.0),
        ),
        Text(
          "Total de Ventas",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  // ignore: missing_return
  Widget _graph() {
    if (widget.graphType == GraphType.LINES) {
      return Container(
        height: 200.0,
        child: GraphWidget(
          data: widget.perDay,
        ),
      );
    }

    if (widget.graphType == GraphType.PIE) {
      var perCategory = widget.categories.keys
          .map((name) => widget.categories[name] / widget.total)
          .toList();
      return Container(
        height: 250.0,
        child: PieGraphWidget(
          data: perCategory,
        ),
      );
    }
  }

  Widget _item(IconData icon, String nombre, int percent, double value) {
    NumberFormat f = new NumberFormat("#,##0.00", "es_US");
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed('/details',
            arguments: DetailsPage1(nombre, widget.month));
      },
      leading: Icon(
        icon,
        size: 24.0,
        color: Colors.blueAccent[200],
      ),
      title: Text(
        nombre,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18.0),
      ),
      subtitle: Text(
        "$percent% de Ventas",
        style: TextStyle(fontSize: 16.0, color: Colors.black.withOpacity(0.45)),
      ),
      trailing: Container(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "\$${f.format(value)}",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 18.0,
          ),
        ),
      )),
    );
  }

  Widget _list() {
    return Expanded(
      child: ListView.separated(
        itemCount: widget.categories.keys.length,
        itemBuilder: (BuildContext context, int index) {
          var key = widget.categories.keys.elementAt(index);
          var data = widget.categories[key];

          return _item(FontAwesomeIcons.moneyBill, key.toString(),
              100 * data ~/ widget.total, data);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Container(
            color: Colors.black.withOpacity(0.15),
            height: 8.0,
          );
        },
      ),
    );
  }
}
