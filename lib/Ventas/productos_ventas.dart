import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:paleteria_marfel/CustomWidgets/Counter_number.dart';
import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';

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
                    print('h');
                    showModalBottomSheet(
                        builder: (BuildContext context) {
                          return Container(
                            width: width,
                            height: height * 6 / 7,
                            child: _Orden(),
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
                      mainAxisSpacing: 30.0, //espacio entre cards
                      crossAxisSpacing: 10,
                      childAspectRatio: .87, // largo de la card
                    ),
                    itemCount: length,
                    itemBuilder: (BuildContext context, int index) {
                      final DocumentSnapshot doc = snapshot.data.docs[index];
                      print(doc.toString());
                      if (doc.data()['Imagen'] != null) {
                        return CardMolde(
                            title: doc.data()['NombreProducto'],
                            img: doc.data()['Imagen']);
                      }
                      return CardMolde(
                          title: doc.data()['NombreProducto'],
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

/*
CardMolde(
                        title: '',
                        img:
                            'http://atrilco.com/wp-content/uploads/2017/11/ef3-placeholder-image.jpg');
*/
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

  TableRow _tableRow(
      {@required String title2,
      @required String img2,
      @required String title1,
      @required String img1}) {
    if (img2 != '')
      return TableRow(children: [
        CardMolde(
          title: title2,
          img: img2,
        ),
        CardMolde(
          title: title1,
          img: img1,
        ),
      ]);
    return TableRow(children: [
      CardMolde(
        title: title1,
        img: img1,
      ),
      Container(),
    ]);
  }
}

class _Orden extends StatelessWidget {
  const _Orden({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Column(
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
        _CardOrden(height: height),
        _CardOrden(height: height),
        _CardOrden(height: height),
        _CardOrden(height: height),
        Spacer(),
        Container(
          margin: EdgeInsets.all(10),
          child: Row(
            children: [
              Text(
                'Total:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                '544',
                style: TextStyle(fontSize: 24),
              )
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
    @required this.height,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          child: Image(
              height: height * .08, image: AssetImage('assets/paletaPor.jpg')),
        ),
        Text('Paleta agua fresa'),
        CounterView(
          initNumber: 1,
          minNumber: 1,
        ),
        Container(
            margin: EdgeInsets.only(left: height * .01),
            child: Text(' 14 c/u')),
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

class CardMolde extends StatelessWidget {
  final String title;
  final String img;
  const CardMolde({Key key, @required this.title, @required this.img})
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
                      onPressed: () {},
                    ))
              ],
            ),
            Container(
                width: width * .25, child: Image(image: NetworkImage(img))),
            Container(
                margin: EdgeInsets.only(bottom: width * .05),
                width: width * .25,
                child: Text(title)),
          ],
        ),
      ),
    );
  }
}
