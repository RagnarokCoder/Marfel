

import 'package:flutter/material.dart';
import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';
import 'package:paleteria_marfel/HexaColors/HexColor.dart';


class PantallaInicio extends StatefulWidget {
  final String usuario;
  PantallaInicio({Key key, this.usuario}) : super(key: key);

  @override
  _PantallaInicioState createState() => _PantallaInicioState();
}

Color colorPrincipal = HexColor("#80DEEA");


class _PantallaInicioState extends State<PantallaInicio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
         appBar: AppBar(
         backgroundColor: colorPrincipal,
         elevation: 5,
         title: Text("Paletería Marfel"),
         centerTitle: true,
         
       ),
       drawer:  CustomAppBar(usuario: widget.usuario,),
      backgroundColor: colorPrincipal,
      body: Center(
        child: Container(
        height: MediaQuery.of(context).size.height*0.5,
        width: MediaQuery.of(context).size.width*0.5,
        child: Image.asset("assets/icono_provisional.png"),
      ),
      )
    );
  }
}