import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:paleteria_marfel/Inventario/NotificacionesInventario.dart';
import 'package:yudiz_modal_sheet/yudiz_modal_sheet.dart';
import 'package:icon_badge/icon_badge.dart';
import 'VistaInventario.dart';

class DetallesInventario extends StatefulWidget {
  final String categoria;
  final String usuario;
  DetallesInventario({Key key, this.categoria, this.usuario}) : super(key: key);

  @override
  _DetallesInventarioState createState() => _DetallesInventarioState();
}

final _condicionesText = TextEditingController();
int documents = 0;
bool borrarItem = false;

class _DetallesInventarioState extends State<DetallesInventario> {
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
              result.data()['Categoria'] == widget.categoria &&
              result.data()['Pendiente'] == true) {
            if (result.data()['Limitar'] < result.data()['Cantidad']) {
              documents = documents + 1;
            }
          }
        });
      });
    });
    print(widget.categoria);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrincipal,
        elevation: 5,
        title: Text("Inventario ${widget.categoria}"),
        centerTitle: true,
        actions: [
          Container(
            height: 40.0,
            width: 60.0,
            child: Center(
              child: IconBadge(
                icon: Icon(Icons.notifications_none, color: Colors.white),
                itemCount: documents,
                badgeColor: Colors.red,
                itemColor: colorPrincipal,
                hideZero: true,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NotificacionesInventario(
                          categoria: widget.categoria)));
                },
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 15,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Inventario")
                    .where("Molde", isEqualTo: widget.categoria)
                    .snapshots(),
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
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, //columnas
                      mainAxisSpacing: 30.0, //espacio entre cards
                      crossAxisSpacing: 10,
                      childAspectRatio: .87, // largo de la card
                    ),
                    itemCount: length,
                    padding: EdgeInsets.all(1.0),
                    itemBuilder: (_, int index) {
                      final DocumentSnapshot doc = snapshot.data.docs[index];
                      return Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width * 0.5,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: Column(children: [
                            
                            
                            Column(
                              children: [
                                Text(
                                  "${doc.data()['NombreProducto']}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.15,
                                  child:
                                      Image.network("${doc.data()['Imagen']}"),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${doc.data()['Cantidad']}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.more_horiz,
                                        color: colorPrincipal,
                                      ),
                                      onPressed: () {
                                        detallesProducto(context, doc);
                                      },
                                    )
                                  ],
                                )
                              ],
                            ),
                          ]));
                    },
                  );
                }),
          )
        ],
      ),
    );
  }

  detallesProducto(BuildContext context, DocumentSnapshot doc) {
    YudizModalSheet.show(
        context: context,
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50))),
            height: MediaQuery.of(context).size.height * 0.2,
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Detalles Del Producto",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
                ),
                Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        borrarItem == false
                            ? RaisedButton.icon(
                                elevation: 5,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side:
                                        BorderSide(color: Colors.transparent)),
                                icon: Icon(Icons.delete,
                                    color: Colors.red.shade700, size: 22),
                                label: Text("Borrar Producto"),
                                onPressed: () {
                                  setState(() {});
                                  borrarItem = true;
                                },
                              )
                            : Column(
                                children: [
                                  Text(
                                    "Confirmar",
                                    style: TextStyle(
                                        color: colorPrincipal,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      RaisedButton.icon(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          color: Colors.white,
                                          elevation: 5,
                                          onPressed: () {
                                            setState(() {});
                                            borrarItem = false;
                                            FirebaseFirestore.instance.collection("Inventario").doc(doc.id).delete();
                                          },
                                          icon: Icon(Icons.check,
                                              color: Colors.green.shade600),
                                          label: Text(
                                            "Si",
                                            style: TextStyle(
                                                color: colorPrincipal),
                                          )),
                                      RaisedButton.icon(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          color: Colors.white,
                                          elevation: 5,
                                          onPressed: () {
                                            setState(() {});
                                            borrarItem = false;
                                          },
                                          icon: Icon(Icons.close,
                                              color: Colors.red.shade600),
                                          label: Text(
                                            "No",
                                            style: TextStyle(
                                                color: colorPrincipal),
                                          ))
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(width: 15,),
                              RaisedButton.icon(
                                elevation: 5,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side:
                                        BorderSide(color: Colors.transparent)),
                                icon: Icon(Icons.touch_app,
                                    color: Colors.blue.shade700, size: 22),
                                label: Text("Limitar Producto"),
                                onPressed: () {
                                  limitarProducto(context, doc);
                                },
                              )
                      ],
                    ),
                  )
              ],
            )),
          );
        }),
        direction: YudizModalSheetDirection.BOTTOM);
  }

  limitarProducto(BuildContext context, DocumentSnapshot doc) {
    YudizModalSheet.show(
        context: context,
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50))),
            height: MediaQuery.of(context).size.height * 0.3,
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  margin: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.help_outline_outlined, color: colorPrincipal),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          "Limitar Producto\n${doc.data()['NombreProducto']}",
                          style: TextStyle(
                              color: colorPrincipal,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextField(
                      minLines: 5,
                      maxLines: 15,
                      decoration: InputDecoration(
                          fillColor: Colors.white.withOpacity(0.8),
                          filled: true,
                          suffixText: ""),
                      controller: _condicionesText,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox.fromSize(
                      size: Size(100, 50), // button width and height
                      child: ClipRRect(
                        child: Material(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          color: Colors.white, // button color
                          child: InkWell(
                            splashColor: Colors.blue, // splash color
                            onTap: () {
                              FirebaseFirestore.instance
                                  .collection("Inventario")
                                  .doc(doc.id)
                                  .update({
                                "Limitar": double.parse(_condicionesText.text),
                                "Pendiente": true
                              }).then((value) => {_condicionesText.text = ""});
                              Navigator.of(context).pop();
                            }, // button pressed
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.add,
                                  color: Colors.blue.shade600,
                                  size: 16.0,
                                ), // icon
                                Text("Agregar",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)), // text
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox.fromSize(
                      size: Size(100, 50), // button width and height
                      child: ClipRRect(
                        child: Material(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          color: Colors.white, // button color
                          child: InkWell(
                            splashColor: Colors.blue, // splash color
                            onTap: () {
                              Navigator.of(context).pop();
                              setState(() {});
                            }, // button pressed
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.close,
                                  color: Colors.red.shade600,
                                  size: 16.0,
                                ), // icon
                                Text("Cerrar",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)), // text
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )),
          );
        }),
        direction: YudizModalSheetDirection.BOTTOM);
  }
}