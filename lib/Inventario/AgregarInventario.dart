

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:yudiz_modal_sheet/yudiz_modal_sheet.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'VistaInventario.dart';


class  AgregarInventario extends StatefulWidget {
  AgregarInventario({Key key}) : super(key: key);

  @override
  _AgregarInventarioState createState() => _AgregarInventarioState();
}

//Imagen
String imgUrl;
//Subir Inventario
final _nombreController = TextEditingController();
final _precioMenudeoController = TextEditingController();
final _precioMayoreoController = TextEditingController();
final _cantidadController = TextEditingController();
String molde = "";
String selector = "";
bool cargando = false;
String downloadUrl;
String errorMessage = "Imagen Subida Correctamente";

class _AgregarInventarioState extends State<AgregarInventario> {
  //Metodo Subir Imagen
  uploadToStorage() {
    InputElement input = FileUploadInputElement()..accept = 'Inventario/*';
    FirebaseStorage fs = FirebaseStorage.instance;
    input.click();
    input.onChange.listen((event) {
      final file = input.files.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) async {
        setState(() {
                          cargando = true;
                        }); 
        var snapshot = await fs.ref().child('Inventario/'+_nombreController.text).putBlob(file);
         downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          imgUrl = downloadUrl;
          print("Down Url: "+imgUrl);
          cargando = false;
        });
        
      }).onError((){
        setState(() {
          errorMessage = "Error!";
        });
      });
    });
    
    
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
       body: _body(),
       appBar: AppBar(
        backgroundColor: colorPrincipal,
        elevation: 5,
        title: Text("Agregar Inventario"),
        centerTitle: true,
        
      ),
    );
  }
  //Build Moldes
_buildMoldes(DocumentSnapshot doc){


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
               setState(() {
                 molde = doc.data()['nombre'];
               });
               Navigator.of(context).pop();
             })
          ],
        )
      );
  }
  //Body
  Widget _body(){
    return ListView(
      children: [
        Container(
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
                            "NombreProducto": _nombreController.text,
                            "PrecioMenudeo":
                                double.parse(_precioMenudeoController.text),
                            "PrecioMayoreo":
                                double.parse(_precioMayoreoController.text),
                            "Cantidad": double.parse(_cantidadController.text),
                            "Molde": molde,
                            "Materia": materia,
                            "Categoria": categoria,
                            "Imagen": imgUrl
                          }).then((value) {
                            _precioMayoreoController.text = "";
                            _precioMenudeoController.text = "";
                            _nombreController.text = "";
                            _cantidadController.text = "";
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
                      margin: EdgeInsets.all(10),
                      height: MediaQuery.of(context).size.height*0.1,
                      child: downloadUrl == null ? FlatButton.icon(
                      icon: Icon(Icons.camera),
                      label: Text("Seleccione Una Imagen",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                        ),
                      ),
                      onPressed: () async {
                        uploadToStorage();
                      },
                    ):Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(errorMessage,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                        ),
                    ),
                    SizedBox(width: 8,),
                    Icon(Icons.check, color: Colors.green.shade700,)
                      ],
                    )
                    ),
                   cargando == true?
                   SpinKitFadingCube(
                    color: colorPrincipal,
                    size: 50.0,
                      ):SizedBox(),
                      downloadUrl != null?
              Container(
                margin: EdgeInsets.all(15),
                child: _buildTextFieldCantidad(Icons.attach_money,
                    "Precio Menudeo", _precioMenudeoController),
              ):SizedBox(),
              downloadUrl != null?
              Container(
                margin: EdgeInsets.all(15),
                child: _buildTextFieldCantidad(Icons.attach_money,
                    "Precio Mayoreo", _precioMayoreoController),
              ):SizedBox(),
              downloadUrl != null?
              Container(
                margin: EdgeInsets.all(15),
                child: _buildTextFieldCantidad(Icons.storage,
                    "Cantidad Inicial", _cantidadController),
              ):SizedBox(),
              downloadUrl != null?
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
                          moldes(context);
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
                    
                    
                  ],
                ),
              ):SizedBox(),
            ],
          )),
        )
      ],
    );
  }
  //Textfields
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



  moldes(BuildContext context) {
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
                return Column(children: snapshot.data.docs.map<Widget>((doc) => _buildMoldes(doc)).toList());
                
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