
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:paleteria_marfel/HexaColors/HexColor.dart';
import 'package:paleteria_marfel/Inventario/AgregarInventario.dart';
import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';
import 'package:paleteria_marfel/Inventario/DetallesInventario.dart';
import 'package:paleteria_marfel/Ventas/VistaVentas.dart';




class VistaInventario extends StatefulWidget {
  final String usuario;
  VistaInventario({Key key, this.usuario}) : super(key: key);

  @override
  _VistaInventarioState createState() => _VistaInventarioState();
}

bool icono = false;
Color colorPrincipal = HexColor("#3C9CA8");
String categoria;


class _VistaInventarioState extends State<VistaInventario> { 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: colorPrincipal,
      appBar: AppBar(
        backgroundColor: colorPrincipal,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(),
            Text(
              'Inventario',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(),
            SizedBox()
          ],
        ),
        
      ),
      drawer: CustomAppBar(usuario: widget.usuario,),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            color: colorPrincipal,
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
                    Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AgregarInventario(
                                  )));
                  },
                  label: Text(
                    "Nuevo Sabor",
                    style: TextStyle(color: colorPrincipal),
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
          Container(
            height: MediaQuery.of(context).size.height *.85,
            child: ListView(
        children: [
          _return(context),
          Container(
          height: MediaQuery.of(context).size.height * .82,
          child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("Molde").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: SpinKitFadingCube(
                    color: colorPrincipal,
                    size: 50.0,
                      ),
                    );
                }
                int length = snapshot.data.docs.length;
                return GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, //columnas
                    mainAxisSpacing: 10.0, //espacio entre cards
                    crossAxisSpacing: 10,
                    childAspectRatio: 1, // largo de la card
                  ),
                  itemCount: length,
                  itemBuilder: (BuildContext context, int index) {
                    final DocumentSnapshot doc = snapshot.data.docs[index];
                    print(doc.toString());
                    if (doc.data()['img'] != null) {
                      return Molde(
                        title: doc.data()['nombre'],
                        img: doc.data()['img'],
                        function: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DetallesInventario(
                                    categoria: doc.data()['nombre'],
                                    usuario: widget.usuario,
                                  )));
                        },
                      );
                    }
                    return Molde(
                        title: doc.data()['nombre'],
                        img:'http://atrilco.com/wp-content/uploads/2017/11/ef3-placeholder-image.jpg');
                  },
                );
              }),
        ),
        ],
      ),
          )
        ],
      ),
    );
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




}




