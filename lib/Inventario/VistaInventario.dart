
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paleteria_marfel/HexaColors/HexColor.dart';
import 'package:paleteria_marfel/Inventario/DetallesInventario.dart';
import 'package:paleteria_marfel/Producci%C3%B3n/VistaProduccion.dart';
import 'package:yudiz_modal_sheet/yudiz_modal_sheet.dart';
import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';

class VistaInventario extends StatefulWidget {
  final String usuario;
  VistaInventario({Key key, this.usuario}) : super(key: key);

  @override
  _VistaInventarioState createState() => _VistaInventarioState();
}

bool icono = false;
Color colorPrincipal = HexColor("#3C9CA8");
final _nombreController = TextEditingController();
final _precioMenudeoController = TextEditingController();
final _precioMayoreoController = TextEditingController();
String molde = "";
String selector = "";


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
                    buildAlert(context);
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
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(5),
                  child: ListView(
              children: [
                 CurvedListItemWhite(
            title: 'Paletas',
            time: '',
            asset: "assets/paletaPor.jpg",
            color: Colors.white,
            nextColor: colorPrincipal,
            press: (){ Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DetallesInventario(
                                    categoria: "Paleta",
                                  )));},
          ),
          CurvedListItem(
            title: 'Helado',
            time: '',
            asset: "assets/heladoPor.png",
            color: colorPrincipal,
            nextColor: Colors.white,
            press: (){ Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DetallesInventario(
                                    categoria: "Helado",
                                  )));},
          ),
          CurvedListItemWhite(
            title: 'Bolis',
            time: '',
            asset: "assets/boliPor.jpg",
            color: Colors.white,
            nextColor: colorPrincipal,
            press: (){ Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DetallesInventario(
                                    categoria: "Bolis",
                                  )));},
          ),
          CurvedListItem(
            title: 'Sandwich',
            time: '',
            asset: "assets/sandPor.jpg",
            color: colorPrincipal,
            nextColor: Colors.white,
            press: (){ Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DetallesInventario(
                                    categoria: "Sandwich",
                                  )));},
          ),
          CurvedListItemWhite(
            title: 'Troles',
            time: '',
            asset: "assets/trolPor.jpg",
            color: Colors.white,
            nextColor: colorPrincipal,
            press: (){ Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DetallesInventario(
                                    categoria: "Troles",
                                  )));},
          ),
              ],
            ),
                ),
        ],
      ),
    );
  }
  buildAlert(BuildContext context) {
    bool surtido = false;
  YudizModalSheet.show(
      context: context,
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50))),
          height: MediaQuery.of(context).size.height*0.8,
          child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.all(15),
                    child: Text(
                      "Nuevo Producto",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    // ignore: deprecated_member_use
                    child: RaisedButton.icon(
                        color: Colors.transparent,
                        elevation: 0,
                        onPressed: () {
                          String materia = "";
                          String categoria = "";
                          if(molde == "Bolis Agua" || molde == "Bolito Agua")
                          {
                            materia = "Agua";
                            categoria = "Bolis";
                          }
                          if(molde == "Bolis Leche" || molde == "Bolito Leche")
                          {
                            materia = "Leche";
                            categoria = "Bolis";
                          }
                          if(molde == "Troles")
                          {
                            materia = "Agua";
                            categoria = "Troles";
                          }
                          if(molde == "Sandwich")
                          {
                            materia = "";
                            categoria = "Sandwich";
                          }
                          if(molde == "Cuadraleta Agua" || molde == "Hexagonal Agua" || molde == "Mini Agua" || molde == "Maxi")
                          {
                            materia = "Agua";
                            categoria = "Paleta";
                          }
                          if(molde == "Cuadraleta Leche" || molde == "Hexagonal Leche" ||  molde == "Mini Leche")
                          {
                            materia = "Leche";
                            categoria = "Paleta";
                          }
                          if(molde == "Helado 1L Agua" || molde == "Helado 5L Agua")
                          {
                            materia = "Agua";
                            categoria = "Helado";
                          }
                          if(molde == "Helado 1L Leche" || molde == "Helado 5L Leche")
                          {
                            materia = "Leche";
                            categoria = "Helado";
                          }
                          FirebaseFirestore.instance
                              .collection("Inventario")
                              
                              .add({
                                "Surtido": surtido,
                            "NombreProducto": _nombreController.text,
                            "PrecioMenudeo":
                                double.parse(_precioMenudeoController.text),
                            "PrecioMayoreo":
                                double.parse(_precioMayoreoController.text),
                            "Molde": molde,
                            "Materia": materia,
                            "Categoria": categoria
                          }).then((value) {
                            _precioMayoreoController.text = "";
                            _precioMenudeoController.text = "";
                            _nombreController.text = "";
                            selector = "";
                          });

                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.add_circle_rounded,
                            color: colorPrincipal),
                        label: Text(
                          "Agregar",
                          style: TextStyle(color: Colors.black),
                        )),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                margin: EdgeInsets.all(15),
                child: _buildTextField(
                    Icons.person_add, "Nombre", _nombreController),
              ),
              Container(
                margin: EdgeInsets.all(15),
                child: _buildTextFieldCantidad(Icons.attach_money,
                    "Precio Menudeo", _precioMenudeoController),
              ),
              Container(
                margin: EdgeInsets.all(15),
                child: _buildTextFieldCantidad(Icons.attach_money,
                    "Precio Mayoreo", _precioMayoreoController),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Tipo De Molde: $molde",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      // ignore: deprecated_member_use
                      child: RaisedButton.icon(
                        color: colorPrincipal,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.transparent)),
                        onPressed: () {
                          Navigator.pop(context);
                          buildAlert2(context);
                        },
                        label: Text(
                          "Selecciona un molde",
                          style: TextStyle(color: Colors.white),
                        ),
                        icon: Icon(
                          Icons.add,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                  decoration: BoxDecoration(
                      color: colorPrincipal,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      shape: BoxShape.rectangle),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          margin: EdgeInsets.all(5),
                          child: Column(
                            children: [
                              // ignore: deprecated_member_use
                              FlatButton(
                                padding: EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.elliptical(50, 75))),
                                color: colorPrincipal,
                                onPressed: () {
                                 setState(() {
                                   icono = false;
                                  surtido = false;
                                });
                                },
                                child: Text(
                                  "Normal",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                              icono == false
                                  ? Icon(Icons.circle,
                                      size: 15, color: Colors.white)
                                  : SizedBox(),
                            ],
                          )),
                      Container(
                          margin: EdgeInsets.all(5),
                          child: Column(
                            children: [
                              // ignore: deprecated_member_use
                              FlatButton(
                                padding: EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.elliptical(50, 75))),
                                color: colorPrincipal,
                                onPressed: () {
                                  setState(() {
                                   icono = true;
                                  surtido = true;
                                });
                                },
                                child: Text(
                                  "Surtido",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                              icono == true
                                  ? Icon(Icons.circle,
                                      size: 15, color: Colors.white)
                                  : SizedBox(),
                            ],
                          )),
                    ],
                  ),
                )
                  ],
                ),
              ),
            ],
          )),
        );
      }),
      direction: YudizModalSheetDirection.BOTTOM);
}

_buildTextField(
    IconData icon, String labelText, TextEditingController controllerPr) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
        color: Colors.white, border: Border.all(color: colorPrincipal)),
    child: TextField(
      controller: controllerPr,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        labelText: labelText,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        labelStyle: TextStyle(color: colorPrincipal),
        icon: Icon(icon, color: colorPrincipal),
      ),
    ),
  );
}

_buildTextFieldCantidad(
    IconData icon, String labelText, TextEditingController controllerPr) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
        color: Colors.white, border: Border.all(color: colorPrincipal)),
    child: TextField(
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.deny(new RegExp('[\\-|\\ ]'))
      ],
      controller: controllerPr,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        labelText: labelText,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        labelStyle: TextStyle(color: colorPrincipal),
        icon: Icon(icon, color: colorPrincipal),
      ),
    ),
  );
}

_buildInventario(DocumentSnapshot doc){
    return 
    Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: colorPrincipal,
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        padding: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '${doc.data()['nombre'].toString().toUpperCase()}',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                '',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              Row(),
            ]),
            IconButton(icon: Icon(Icons.check, color: Colors.green.shade900),
             onPressed: (){
               Navigator.pop(context);
               setState(() {
                 molde = doc.data()['nombre'];
               });
               buildAlert(context);
             })
          ],
        )
      );
  }

buildAlert2(BuildContext context) {
  YudizModalSheet.show(
      context: context,
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50))),
          height: MediaQuery.of(context).size.height - 150,
          child: Center(
              child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.all(15),
                    child: Text(
                      "Moldes",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: MediaQuery.of(context).size.height*0.7,
                
                child: ListView(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                          
            stream: FirebaseFirestore.instance.collection('Molde').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(children: snapshot.data.docs.map<Widget>((doc) => _buildInventario(doc)).toList());
                
              } else { 
                return SizedBox();
              }
            },
            
          ),
                  ],
                ),
              )
              
            ],
          )),
        );
      }),
      direction: YudizModalSheetDirection.BOTTOM);
}
}




