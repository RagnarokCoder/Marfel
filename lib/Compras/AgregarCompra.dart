import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';
import 'package:yudiz_modal_sheet/yudiz_modal_sheet.dart';
import 'package:intl/intl.dart';

class AgregarCompra extends StatefulWidget {
  @override
  _AgregarCompraState createState() => _AgregarCompraState();
}

final _productoController = TextEditingController();
final _cantidadController = TextEditingController();
final _costoController = TextEditingController();
final _fechaController = TextEditingController();
final _proveedorController = TextEditingController();
NumberFormat f = new NumberFormat("#,##0.00", "es_US");
String productoSelect = "";
dynamic totalCompra = 0;
String imagen="";
String dia,mes,year;
int _checkboxValue1;
String unidadMedida="";

class _AgregarCompraState extends State<AgregarCompra> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset : false,
        appBar: AppBar(
          backgroundColor: colorPrincipal,
          elevation: 5,
          title: Text("Nueva Compra"),
          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsets.only(top: 10, left: 20, right: 20),
          child: ListView(
            
            children: [

              Container(
                height: MediaQuery.of(context).size.height*0.6,
     
                child: ListView(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                          
            stream: FirebaseFirestore.instance.collection('ProductosCompras').snapshots(),
            builder: (context, snapshot) {
             if(!snapshot.hasData){
                return Container(
                  height: 50,
                  width: 50,
                  child: SizedBox(height: 50, width: 50,
                  child: Center(
                    child: Image.asset("assets/marfelLoad.gif")
                  ),
                ),
                );
              }
              int length = snapshot.data.docs.length;
              return Container(
                height: MediaQuery.of(context).size.height*0.6,
                child: GridView.builder(
                
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, //columnas
                  mainAxisSpacing: 1, //espacio entre cards
                  childAspectRatio: .99,// largo de la card.
                  crossAxisSpacing: 5

                ),
                itemCount: length,
               
                itemBuilder: (_, int index){
                  
                  final DocumentSnapshot doc = snapshot.data.docs[index];
                  return InkWell(
                    child: Container(
                    height: MediaQuery.of(context).size.height*0.05,
                    width: MediaQuery.of(context).size.width*0.05,
                  
                    decoration: BoxDecoration(
                      boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.all(
                   Radius.circular(15))),
                    child: Image.network("${doc.data()['Imagen']}"),
                  ),
                  onTap: (){
                    setState(() {
                      productoSelect = doc.data()['Nombre'];
                      imagen = doc.data()['Imagen'];
                      print(productoSelect);
                    });
                  },
                  );

                    
                 
                  

                },
              ),
              );
            },
            
          ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height*0.08,
                child: Center(
                  child: Text("Producto: "+productoSelect,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                  ),
                ),
              ),
              Container(
                          padding: EdgeInsets.only(
                              top: 0.0, left: 6.0, right: 6.0, bottom: 6.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.transparent),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          height: 80.0,
                          width: MediaQuery.of(context).size.width,
                          child: CustomDropdown(
                            valueIndex: _checkboxValue1,
                            enabledColor: Colors.white,
                            disabledIconColor: colorPrincipal,
                            enabledIconColor: colorPrincipal,
                            enableTextColor: colorPrincipal,
                            elementTextColor: colorPrincipal,
                            openColor: Colors.white,
                            hint: "Unidad De Medida: ",
                            items: [
                              CustomDropdownItem(text: "Kilogramos"),
                              CustomDropdownItem(text: "Piezas"),
                              CustomDropdownItem(text: "Caja"),
                              CustomDropdownItem(text: "Bulto"),
                              CustomDropdownItem(text: "Botes"),
                            ],
                            onChanged: (newValue) {
                              setState(() => _checkboxValue1 = newValue);
                              print(_checkboxValue1);
                              if(_checkboxValue1==0)
                              {
                                unidadMedida = "Kg";
                              }
                              if(_checkboxValue1==1)
                              {
                                unidadMedida = "Pz";
                              }
                              if(_checkboxValue1==2)
                              {
                                unidadMedida = "Caja";
                              }
                              if(_checkboxValue1==3)
                              {
                                unidadMedida = "Bulto";
                              }
                              if(_checkboxValue1==4)
                              {
                                unidadMedida = "Bote";
                              }
                            },
                          )),
              Container(
                height: MediaQuery.of(context).size.height*0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                  _buildTextField("Cantidad", _cantidadController,TextInputType.number),
                  _buildTextField("Costo", _costoController,TextInputType.number),
                  _buildTextField("Nombre del proveedor", _proveedorController,TextInputType.text),
                  ],
                ),
              ),
              
              // ignore: deprecated_member_use
              RaisedButton.icon(
                color: colorPrincipal,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.transparent)),
                onPressed: () {
                  if (
                      _cantidadController.text == "" ||
                      _costoController.text == "" ||
                      productoSelect == ""
                      ) {
                    buildAlert(context);
                  } else {

                       FirebaseFirestore.instance.collection("Compras").add({
                       "Cantidad": double.parse(_cantidadController.text),
                       "Costo": double.parse(_costoController.text),
                       "Proveedor": _proveedorController.text,
                       "Producto": productoSelect,
                       "UnidadMedida": unidadMedida,
                       "Mes": DateTime.now().month,
                       "Dia": DateTime.now().day,
                       "Año": DateTime.now().year,
                       "Pendiente": true
                       
                     }).then((value) => {
                        buildAlertCorrecto(context),
                        _productoController.text="",
                         _cantidadController.text="",
                          _costoController.text="",
                           _proveedorController.text="",
                           _fechaController.text=""
                     });
                     
                      


                  }
                },
                label: Text(
                  "Agregar",
                  style: TextStyle(color: Colors.white),
                ),
                icon: Icon(
                  Icons.add,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ));
  }

  _buildTextField(String labelText, TextEditingController controllerPr, TextInputType keyboardType) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white, border: Border.all(color: colorPrincipal)),
      child: TextField(
        controller: controllerPr,
        keyboardType: keyboardType,
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
        ),
      ),
    );
  }

  buildAlert(BuildContext context) {
    YudizModalSheet.show(
        context: context,
        child: Container(
          decoration: BoxDecoration(
              color: colorPrincipal,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              border: Border.all(
                color: colorPrincipal,
              )),
          height: MediaQuery.of(context).size.height * 0.2,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Error!",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.error,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
                Text(
                  "No Deje Campos Vacios!",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                )
              ],
            ),
          ),
        ),
        direction: YudizModalSheetDirection.BOTTOM);
  }

  buildAlertCorrecto(BuildContext context) {
    YudizModalSheet.show(
        context: context,
        child: Container(
          decoration: BoxDecoration(
              color: colorPrincipal,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              border: Border.all(
                color: colorPrincipal,
              )),
          height: MediaQuery.of(context).size.height * 0.2,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Compra Generada!",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
                Text(
                  "La Compra ha sido generada Correctamente!",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                )
              ],
            ),
          ),
        ),
        direction: YudizModalSheetDirection.BOTTOM);
  }
}
