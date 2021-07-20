

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Amonestar.dart';


class DetallesPersonal extends StatefulWidget {
  final String empleado;
  DetallesPersonal({Key key, this.empleado}) : super(key: key);

  @override
  _DetallesPersonalState createState() => _DetallesPersonalState();
}

int laboral=0;
int social=0;

class _DetallesPersonalState extends State<DetallesPersonal> {

   @override
  void initState() {
     FirebaseFirestore.instance.collection("Personal").where("Nombre", isEqualTo: widget.empleado).snapshots().listen((result) {
       laboral = 0;
       social = 0;
      result.docs.forEach((result) {
        setState(() {
          if(result.data()['TipoAmonestacion'] == 0)
          {
            laboral = laboral + 1;
          }
          else
          {
            social = social + 1;
          }
          print(social);
        });
      });
    });

    super.initState();
  }


 


  @override
  Widget build(BuildContext context) {
    return Scaffold(
         appBar: AppBar(
         backgroundColor: colorPrincipal,
         elevation: 5,
         title: Text("Detalles Personal"),
         centerTitle: true,
         
       ),
       body: Container(
         height: MediaQuery.of(context).size.height,
         color: Colors.white,
         child: Column(
           mainAxisAlignment: MainAxisAlignment.spaceAround,
           children: [
             Center(
               child: Text(widget.empleado,
               style: TextStyle(
                 color: Colors.black,
                 fontSize: 18,
                 fontWeight: FontWeight.bold
               ),
               ),
             ),
              
             laboral != 0?
             Container(
              
               height: MediaQuery.of(context).size.height*0.25,
               child: ListView(
               children: [
                 Column(
                   children: [
                     Center(
               child: Text("Amonestaciones Laborales",
               style: TextStyle(
                 color: Colors.black,
                 fontSize: 16,
                 fontWeight: FontWeight.bold
               ),
               ),
             ),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     for(int i = 1; i<=laboral; i++)
                     amonestacionSocial()
                   ],
                 ),
                   ],
                 ),
                 StreamBuilder<QuerySnapshot>(
                          
            stream: FirebaseFirestore.instance.collection('Personal').where("Nombre", isEqualTo: widget.empleado)
            .where("TipoAmonestacion", isEqualTo: 0)
            .snapshots(),
            builder: (context, snapshot) {
              return Column(children: snapshot.data.docs.map<Widget>((doc) => _buildListItem(doc)).toList());
            },
            
          ),
               ],
             ),
             ):SizedBox(),
             
             social != 0?
             Container(
               
               height: MediaQuery.of(context).size.height*0.25,
               child: ListView(
               children: [
                 Column(
                   children: [
                     Center(
               child: Text("Amonestaciones Sociales",
               style: TextStyle(
                 color: Colors.black,
                 fontSize: 16,
                 fontWeight: FontWeight.bold
               ),
               ),
             ),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     for(int i = 1; i<=social; i++)
                     iconoAmonestacion()
                   ],
                 ),
                   ],
                 ),
                 StreamBuilder<QuerySnapshot>(
                          
            stream: FirebaseFirestore.instance.collection('Personal').where("Nombre", isEqualTo: widget.empleado)
            .where("TipoAmonestacion", isEqualTo: 1)
            .snapshots(),
            builder: (context, snapshot) {
              return Column(children: snapshot.data.docs.map<Widget>((doc) => _buildListItem(doc)).toList());
            },
            
          ),
               ],
             ),
             ):SizedBox()
             
           ],
         ),
       ),
    );
  }


  _buildListItem(DocumentSnapshot doc) {
     
     int amonestacion = doc.data()['TipoAmonestacion'];
     
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: colorPrincipal,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
        height: MediaQuery.of(context).size.height*0.08,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            amonestacion == 0?
            amonestacionSocial():iconoAmonestacion(),
            Container(
              width: MediaQuery.of(context).size.width*0.5,
              child: Text("${doc.data()['Motivo']}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold
              ),
              ),
            ),
            SizedBox()
          ],
        ),
      )
      
    );
    
  }

  Icon amonestacionSocial() => Icon(Icons.arrow_drop_up_sharp, color: Colors.purple, size: 35,);
  Icon iconoAmonestacion() => Icon(Icons.circle, color: Colors.pink);


}