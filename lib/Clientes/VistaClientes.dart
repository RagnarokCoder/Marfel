import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paleteria_marfel/Clientes/DetallesClientes.dart';
import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';
import 'package:paleteria_marfel/HexaColors/HexColor.dart';
import 'package:yudiz_modal_sheet/yudiz_modal_sheet.dart';

class VistaClientes extends StatefulWidget {
  final String usuario;
  VistaClientes({Key key, this.usuario}) : super(key: key);

  @override
  _VistaClientesState createState() => _VistaClientesState();
}


final _nombreController = TextEditingController();
final _direccionController = TextEditingController();
final _telefonoController = TextEditingController();
final _correoController = TextEditingController();
final _buscadorController = TextEditingController();

int descuento = 0;
Color colorPrincipal = HexColor("#3C9CA8");

class _VistaClientesState extends State<VistaClientes> {

List clientes = [];
List filteredClientes = [];

  getClientes() async {
    var url = 'https://api-paleteria-marfel.herokuapp.com/api/v1/client';
    final response = await http.get(url, headers: {
      'content-type': 'application/json',
      'Accept': 'application/json',
    });
    var r = json.decode(response.body);
    print(r);

    return json.decode(response.body)['data']['clientes'];
  }

  @override
  void initState() {
    getClientes().then((body) {
      clientes = filteredClientes = body;
      setState(() {
  });
    }); 

      
    super.initState();
  }

    void _filterClientes(value) {
    setState(() {
      filteredClientes = clientes
          .where((country) =>
              country['Nombre'].toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
       appBar: AppBar(
         backgroundColor: colorPrincipal,
         elevation: 5,
         title: Text("Clientes"),
         centerTitle: true,
         
       ),
       drawer: CustomAppBar(usuario: widget.usuario,),
       body: ListView(
         children: [
           Container(
             margin: EdgeInsets.all(15),
             color: Colors.white,
             height: MediaQuery.of(context).size.height*0.07,
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 
                 // ignore: deprecated_member_use
                 RaisedButton.icon(
                   color: colorPrincipal,
                   shape: RoundedRectangleBorder(
                            
  borderRadius: BorderRadius.circular(10.0),
  side: BorderSide(color: Colors.transparent)
),
                   onPressed: (){
                     buildAlert(context);
                   },
                   label: Text("Nuevo", 
                   style: TextStyle(color: Colors.white),
                   ),
                   icon: Icon(Icons.add, size: 18, color: Colors.white,),
                   
                 ),

                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: TextField(
                    onChanged: (value) {
                     _filterClientes(value);
                    },
                    controller: _buscadorController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      labelText: "Buscar",
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      labelStyle: TextStyle(color: colorPrincipal),
                      icon: Icon(Icons.search, color: colorPrincipal),
                    ),
                  ),
                )
              ],
            ),
          ),
          Divider(
            height: 12,
            indent: MediaQuery.of(context).size.width * 0.05,
            endIndent: MediaQuery.of(context).size.width * 0.05,
            color: colorPrincipal,
          ),
          Container(
            height: size.height * 0.8,
            color: Colors.white,
            child: ListView(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * 0.9,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(5),
                    child: filteredClientes.length > 0
                        ? ListView.builder(
                            itemCount: filteredClientes.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                  padding: EdgeInsets.all(7.0),
                                  child: ExpansionTileCard(
                                    baseColor: Colors.white,
                                    shadowColor: Colors.white,
                                    
                                    elevation: 15,
                                    leading: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.person,
                                          color: Colors.black,
                                          size: 30,
                                        ),
                                      ],
                                    ),
                                    title: Text(
                                      filteredClientes[index]['Nombre'],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      filteredClientes[index]['Correo'],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                    children: [
                                      Divider(
                                        thickness: 1.0,
                                        height: 1.0,
                                      ),
                                      Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Padding(
                                              padding: EdgeInsets.all(15),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                     crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Telefono: ",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(
                                                            filteredClientes[
                                                                    index]
                                                                ['Telefono'],
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Dirección: ",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(
                                                            filteredClientes[
                                                                    index]
                                                                ['Direccion'],
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Descuento: ",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(
                                                            filteredClientes[
                                                                    index]
                                                                ['Descuento'].toString()+"%",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  // ignore: deprecated_member_use
                                                  RaisedButton.icon(
                                                    color: colorPrincipal,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        side: BorderSide(
                                                            color: Colors
                                                                .transparent)),
                                                    onPressed: () {
                                                      Navigator.push(context, PageTransition(type: PageTransitionType.topToBottom, child: DetallesClientes(
                                                        nombre: filteredClientes[index]['Nombre'],
                                                        correo: filteredClientes[index]['Correo'],
                                                        telefono: filteredClientes[index]['Telefono'],
                                                        direccion: filteredClientes[index]['Direccion'],
                                                        descuento: filteredClientes[index]['Descuento'],
                                                        id: filteredClientes[index]['id'],
                                                        usuario: widget.usuario,
                                                      )));
                                                    },
                                                    label: Text(
                                                      "Editar",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    icon: Icon(
                                                      Icons.edit,
                                                      size: 18,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ))),
                                    ],
                                  ));
                            })
                        : Center(
                      child: SpinKitFadingCube(
                    color: colorPrincipal,
                    size: 50.0,
                      ),
                    )
                  ),
               
              ],
            ),
          )
        ],
      ),
    );
  }



  buildAlert(BuildContext context) {
    YudizModalSheet.show(
        context: context,
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50))),
            height: MediaQuery.of(context).size.height - 200,
            child: Center(
                child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.all(15),
                      child: Text(
                        "Nuevo Cliente",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      // ignore: deprecated_member_use
                      child: RaisedButton.icon(
                          color: Colors.transparent,
                          elevation: 0,
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection("Clientes")
                                .add({
                              "Nombre": _nombreController.text,
                              "Correo": _correoController.text,
                              "Telefono": _telefonoController.text,
                              "Direccion": _direccionController.text,
                              "Descuento": descuento
                            }).then((value) {
                              _nombreController.text = "";
                              _correoController.text = "";
                              _telefonoController.text = "";
                              _direccionController.text = "";
                              descuento = 0;
                            });

                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.add_circle_rounded,
                              color: colorPrincipal),
                          label: Text(
                            "Agregar",
                            style: TextStyle(color: Colors.black),
                          )),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  child: _buildTextField(
                      Icons.person_add, "Nombre", _nombreController),
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  child:
                      _buildTextField(Icons.email, "Correo", _correoController),
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  child: _buildTextField(
                      Icons.phone, "Teléfono", _telefonoController),
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  child: _buildTextField(
                      Icons.house, "Dirección", _direccionController),
                ),
                Container(
                    margin: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RawMaterialButton(
                          onPressed: () {
                            setState(() {
                              if (descuento <= 0) {
                                descuento = 0;
                              } else {
                                descuento -= 5;
                              }
                            });
                          },
                          elevation: 5.0,
                          fillColor: colorPrincipal,
                          child: Icon(
                            Icons.remove_outlined,
                            size: 20.0,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(15.0),
                          shape: CircleBorder(),
                        ),
                        Text(
                          "$descuento" + "%",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        RawMaterialButton(
                          onPressed: () {
                            setState(() {
                              if (descuento >= 100) {
                                descuento = 100;
                              } else {
                                descuento += 5;
                              }
                            });
                          },
                          elevation: 5.0,
                          fillColor: colorPrincipal,
                          child: Icon(
                            Icons.add,
                            size: 20.0,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(15.0),
                          shape: CircleBorder(),
                        )
                      ],
                    )),
              ],
            )),
          );
        }),
        direction: YudizModalSheetDirection.BOTTOM);
  }

  _buildTextField(
      IconData icon, String labelText, TextEditingController controllerPr) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white, border: Border.all(color: colorPrincipal)),
      child: TextField(
        controller: controllerPr,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          labelText: labelText,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          labelStyle: TextStyle(color: colorPrincipal),
          icon: Icon(icon, color: colorPrincipal),
        ),
      ),
    );
  }
}
