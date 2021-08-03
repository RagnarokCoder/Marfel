

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
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
         backgroundColor: Colors.white,
         centerTitle: true,
         elevation: 0,
         leading: IconButton(
          icon: Icon(Icons.menu, color: colorPrincipal),
          onPressed: () {
            Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.leftToRight,
                                child: CustomAppBar(
                                  usuario: widget.usuario,
                                )));
          },
        ),
      
       ),
     
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Image.asset("assets/marfelLogoProt.png"),
      ),
      )
    );
  }
}