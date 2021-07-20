

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yudiz_modal_sheet/yudiz_modal_sheet.dart';
import '../HexaColors/HexColor.dart';



class NuevoEmpleado extends StatefulWidget {
  NuevoEmpleado({Key key}) : super(key: key);

  @override
  _NuevoEmpleadoState createState() => _NuevoEmpleadoState();
}

final _nombreController = TextEditingController();
final _apellidoController = TextEditingController();
final _puestoController = TextEditingController();
final _emailController = TextEditingController();
final _passwordController = TextEditingController();
final _telfonoController = TextEditingController();
Color colorPrincipal = HexColor("#80DEEA");
int puesto = 0;
String puestoSelect;

class _NuevoEmpleadoState extends State<NuevoEmpleado> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         backgroundColor: colorPrincipal,
         elevation: 5,
         title: Text("Nuevo Empleado"),
         centerTitle: true,
         
       ),
       body: Container(
         
         margin: EdgeInsets.only(top: 10, left:20, right: 20),
         child: ListView(
           
         children: [
           
           Container(
             height: MediaQuery.of(context).size.height*0.8,
             child: Column(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: [
               _buildTextField(Icons.person_add_alt_1_sharp, "Nombre", _nombreController),
           _buildTextField(Icons.person_add_alt_1_sharp, "Apellido", _apellidoController),
           Container(
             height: MediaQuery.of(context).size.height*0.12,
             width: MediaQuery.of(context).size.width,
             
             child: Column(
               mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 Text("Puesto",
                 style: TextStyle(
                   color: colorPrincipal,
                   fontSize: 15,
                   fontWeight: FontWeight.bold
                 ),
                 ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      child: Container(
                        
                        height: MediaQuery.of(context).size.height*0.085,
                        width: MediaQuery.of(context).size.height*0.06,
                        child: Column(
                          children: [
                            Image.asset("assets/work.png"),
                            puesto == 0? 
                            Text("Compras",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold
                            ),
                            ):SizedBox()
                          ],
                        )
                      ),
                      onTap: (){
                        setState(() {
                          puesto = 0;
                          puestoSelect = "Compras";
                        });
                      },
                    ),
                    InkWell(
                      child: Container(
                        
                        height: MediaQuery.of(context).size.height*0.085,
                        width: MediaQuery.of(context).size.height*0.06,
                        child: Column(
                          children: [
                            Image.asset("assets/work.png"),
                            puesto == 1? 
                            Text("Ventas",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold
                            ),
                            ):SizedBox()
                          ],
                        )
                      ),
                      onTap: (){
                        setState(() {
                          puesto = 1;
                          puestoSelect = "Ventas";
                        });
                      },
                    ),
                    InkWell(
                      child: Container(
                        
                        height: MediaQuery.of(context).size.height*0.088,
                        width: MediaQuery.of(context).size.height*0.06,
                        child: Column(
                          children: [
                            Image.asset("assets/work.png"),
                            puesto == 2? 
                            Text("Produc.",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.bold
                            ),
                            ):SizedBox()
                          ],
                        )
                      ),
                      onTap: (){
                        setState(() {
                          puestoSelect = "Produccion";
                          puesto = 2;
                        });
                      },
                    ),
                  ],
                )
               ],
             ),
           ),
           _buildTextField(Icons.phone, "Telefono", _telfonoController),
           _buildTextField(Icons.email, "Correo", _emailController),
           _buildTextField(Icons.lock, "Contraseña", _passwordController),
             ],
           ),
           ),
           
           // ignore: deprecated_member_use
           RaisedButton.icon(
                   color: colorPrincipal,
                   shape: RoundedRectangleBorder(
                            
  borderRadius: BorderRadius.circular(10.0),
  side: BorderSide(color: Colors.transparent)
),
                   onPressed: (){
                     if(_nombreController.text=="" || _apellidoController.text == "" ||  _emailController.text == "" || _passwordController.text=="" || _telfonoController.text=="")
                     {
                       buildAlert(context);
                     }
                     else{
                      
                       FirebaseFirestore.instance.collection("Empleados").doc(_nombreController.text+" "+_apellidoController.text).set({
                       "Nombre": _nombreController.text,
                       "Apellido": _apellidoController.text,
                       "Correo": _emailController.text,
                       "Contraseña": _passwordController.text,
                       "Telefono": _telfonoController.text,
                       "Puesto": puestoSelect
                     }).then((value) => {
                        buildAlertCorrecto(context),
                        _nombreController.text="",
                        _apellidoController.text="",
                        _puestoController.text="",
                        _emailController.text="",
                        _passwordController.text="",
                        _telfonoController.text="",
                        puesto = 0
                     });
                     }
                   },
                   label: Text("Agregar", 
                   style: TextStyle(color: Colors.white),
                   ),
                   icon: Icon(Icons.add, size: 18, color: Colors.white,),
                   
                 ),
         ],
       ),
       )
    );
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

  buildAlert(BuildContext context)
  {
    YudizModalSheet.show(
    context: context,
    child: Container(
      
      decoration: BoxDecoration(
        
              color: colorPrincipal,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              border: Border.all(
                color: colorPrincipal,
              )
            ),
      height: MediaQuery.of(context).size.height*0.2,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Error!",
            style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(width: 10,),
            Icon(Icons.error, color: Colors.white, size: 20,),
                ],
              ),
            ),
            Text("No Deje Campos Vacios!",
            style: TextStyle(color: Colors.white, fontSize: 15),
            )
          ],
        ),
      ),
    ),
    direction: YudizModalSheetDirection.BOTTOM);
  }

  buildAlertCorrecto(BuildContext context)
  {
    YudizModalSheet.show(
    context: context,
    child: Container(
      
      decoration: BoxDecoration(
        
              color: colorPrincipal,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              border: Border.all(
                color: colorPrincipal,
              )
            ),
      height: MediaQuery.of(context).size.height*0.2,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Empleado Agregado!",
            style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(width: 10,),
            Icon(Icons.check_circle, color: Colors.white, size: 20,),
                ],
              ),
            ),
            Text("El empleado ha sido agregado correctamente!",
            style: TextStyle(color: Colors.white, fontSize: 15),
            )
          ],
        ),
      ),
    ),
    direction: YudizModalSheetDirection.BOTTOM);
  }

}