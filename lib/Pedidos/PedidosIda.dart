 
 

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:intl/intl.dart';
import 'package:paleteria_marfel/HexaColors/HexColor.dart';
import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
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
List<String> nombresCarrito = [];
List<dynamic> cantidadItem = [];
Map<String, dynamic> productos = {};
bool body = false;
int dia, mes, year;

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
      body: body == false ? _bodyCrearPedidos() : _bodyPedidos(),
      floatingActionButton: body == false ? FloatingActionButton(
       backgroundColor: Colors.white,
            onPressed: (){
              carritoItems(context);
            },
            child: IconBadge(
                    icon: Icon(
                      Icons.shopping_cart,
                      size: 22,
                      color: colorPrincipal,
                    ),
                    itemCount: documents,
                    badgeColor: Colors.red,
                    itemColor: Colors.white,
                    hideZero: true,
                    onTap: () {
                      
                    },
                  ),
                  
          ):SizedBox()
    );
    
  }

  Widget _bodyCrearPedidos(){
    return ListView(
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
          Container(
            padding: EdgeInsets.only(left: 10),
            height: MediaQuery.of(context).size.height*0.1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton.icon(
                  elevation: 5,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  ),
                  icon: Icon(FontAwesomeIcons.peopleCarry, size: 18,),
                  label: Text("Pedidos",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                  onPressed: (){
                    setState(() {
                      body = true;
                    });
                  },
                )
              ],
            ),
          )
        ],
      );
  }

  Widget _bodyPedidos(){
    return ListView(
      children: [
        Container(
                    height: MediaQuery.of(context).size.height * 0.75,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(5),
                    child: ListView(
                      children: [
                        Container(
                  height: 40.0,
                  width: 40.0,
                  
                  child: Center(
                    child: IconButton(icon: Icon(Icons.date_range, color: Colors.black), onPressed: ()
                    {
                      showDatePicker(context: context, initialDate: DateTime.now(), 
                                   helpText: "Seleccione una fecha",
                                    builder: (BuildContext context, Widget child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.dark(
                    primary: Colors.white, //color botones
                    onPrimary: colorPrincipal,
                    surface: colorPrincipal.withOpacity(0.5),
                    onSurface: Colors.white,
                    
                    ),
                dialogBackgroundColor: colorPrincipal,
                buttonColor: Colors.white,
                
              ),
              child: child,
            );
            
          },
                                   firstDate: DateTime(2001), lastDate: DateTime(2222)).then((date){
                                   dia =  int.parse(DateFormat('dd').format(date));
                                   mes  = int.parse(DateFormat('MM').format(date));
                                   year = int.parse(DateFormat('yyyy').format(date));
                                   setState(() {
                                     
                                   });  
                                   });    

                    }),
                  ),
                ),
                        StreamBuilder<QuerySnapshot>(
                          
            stream: FirebaseFirestore.instance.collection('Pedidos')
            .where('Dia', isEqualTo: dia).where('Mes', isEqualTo: mes).where('Año', isEqualTo: year)
            .snapshots(),
            builder: (context, snapshot) {
              return Column(children: snapshot.data.docs.map<Widget>((doc) => _buildStatusPedidos(doc)).toList());
            },
            
          ),
                      ],
                    )
                    
                  ),
          Container(
            padding: EdgeInsets.only(left: 10),
            height: MediaQuery.of(context).size.height*0.1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton.icon(
                  elevation: 5,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  ),
                  icon: Icon(FontAwesomeIcons.cartPlus, size: 18,),
                  label: Text("Crear Pedidos",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                  onPressed: (){
                    setState(() {
                      body = false;
                    });
                  },
                )
              ],
            ),
          )
      ],
    );
  }

  _buildPedidos(DocumentSnapshot doc){
    String nombre;

    if(doc.data()['NombreProducto'] != null)
    nombre = doc.data()['NombreProducto'];
    else
    nombre = doc.data()['Nombre'];

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
            child: FadeInImage(image: NetworkImage(doc.data()['Imagen']), placeholder: AssetImage("assets/marfelLoad.gif"))
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(nombre,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold
          ),
          ),
          Text(doc.data()['NombreProducto'] != null ?"Cantidad Actual: "+doc.data()['Cantidad'].toString():doc.data()['Cantidad'].toString(),
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
          doc.data()['NombreProducto'] != null?
          IconButton(
            icon: Icon(Icons.add, size: 22, color: colorPrincipal),
            onPressed: (){
              addItems(context, doc);
            },
          ):IconButton(
            icon: Icon(Icons.delete, size: 22, color: Colors.red.shade700),
            onPressed: (){
              deleteData(context, doc, doc.data()['Id']);
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
                                                productos.addAll({doc.id:
                                                 {
                                                   "Piezas": double.parse(_cantidadCarrito.text),
                                                   "Nombre": doc.data()['NombreProducto'],
                                                   "Molde": doc.data()['Molde'],
                                                 }});
                                                
                                                FirebaseFirestore.instance.collection("CarroPedidos").add({
                                                  "Nombre": doc.data()['NombreProducto'],
                                                  "Molde": doc.data()['Molde'],
                                                  "Cantidad": double.parse(_cantidadCarrito.text), 
                                                  "Categoria":  doc.data()['Categoria'],
                                                  "Usuario": widget.usuario,
                                                  "Imagen": doc.data()['Imagen'],
                                                  "Id": doc.id.toString()
                                                }).then((value) => {
                                                  _cantidadCarrito.text = ""
                                                });
                                                Navigator.of(context).pop();
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

  carritoItems(BuildContext context){
    return YudizModalSheet.show(
      context: context,
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50))),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
              child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text("Carrito De Pedidos",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                  )
                ],
              ),
              Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(5),
                    child: ListView(
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          
            stream: FirebaseFirestore.instance.collection('CarroPedidos')
            .where("Usuario", isEqualTo: widget.usuario)
            .snapshots(),
            builder: (context, snapshot) {
              if(snapshot.hasData)
              {
                return Column(children: snapshot.data.docs.map<Widget>((doc) => _buildPedidos(doc)).toList());
              }
              else
              {
                return Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Agregue Productos Al Carrito",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14
                ),
                ),
                Image.asset("assets/marfelLoad.gif")
              ],
            );
              }
            },
            
          ),
                      ],
                    )
                    
                  ),
                  Divider(
                    height: 12,
                    color: Colors.black,
                    indent: 30,
                    endIndent: 30,
                    thickness: 1.1,
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
                                                 FirebaseFirestore.instance.collection("Pedidos").add({
                                                   "Productos": productos,
                                                   "Dia": DateTime.now().day,
                                                   "Mes": DateTime.now().month,
                                                   "Año": DateTime.now().year,
                                                   "Pendiente": true
                                                 }).then((value) => {
                                                   correctData(context),
                                                   deleteAll()
                                                 });    
                                              }, // button pressed
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    FontAwesomeIcons.peopleCarry,
                                                    color: Colors.blue.shade600,
                                                    size: 16.0,
                                                  ), // icon
                                                  Text("Generar Pedido",
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

  deleteData(BuildContext context, DocumentSnapshot doc, String documento){
      return YudizModalSheet.show(
      context: context,
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50))),
          height: MediaQuery.of(context).size.height * 0.15,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("¿Quieres Eliminar Este Producto?",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold
              ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FlatButton.icon(
                    color: Colors.white,
                    icon: Icon(Icons.delete, color: Colors.red.shade700, size: 22),
                    onPressed: (){
                      FirebaseFirestore.instance.collection("CarroPedidos").doc(doc.id).delete();
                      productos.removeWhere((key, value) => key == documento);
                      print(doc.id);
                      setState(() {
                        print(productos);
                      });
                      Navigator.of(context).pop(); 
                    },
                    label: Text("Borrar",
                    style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.bold
              ),
                    ),
                  ),
                  FlatButton.icon(
                    color: Colors.white,
                    icon: Icon(Icons.cancel, color: Colors.red.shade700, size: 22),
                    onPressed: (){
                      Navigator.of(context).pop(); 
                    },
                    label: Text("Cancelar",
                    style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.bold
              ),
                    ),
                  )
                ],
              )
            ],
          ),
        );
      }),
      direction: YudizModalSheetDirection.TOP);
  }

  correctData(BuildContext context){
    return YudizModalSheet.show(
      context: context,
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50))),
          height: MediaQuery.of(context).size.height * 0.15,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Orden Creada!",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold
              ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FlatButton.icon(
                    color: Colors.white,
                    icon: Icon(Icons.check, color: Colors.green.shade700, size: 22),
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    label: Text("Confirmar",
                    style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.bold
              ),
                    ),
                  ),
                  
                ],
              )
            ],
          ),
        );
      }),
      direction: YudizModalSheetDirection.TOP);
  }

  deleteAll(){
    productos.clear();
    documents = 0;
    FirebaseFirestore.instance
        .collection("CarroPedidos")
        .where("Usuario", isEqualTo : widget.usuario)
        .get().then((value){
          value.docs.forEach((element) {
           FirebaseFirestore.instance.collection("CarroPedidos").doc(element.id).delete().then((value){
             print("Success!");
           });
          });
        });
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
    if(status == null)
    {
      status = "En Inventario";
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
              status == "Terminado" ? Colors.green.shade700:Colors.purple.shade700
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
                  Text(auxMap[i]['Nombre']+" - "+auxMap[i]['Piezas'].toString(), style: (
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
            status == "Terminado"?
            ConfirmationSlider(
                    text: "Agregar a Inventario",
                    textStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12
                    ),
                    foregroundColor: colorPrincipal,
                    onConfirmation: (){
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
                  ): 
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

}
   