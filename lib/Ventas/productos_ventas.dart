import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';

class SalesProducts extends StatelessWidget {
  final String categoria;
  const SalesProducts({Key key, @required this.categoria}) : super(key: key);

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
                  itemCount: 3,
                  badgeColor: Colors.red,
                  itemColor: colorPrincipal,
                  hideZero: true,
                  onTap: () {
                    print('h');
                    showModalBottomSheet(
                        builder: (BuildContext context) {
                          return Container(
                            width: width,
                            height: height * 5 / 6,
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
          _return(),
          Table(children: [
            _tableRow(
                title2: 'hola',
                img2:
                    'http://atrilco.com/wp-content/uploads/2017/11/ef3-placeholder-image.jpg',
                title1: 'hola',
                img1:
                    'http://atrilco.com/wp-content/uploads/2017/11/ef3-placeholder-image.jpg')
          ])
        ],
      ),
    );
  }

  Container _return() {
    return Container(
      width: 50,
      margin: EdgeInsets.only(top: 10, left: 10, bottom: 10, right: 300),
      alignment: Alignment.topLeft,
      child: InkWell(
        onTap: () {},
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

class CardMolde extends StatelessWidget {
  final String title;
  final String img;
  const CardMolde({Key key, @required this.title, @required this.img})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
          color: colorPrincipal, borderRadius: BorderRadius.circular(20)),
      width: width * .4,
      height: width * .4,
      margin: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(width: width * .25, child: Image(image: NetworkImage(img))),
          Text(title),
        ],
      ),
    );
  }
}
