 
 

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:paleteria_marfel/HexaColors/HexColor.dart';
import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';
import 'package:yudiz_modal_sheet/yudiz_modal_sheet.dart';


class PedidosIda extends StatefulWidget {
  final String usuario;
  PedidosIda({Key key, this.usuario}) : super(key: key);

  @override
  _PedidosIdaState createState() => _PedidosIdaState();
}

Color colorPrincipal = HexColor("#3C9CA8");
String categoria;
int documents = 0;
TextEditingController _cantidadCarrito = TextEditingController();

class _PedidosIdaState extends State<PedidosIda> {

  @override
  void initState() {
    FirebaseFirestore.instance.collection("CarroPedidos").where("Usuario", isEqualTo: widget.usuario).snapshots().listen((result) {
      documents = 0;
      result.docs.forEach((result) {
        setState(() {
          documents = documents + 1;
          
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
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(left: 40,  top: 15,),
            child: Text("Categorias",
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold
            ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 35, right: 35, bottom: 5),
            height: MediaQuery.of(context).size.height*0.12,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                categorySelect("Bolis Agua", "assets/23.png"),
                categorySelect("Bolis Leche", "assets/25.png"),
                categorySelect("Bolito Agua", "assets/21.png"),
                categorySelect("Bolito Leche", "assets/22.png"),
              ],
            ),
          ),
          categoria == null ?
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Seleccione Una Categoria...",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),
                ),
                Image.asset("assets/marfelLoad.gif")
              ],
            ):
          Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(5),
                    child: ListView(
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          
            stream: FirebaseFirestore.instance.collection('Inventario')
            .where("Molde", isEqualTo: categoria)
            .snapshots(),
            builder: (context, snapshot) {
              return Column(children: snapshot.data.docs.map<Widget>((doc) => _buildPedidos(doc)).toList());
            },
            
          ),
                      ],
                    )
                    
                  ),
        ],
      ),
     floatingActionButton: FloatingActionButton.extended(
            onPressed: (){},
            icon: IconBadge(
                    icon: Icon(
                      Icons.shopping_cart,
                      size: 22,
                      color: Colors.white,
                    ),
                    itemCount: documents,
                    badgeColor: Colors.red,
                    itemColor: colorPrincipal,
                    hideZero: true,
                    onTap: () {
                      
                    },
                  ),
                  label: Text("Items"),
          )
    );
    
  }



  _buildPedidos(DocumentSnapshot doc){
    return Container(
      height: MediaQuery.of(context).size.height*0.12,
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
      margin: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.09,
            child: Image.network(doc.data()['Imagen']),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(doc.data()['NombreProducto'],
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold
          ),
          ),
          Text("Cantidad Actual: "+doc.data()['Cantidad'].toString(),
          style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 12,
            fontWeight: FontWeight.bold
          ),
          ),
          Text(doc.data()['Categoria'],
          style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 12,
            fontWeight: FontWeight.bold
          ),
          )
            ],
          ),
          IconButton(
            icon: Icon(Icons.add, size: 22, color: colorPrincipal),
            onPressed: (){
              addItems(context, doc);
            },
          )
        ],
      )
    );
  }

  Widget categorySelect(String selectCateg, String img){
    return InkWell(
      onTap: (){
        setState(() {
          categoria = selectCateg;
        });
      },
      child:
      Container(
              height: MediaQuery.of(context).size.height*0.09,
              width: MediaQuery.of(context).size.width*0.25,
              margin: const EdgeInsets.all(5), 
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
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height*0.065,
                    child: Image.asset(img),
                  ),
                  Text(selectCateg,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12
                  ),
                  )
                ],
              ),
                )
    );
  }

  addItems(BuildContext context, DocumentSnapshot doc) {
  YudizModalSheet.show(
      context: context,
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50))),
          height: MediaQuery.of(context).size.height * 0.2,
          child: Center(
              child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(doc.data()['NombreProducto'],
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                  ),
                  )
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height*0.05,
                width: MediaQuery.of(context).size.width*0.35,
                margin: EdgeInsets.only(left: 35, right: 35, top: 15, bottom: 15),
                child: textCantidad(),
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
                                                FirebaseFirestore.instance.collection("CarroPedidos").add({
                                                  "Nombre": doc.data()['NombreProducto'],
                                                  "Molde": doc.data()['Molde'],
                                                  "Cantidad": double.parse(_cantidadCarrito.text), 
                                                  "Categoria":  doc.data()['Categoria'],
                                                  "Usuario": widget.usuario

                                                }).then((value) => {
                                                  _cantidadCarrito.text = ""
                                                });
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
                                                    Icons.add,
                                                    color: Colors.blue.shade600,
                                                    size: 16.0,
                                                  ), // icon
                                                  Text("Agregar",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
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
                                                        fontSize: 12,
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
          )),
        );
      }),
      direction: YudizModalSheetDirection.BOTTOM);
}

  Widget textCantidad(){
  return TextField(
                                  
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(
                                          new RegExp('[\\-|\\ ]'))
                                    ],
                                    decoration: InputDecoration(
                                        hintText: "Cantidad (Pz)",
                                        suffixText: "0",
                                        hintStyle:
                                            TextStyle(color: colorPrincipal),
                                        fillColor:
                                            Colors.white.withOpacity(0.8),
                                        filled: true),
                                    controller: _cantidadCarrito,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14
                                    )
                                            );
}

}
   