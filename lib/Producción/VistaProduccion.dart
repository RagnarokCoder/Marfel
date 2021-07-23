import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';
import 'package:paleteria_marfel/Producci%C3%B3n/DetallesProduccion.dart';
import 'package:paleteria_marfel/Producci%C3%B3n/NuevaOrden.dart';


class VistaProduccion extends StatefulWidget {
  final String usuario;
  VistaProduccion({Key key, this.usuario}) : super(key: key);

  @override
  _VistaProduccionState createState() => _VistaProduccionState();
}



int selectedValue = 0;



class _VistaProduccionState extends State<VistaProduccion> {
  

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      backgroundColor: colorPrincipal,
      appBar: AppBar(
        backgroundColor: colorPrincipal,
        elevation: 5,
        title: Text("Producción"),
        centerTitle: true,
        actions: <Widget>[
          
        ],
      ),
      drawer: CustomAppBar(usuario: widget.usuario,),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(15),
            color: Colors.transparent,
            height: MediaQuery.of(context).size.height * 0.07,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ignore: deprecated_member_use
                RaisedButton.icon(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.transparent)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: NuevaOrden()));
                  },
                  label: Text(
                    "Nueva Orden",
                    style: TextStyle(color: Colors.black),
                  ),
                  icon: Icon(
                    Icons.add,
                    size: 18,
                    color: colorPrincipal,
                  ),
                ),

                
              ],
            ),
          ),
          Divider(
            height: 12,
            indent: MediaQuery.of(context).size.width * 0.05,
            endIndent: MediaQuery.of(context).size.width * 0.05,
            color: colorPrincipal,
          ),
          
          Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height * 0.7,
            child: ListView(
              children: [
                CurvedListItemWhite(
            title: 'Paletas',
            time: 'Vea A Detalle Toda La Producción de Paletas',
            asset: "assets/paletaPor.jpg",
            color: Colors.white,
            nextColor: colorPrincipal,
            press: (){ Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DetallesProduccion(
                                    categoria: "Paleta",
                                  )));},
          ),
          CurvedListItem(
            title: 'Helado',
            time: 'Vea A Detalle Toda La Producción de Helados',
            asset: "assets/heladoPor.png",
            color: colorPrincipal,
            nextColor: Colors.white,
            press: (){ Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DetallesProduccion(
                                    categoria: "Helado",
                                  )));},
          ),
          CurvedListItemWhite(
            title: 'Bolis',
            time: 'Vea A Detalle Toda La Producción de Bolis',
            asset: "assets/boliPor.jpg",
            color: Colors.white,
            nextColor: colorPrincipal,
            press: (){ Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DetallesProduccion(
                                    categoria: "Bolis",
                                  )));},
          ),
          CurvedListItem(
            title: 'Sandwich',
            time: 'Vea A Detalle Toda La Producción de Sandwich',
            asset: "assets/sandPor.jpg",
            color: colorPrincipal,
            nextColor: Colors.white,
            press: (){ Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DetallesProduccion(
                                    categoria: "Sandwich",
                                  )));},
          ),
          CurvedListItemWhite(
            title: 'Troles',
            time: 'Vea A Detalle Toda La Producción de Troles',
            asset: "assets/trolPor.jpg",
            color: Colors.white,
            nextColor: colorPrincipal,
            press: (){ Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DetallesProduccion(
                                    categoria: "Troles",
                                  )));},
          ),
              ],
            ),
          )
        ],
      ),
    );
  }
}



class CurvedListItem extends StatelessWidget {
  const CurvedListItem({
    this.title,
    this.time,
    this.people,
    this.color,
    this.nextColor, 
    this.press, this.asset, 
  });

  final Function press;
  final String title;
  final String time;
  final String people;
  final Color color;
  final Color nextColor;
  final String asset;
 

  @override
  Widget build(BuildContext context) {
    return 
    InkWell(
      onTap: press,
      child:
    Container(
      color: nextColor,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(80.0),
          ),
        ),
        padding: const EdgeInsets.only(
          left: 32,
          top: 80.0,
          bottom: 50,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                time,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              Row(),
            ]),
            Container(
                    margin: EdgeInsets.only(right: 15),
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image:  AssetImage(
                                asset)
                        )
                    )),
          ],
        )
      ),
    ));
  }
}


class CurvedListItemWhite extends StatelessWidget {
  const CurvedListItemWhite({
    this.title,
    this.time,
    this.icon,
    this.people,
    this.color,
    this.nextColor, this.press, this.asset,
  });

  final String title;
  final Function press;
  final String time;
  final String people;
  final IconData icon;
  final Color color;
  final Color nextColor;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return 
    InkWell(
      onTap: press,
      child:
    Container(
      color: nextColor,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(80.0),
          ),
        ),
        padding: const EdgeInsets.only(
          left: 32,
          top: 80.0,
          bottom: 50,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                time,
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                title,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              Row(),
            ]),
            Container(
                    margin: EdgeInsets.only(right: 15),
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image:  AssetImage(
                                asset)
                        )
                    )),
          ],
        )
      ),
    ));
  }
}