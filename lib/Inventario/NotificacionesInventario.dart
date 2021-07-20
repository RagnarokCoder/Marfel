

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yudiz_modal_sheet/yudiz_modal_sheet.dart';

import 'VistaInventario.dart';


class NotificacionesInventario extends StatefulWidget {
  final String categoria;
  NotificacionesInventario({Key key, this.categoria}) : super(key: key);

  @override
  _NotificacionesInventarioState createState() => _NotificacionesInventarioState();
}

class _NotificacionesInventarioState extends State<NotificacionesInventario> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrincipal,
        elevation: 5,
        title: Text("Notificaciones"),
        centerTitle: true,
        
      ),
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.8,
            child: StreamBuilder<QuerySnapshot>(
                              stream: 
                                   FirebaseFirestore.instance
                                      .collection('Inventario')
                                      .where("Pendiente", isEqualTo: true)
                                      .snapshots(),
                                 
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(children: [
                                        Column(
                                          children: snapshot.data.docs
                                              .map<Widget>(
                                                  (doc) => _buildNotificaciones(doc))
                                              .toList(),
                                        ),
                                       
                                      ]));
                                } else {
                                  return SizedBox();
                                }
                              },
                            ),
          )
        ],
      ),
    );
  }

  _buildNotificaciones(DocumentSnapshot doc)
  {
    return Container(
      height: MediaQuery.of(context).size.height*0.08,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
                 color: colorPrincipal,
                 borderRadius: BorderRadius.all(Radius.circular(15))
               ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.notifications_active, color: Colors.yellow.shade700,),
          Text("Cantidad: ${doc.data()['Cantidad']}\nLimitado: ${doc.data()['Limitar']}",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold
          ),
          ),
          IconButton(
            icon: Icon(Icons.check, color: Colors.green.shade600,),
            onPressed: (){
              limitarProducto(context, doc);
            },
          )
        ],
      ),
    );
  }

  limitarProducto(BuildContext context, DocumentSnapshot doc)
  {              
    YudizModalSheet.show(
    context: context,
    child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
      decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))
               ),
      height: MediaQuery.of(context).size.height*0.3,
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
                width: MediaQuery.of(context).size.width*0.6,
                child: Text("Marcar Como Leído!",
          style: TextStyle(
            color: colorPrincipal,
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
          ),
              )
            ],
          ),
          ),

         
                              Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      SizedBox.fromSize(
                                        size: Size(
                                            100, 50), // button width and height
                                        child: ClipRRect(
                                          child: Material(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            color: Colors.white, // button color
                                            child: InkWell(
                                              splashColor:
                                                  Colors.blue, // splash color
                                              onTap: () {
                                                  FirebaseFirestore.instance.collection("Inventario").
                                                  doc(doc.id).update({"Pendiente": false});
                                                  Navigator.of(context)
                                                      .pop();
                                              }, // button pressed
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.check,
                                                    color: Colors.green.shade600,
                                                    size: 16.0,
                                                  ), // icon
                                                  Text("Confirmar",
                                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold
                                      )), // text
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      
                                      SizedBox.fromSize(
                                        size: Size(
                                            100, 50), // button width and height
                                        child: ClipRRect(
                                          child: Material(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            color: Colors.white, // button color
                                            child: InkWell(
                                              splashColor:
                                                  Colors.blue, // splash color
                                              onTap: () {
                                                Navigator.of(context)
                                                    .pop();
                                                    setState(() {
                                                   
                                                  });
                                                    
                                              }, // button pressed
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.close,
                                                    color: Colors.red.shade600,
                                                    size: 16.0,
                                                  ), // icon
                                                  Text("Cancelar",
                                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold
                                      )), // text
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      
                                    ],
                                  ),
                                
            
                                    
           
            
            
          ],
        )
      ),
    );
    }),
    direction: YudizModalSheetDirection.BOTTOM);
  }

}