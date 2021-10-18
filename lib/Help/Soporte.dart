

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paleteria_marfel/Seguridad/LockScreen.dart';
import 'package:yudiz_modal_sheet/yudiz_modal_sheet.dart';


class Soporte extends StatefulWidget {
  final String usuario;
  Soporte({Key key, this.usuario}) : super(key: key);

  @override
  _SoporteState createState() => _SoporteState();
}

final ventana = TextEditingController();
final problema = TextEditingController();

class _SoporteState extends State<Soporte> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarSoporte(),
      body: _bodySupport(), 
    );
  }
  Widget _bodySupport(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
              margin: EdgeInsets.all(15.0),
              height: 90,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: colorPrincipal,
                  borderRadius: BorderRadius.circular(10),
                  ),
              child: Column(
                children: <Widget>[
               
                  Container(

                      child: TextField(
                        controller: ventana,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      prefix: SizedBox(
                        child: Icon(
                          Icons.laptop_windows,
                          size: 18,
                          color: Colors.white,
                        ),
                        height: 15.0,
                        width: 15.0,
                      ),
                      labelText: "Ventana: ",
                      prefixStyle: TextStyle(color: Colors.white, fontSize: 15),
                      labelStyle: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  )),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(15.0),
              height: MediaQuery.of(context).size.height*0.2,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: colorPrincipal,
                  borderRadius: BorderRadius.circular(10),
                  ),
              child: Column(
                children: <Widget>[
               
                  Container(

                      child: TextField(
                        controller: problema,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      prefix: SizedBox(
                        child: Icon(
                          Icons.email,
                          size: 18,
                          color: Colors.white,
                        ),
                        height: 15.0,
                        width: 15.0,
                      ),
                      labelText: "Problema: ",
                      prefixStyle: TextStyle(color: Colors.white, fontSize: 15),
                      labelStyle: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  )),
                ],
              ),
            ),
            Container(
          height: MediaQuery.of(context).size.height*0.05,
          width: MediaQuery.of(context).size.width*0.6,
          margin: EdgeInsets.only(left: 15, right: 15),
          child: RaisedButton(
    textColor: colorPrincipal,
    color: Colors.white,
    child: Text("Agregar"),
    onPressed: () {
      FirebaseFirestore.instance.collection("Soporte").add({
        "Ventena": ventana.text,
        "Problema": problema.text,
        "Usuario": widget.usuario,
        "Dia": DateTime.now().day,
        "Mes": DateTime.now().month,
        "Año": DateTime.now().year
      }).then((value) => {
        ventana.text = "",
        problema.text = "",
        mensaje(context)
      });
    },
    shape:  RoundedRectangleBorder(
      borderRadius:  BorderRadius.circular(15.0),
    ),
  ),
        )
      ],
    );
  }
  Widget appBarSoporte(){
    return AppBar(
          title: Text('Soporte',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
          ),
          backgroundColor: colorPrincipal,
          centerTitle: true,

        );
  }

  mensaje(BuildContext context) {
    YudizModalSheet.show(
        context: context,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50))),
          height: 100,
          child: Center(
              child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Text(
                "Mensaje Enviado Correctamente!",
                style: (TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton.icon(
                      color: Colors.transparent,
                      elevation: 0,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.check_circle,
                        color: colorPrincipal,
                      ),
                      label: Text(
                        "Confirmar",
                        style: TextStyle(color: Colors.black),
                      )),
                ],
              )
            ],
          )),
        ),
        direction: YudizModalSheetDirection.BOTTOM);
  }
}