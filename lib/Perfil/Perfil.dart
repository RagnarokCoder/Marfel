

import 'package:flutter/material.dart';
import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';


class Perfil extends StatefulWidget {
  final String usuario;
  Perfil({Key key, this.usuario}) : super(key: key);

  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrincipal,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(),
            Text(
              'Perfil',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(),
            SizedBox()
          ],
        ),
        
      ),
      drawer: CustomAppBar(usuario: widget.usuario,),
      body: _bodyPrincipal()
    );
  }

  Widget _bodyPrincipal(){
    return ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.08,
          ),
          Container(
            height: MediaQuery.of(context).size.height*0.2,
            child: Row(
              children: [
                 Stack(
  clipBehavior: Clip.none,
  children: [
    Container(
        width: MediaQuery.of(context).size.width*0.9,
       margin: EdgeInsets.all(10),
      child: Material(
        borderRadius: BorderRadius.only(
      topLeft: Radius.circular(15),
      topRight: Radius.circular(150),
      bottomLeft: Radius.circular(15),
      bottomRight: Radius.circular(15)
      ),
      elevation: 10,
       
      child: Container(
          decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
      topLeft: Radius.circular(25),
      topRight: Radius.circular(25),
      bottomLeft: Radius.circular(25),
      bottomRight: Radius.circular(25)
      ),
      color: Colors.white,
      ),
          
      alignment: Alignment.centerRight,
      width: MediaQuery.of(context).size.width*0.7,
      height: MediaQuery.of(context).size.height*0.8,
      child: RotatedBox(
        quarterTurns: 1,
        
      ),
    ),
    ),
    ),
    
    
    Positioned(
      top: -40,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width*0.3,
        height: MediaQuery.of(context).size.height*0.2,
        child: Image.asset("assets/adminp.png")
      ),
    ),
    
    
    
  ],
)
              ],
            ),
          )
        ],
      );
  }

}