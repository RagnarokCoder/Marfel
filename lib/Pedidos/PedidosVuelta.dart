

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';
import 'package:paleteria_marfel/HexaColors/HexColor.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:yudiz_modal_sheet/yudiz_modal_sheet.dart';


class PedidosVuelta extends StatefulWidget {
  final String usuario;
  PedidosVuelta({Key key, this.usuario}) : super(key: key);

  @override
  _PedidosVueltaState createState() => _PedidosVueltaState();
}

Color colorPrincipal = HexColor("#3C9CA8");
int diaSel, mesSel, yearSel;
String status = "Pendiente";

class _PedidosVueltaState extends State<PedidosVuelta> {
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
              'Pedidos',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(),
            SizedBox()
          ],
        ),
        
      ),
      drawer: CustomAppBar(usuario: widget.usuario,),
       body: _bodyPedidos()
    );
  }

  Widget _bodyPedidos(){
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: ListView(
      children: [
        listaStatus(),
        Container(
                    height: MediaQuery.of(context).size.height * 0.75,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(5),
                    child: ListView(
                      children: [
                        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Pedidos')
            .where(status, isEqualTo: true)
            .snapshots(),
            builder: (context, snapshot) {
              return Column(children: snapshot.data.docs.map<Widget>((doc) => _buildStatusPedidos(doc)).toList());
            },
          ),
                      ],
                    )
                  ),
      ],
    ),
    );
  }

  _buildStatusPedidos(DocumentSnapshot doc){
    String status;

    if(doc.data()['Pendiente'] != null)
    {
      status = "Pendiente";
    }
    if(doc.data()['En Proceso'] != null)
    {
      status = "En Proceso";
    }
    if(doc.data()['En Camino'] != null)
    {
      status = "En Camino";
    }
    if(doc.data()['Terminado'] != null)
    {
      status = "Terminado";
    }


    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height*0.2,
      width: MediaQuery.of(context).size.width*0.8,
      decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Center(
            child: Text(doc.data()['Dia'].toString()+"/"+doc.data()['Mes'].toString()+"/"+doc.data()['Año'].toString(),
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 13,
              fontWeight: FontWeight.bold
            ),
            )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.circle,
              size: 18,
              color: 
              status == "Pendiente" ? Colors.red.shade700:
              status == "En Proceso" ? Colors.yellow.shade700:
              status == "En Camino" ? Colors.blue.shade700:
              status == "Terminado" ? Colors.green.shade700:Colors.white
              ),
              SizedBox(
                width: 8,
              ),
              Text(status,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
            ),
            ],
          ),
          
          RaisedButton.icon(
            elevation: 0,
            color: Colors.white,
            icon: Icon(Icons.more_horiz, color: colorPrincipal,),
            label: Text("Detalles", 
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold
            ),
            ),
            onPressed: (){
              detallesPedido(context, doc, status);
            },
          )
        ],
      ),
    );
  }

  detallesPedido(BuildContext context, DocumentSnapshot doc, String status){
    Map <dynamic, dynamic> auxMap = doc.data()['Productos'];
    YudizModalSheet.show(
    context: context,
    child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
      decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))
               ),
      height: MediaQuery.of(context).size.height*0.55,
      child: Center(
        child: Column(
          children: [                      
            Container(
              height: MediaQuery.of(context).size.height*0.3,
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
                  for (var i in auxMap.keys)
                  Text(auxMap[i]['Molde']+" - "+auxMap[i]['Nombre']+" - "+auxMap[i]['Piezas'].toString(), style: (
                                      TextStyle(
                                        fontSize: 15,
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
                  
            Text(status, style: (
                                      TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black
                                      )
                                    ),),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text("${doc.data()['Dia']}/${doc.data()['Mes']}/${doc.data()['Año']}",
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold
                                        ),
                                        )
                                      ],
                                    )
                ],
              ),
              )
            ),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                
                ConfirmationSlider(
                    text: 
                    doc.data()['Pendiente'] != null ? "Comenzar Pedido":
                    doc.data()['En Proceso'] != null ?"Enviar Pedido":
                    doc.data()['En Camino'] != null ?"Finalizar Pedido":"Agregar a Inventario",
                    textStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12
                    ),
                    foregroundColor: colorPrincipal,
                    onConfirmation: (){
                      doc.data()['Pendiente'] != null ?
                      FirebaseFirestore.instance.collection("Pedidos").doc(doc.id).update({
                        "Pendiente": null,
                        "En Proceso": true
                      }):
                      doc.data()['En Proceso'] != null ?
                      FirebaseFirestore.instance.collection("Pedidos").doc(doc.id).update({
                        "En Proceso": null,
                        "En Camino": true
                      }):
                      doc.data()['En Camino'] != null ?
                      FirebaseFirestore.instance.collection("Pedidos").doc(doc.id).update({
                        "En Camino": null,
                        "Terminado": true
                      }):
                      auxMap.forEach((key, value) { 
                        DocumentReference documentReference =
                FirebaseFirestore.instance.collection("Inventario").doc(key);
            documentReference.get().then((datasnapshot) {
              if (datasnapshot.exists) {
                print(datasnapshot.data()['Cantidad'].toString());
                dynamic agregarCantidad = datasnapshot.data()['Cantidad'] + auxMap[key]['Piezas'];
                FirebaseFirestore.instance.collection("Inventario").doc(key).update({"Cantidad": agregarCantidad});
                FirebaseFirestore.instance.collection("Pedidos").doc(doc.id).update({"Terminado": null});
              }
              else{
                print("No Existe");
              }
            });

                      });
                      Navigator.of(context).pop();
                    },
                  ) 
              ],
            ), 
          ],
        )
      ),
    );
    }),
    direction: YudizModalSheetDirection.BOTTOM);


}

  Widget listaStatus(){
    
    return Container(
          margin: EdgeInsets.only(left: 35, right: 35, bottom: 10),
          padding: EdgeInsets.all(15),
          height: MediaQuery.of(context).size.height*0.1,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              itemsStatus(
                (){
                  setState(() {
                    status = "Pendiente";
                  });
                },
                "Pendiente",Icon(Icons.circle, color: Colors.red.shade700, size: 18,)
              ),
              itemsStatus(
                (){
                  setState(() {
                    status = "En Proceso";
                  });
                },
                "En Proceso",Icon(Icons.circle, color: Colors.yellow.shade700, size: 18,)
              ),
              itemsStatus(
                (){
                  setState(() {
                    status = "En Camino";
                  });
                },
                "En Camino",Icon(Icons.circle, color: Colors.blue.shade700, size: 18,)
              ),
              itemsStatus(
                (){
                  setState(() {
                    status = "Terminado";
                  });
                },
                "Terminado",Icon(Icons.circle, color: Colors.green.shade700, size: 18,)
              )
            ],
          ),
        );
  }

  Widget itemsStatus(Function function, String titulo, Icon icon){
    return InkWell(
               child: Container(
               margin: EdgeInsets.only(left: 10),
               height: 50,
               width: MediaQuery.of(context).size.width*0.3,
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(15),
                 color: colorPrincipal
               ),
               child: Center(
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: [
                     icon,
                     Text(titulo,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold
                ),
               ),
                   ],
                 ),
               )
             ),
             onTap: function,
             );
  }

}