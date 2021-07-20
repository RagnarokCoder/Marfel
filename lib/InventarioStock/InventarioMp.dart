

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:yudiz_modal_sheet/yudiz_modal_sheet.dart';



class InventarioMp extends StatefulWidget {
  InventarioMp({Key key}) : super(key: key);

  @override
  _InventarioMpState createState() => _InventarioMpState();
}
NumberFormat f = new NumberFormat("#,##0.00", "es_US");
bool icono = false;
TextEditingController _cantidadProc = TextEditingController();

class _InventarioMpState extends State<InventarioMp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
       appBar: AppBar(
         backgroundColor: colorPrincipal,
         elevation: 5,
         title: icono == true? Text("Materia Prima"): Text("Por Procesar"),
         centerTitle: true,
         
       ),
       drawer: CustomAppbar(),
       body: ListView(
         children: [
           icono == true?
           Container(
             height: MediaQuery.of(context).size.height*0.75,
             child: ListView(
               children: [
                 StreamBuilder<QuerySnapshot>(
                          
            stream:  FirebaseFirestore.instance.collection('InventarioMP').snapshots(),
            builder: (context, snapshot) {
              return Column(children: snapshot.data.docs.map<Widget>((doc) => _buildInventario(doc)).toList());
            },
            
          ),
               ],
             ),
           ):
           Container(
             height: MediaQuery.of(context).size.height*0.75,
             child: ListView(
               children: [
                 StreamBuilder<QuerySnapshot>(
                          
            stream:  FirebaseFirestore.instance.collection('Compras').where("Pendiente", isEqualTo: true).snapshots(),
            builder: (context, snapshot) {
              return Column(children: snapshot.data.docs.map<Widget>((doc) => _buildComprasPendientes(doc)).toList());
            },
            
          ),
               ],
             ),
           )
         ],
       ),
       bottomNavigationBar: Container(
      height: MediaQuery.of(context).size.height*0.1,
      decoration: BoxDecoration(
        color: Colors.white,
        
      ),
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
        decoration: BoxDecoration(
                color: colorPrincipal,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                shape: BoxShape.rectangle
              ),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.elliptical(50,75))),
              color: colorPrincipal,
              onPressed: () {
                
                icono = false;
                setState(() {
                  
                });
                
              },
              child: Text("Por Procesar",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16
              ),
              ),
            ),
            icono == false?
            Icon(Icons.circle, size: 15, color: Colors.white) : SizedBox(),
                      ],
                    )
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        // ignore: deprecated_member_use
                        FlatButton(
                    padding: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.elliptical(50,75))),
              color: colorPrincipal,
              onPressed: () {
                
                icono = true;
                setState(() {
                  
                });
              },
              child: Text("Materia Prima",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16
              ),
              ),
            ),
            icono == true?
            Icon(Icons.circle, size: 15, color: Colors.white) : SizedBox(),
                      ],
                    )
                  ),
                ],
              ),
      )
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
            Radius.circular(40.0),
          ),
        ),
        padding: const EdgeInsets.only(
          left: 32,
          top: 50.0,
          bottom: 50,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${doc.data()['Producto'].toString().toUpperCase()}',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                '${f.format(doc.data()['Cantidad'])} Kg',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              Row(),
            ]),
            IconButton(icon: Icon(Icons.more_horiz, color: Colors.white),
             onPressed: (){
               buildAlert(context, doc);
             })
          ],
        )
      );
  }
  buildAlert(BuildContext context, DocumentSnapshot doc)
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
      height: MediaQuery.of(context).size.height*0.7,
      child: Center(
        child: Column(
          children: [
          
            

            Container(
              height: MediaQuery.of(context).size.height*0.35,
              width: MediaQuery.of(context).size.width,
              
              child: InteractiveViewer(
                child: FadeInImage.assetNetwork(
                  width: MediaQuery.of(context).size.width,
          placeholder: 'assets/marfelLoad.gif',
          image:"${doc.data()['Imagen']}"
              )
            ),
            ),
            
                                    
            Container(
              height: MediaQuery.of(context).size.height*0.07,
              width: MediaQuery.of(context).size.width*0.8,
              margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.blueGrey.shade50,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: Container(
                margin: EdgeInsets.all(10),
                child: Column(
                children: [
                  Text("${doc.data()['Producto']}", style: (
                                      TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black
                                      )
                                    ),),
            
                ],
              ),
              )
            ),
            Container(
              height: MediaQuery.of(context).size.height*0.12,
              width: MediaQuery.of(context).size.width*0.8,
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10), //Same as `blurRadius` i guess
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  
            Text("- ${f.format(doc.data()['Cantidad'])} Kg", style: (
                                      TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black
                                      )
                                    ),),

                                   
                ],
              ),
              )
            ),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton.icon(
                shape: RoundedRectangleBorder(
      borderRadius:  BorderRadius.circular(15.0),
   ),
                color: Colors.white,
                elevation: 5,
                onPressed: (){
                  
                 
                  Navigator.pop(context);
                }, 
                icon: Icon(Icons.close, color: Colors.red.shade600), 
                label: Text("Cerrar", style: TextStyle(color: Colors.black),)),
                
                
              ],
            ),
            
            
          ],
        )
      ),
    );
    }),
    direction: YudizModalSheetDirection.BOTTOM);
  }

  _buildComprasPendientes(DocumentSnapshot doc){
    return 
    Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: colorPrincipal,
          borderRadius: const BorderRadius.all(
            Radius.circular(40.0),
          ),
        ),
        padding: const EdgeInsets.only(
         
          top: 20.0,
          bottom: 20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '${doc.data()['Producto'].toString().toUpperCase()}',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                '${f.format(doc.data()['Cantidad'])} ${doc.data()['UnidadMedida']}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              ConfirmationSlider(
              icon: (Icons.arrow_right_alt),
              iconColor: colorPrincipal,
              backgroundColor: colorPrincipal,
              backgroundColorEnd: Colors.white,
              foregroundColor: Colors.white,
              text: "Procesar",
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold
              ),
            onConfirmation: ()  {
              addProcescompr(context, doc);
              
            },
        ),
            ]),
            
          ],
        )
      );
  }

   addProcescompr(BuildContext context, DocumentSnapshot doc)
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
              Text("Poner El Peso en Kilogramos ",
          style: TextStyle(
            color: colorPrincipal,
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
          ),
            ],
          ),
          ),

         Container(
                                height: MediaQuery.of(context).size.height*0.05,
                                width: MediaQuery.of(context).size.width*0.5,
                                child: TextField(
                                      minLines: 5,
                                      maxLines: 15,
                                      decoration: new InputDecoration(
                                        
                                            
                                          
                                          fillColor:
                                              Colors.white.withOpacity(0.8),
                                          filled: true,
                                          suffixText: ""),
                                      controller: _cantidadProc,
                                      style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold
              ),),
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
                                                print(doc.data()['Producto']);
                                                  DocumentReference documentReference =
                FirebaseFirestore.instance.collection("InventarioMP").doc(doc.data()['Producto']);
            documentReference.get().then((result) {
              if (result.exists) {
                dynamic cantidadActual = result.data()['Cantidad'];
                print("Cantidad Actual: $cantidadActual");
                cantidadActual += double.parse(_cantidadProc.text);
                print("Cantidad Nueva: $cantidadActual");
                FirebaseFirestore.instance.collection("InventarioMP").doc(doc.data()['Producto']).update({
                       "Cantidad": cantidadActual,
                     });

               
              }
              else{
                FirebaseFirestore.instance.collection("InventarioMP").doc(doc.data()['Producto']).set({
                       "Cantidad": double.parse(doc.data()['Cantidad']),
                       "Producto": doc.data()['Producto'],
                     });
              }
            }).then((value) => {
              _cantidadProc.text="",
              FirebaseFirestore.instance.collection("Compras").doc(doc.id).update({"Pendiente": false})
            });

                                                  Navigator.of(context)
                                                      .pop();
                                              }, // button pressed
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.add,
                                                    color: Colors.blue.shade600,
                                                    size: 16.0,
                                                  ), // icon
                                                  Text("Agregar",
                                                      style:  TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold
              ),), // text
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
                                                  Text("Cerrar",
                                                      style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold
              ),), // text
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