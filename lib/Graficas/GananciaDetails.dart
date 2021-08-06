

import 'package:flutter/material.dart';
import 'package:paleteria_marfel/HexaColors/HexColor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class  GananaciasDetails extends StatefulWidget {
  final int mes, year;
  final String mesSel, coleccion;
  GananaciasDetails({Key key, this.mes, this.year, this.mesSel, this.coleccion}) : super(key: key);

  @override
  _GananaciasDetailsState createState() => _GananaciasDetailsState();
}

NumberFormat f = new NumberFormat("#,##0.00", "es_US");
Color colorPrincipal = HexColor("#3C9CA8");
Color colorVentas = HexColor("#FFD700");
Color colorGastos = HexColor("#115173");
Color colorCompras = HexColor("#E94560");

class _GananaciasDetailsState extends State<GananaciasDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrincipal,
      appBar: AppBar(
        backgroundColor: colorPrincipal,
        centerTitle: true,
        title: Text("${widget.coleccion} ${widget.mesSel}",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16
        ),
        ),
      ),
       body: Container(
         
         margin: EdgeInsets.only(left: 10, right: 10),
         height: MediaQuery.of(context).size.height,
         child: ListView(
           children: [
             StreamBuilder<QuerySnapshot>(
                          
            stream: FirebaseFirestore.instance.collection('${widget.coleccion}')
            .where("Mes", isEqualTo: widget.mes).where("Año", isEqualTo: widget.year).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(children: snapshot.data.docs.map<Widget>((doc) => _buildListItem(doc)).toList());
                
              } else { 
                return SizedBox();
              }
            },
            
          ),
           ],
         )
       ),
    );
  }
   _buildListItem(DocumentSnapshot doc) {
     dynamic compra, venta, gasto;
     String fecha ="${doc.data()['Dia']}/${doc.data()['Mes']}/${doc.data()['Año']}";
     if(doc.data()['Costo'] != null)
     {
       compra = doc.data()['Costo'];
     }
     else{
       compra = 0;
     }
     if(doc.data()['Total'] != null)
     {
       venta = doc.data()['Total'];
     }
     else{
       venta = 0;
     }
     if(doc.data()['Cantidad'] != null)
     {
       gasto = doc.data()['Cantidad'];
     }
     else{
       gasto = 0;
     }
    return Container(
      margin: EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height*0.1,
      color: colorPrincipal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          Row(
            children: [
              compra!=0?Container(
                        height: 15,
                        width: 15,
                        color: colorCompras,
                      ):
                      venta!=0?
                      Container(
                        height: 15,
                        width: 15,
                        color: colorVentas,
                      ):
                      gasto!=0?
                      Container(
                        height: 15,
                        width: 15,
                        color: colorGastos,
                      ):SizedBox(),
                      SizedBox(width: 10,),
              compra!=0?Text("\$"+
            f.format(compra).toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold
            ),
          ):
          venta!=0?Text("\$"+
            f.format(venta).toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold
            ),
          ):
          gasto!=0?Text("\$"+
            f.format(gasto).toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold
            ),
          ):
          SizedBox()
            ],
          ),
          Text("$fecha",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold
            ),)
        ],
      ),
    );
          
    
  }
}