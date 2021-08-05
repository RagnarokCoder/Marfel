

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:paleteria_marfel/FirebaseAuth/Authentication_Service.dart';
import 'package:yudiz_modal_sheet/yudiz_modal_sheet.dart';
import '../HexaColors/HexColor.dart';
import 'package:provider/provider.dart';


class NuevoEmpleado extends StatefulWidget {
  NuevoEmpleado({Key key}) : super(key: key);

  @override
  _NuevoEmpleadoState createState() => _NuevoEmpleadoState();
}

int drop;
String extensionEmail="";
String finalEmail="...";
final _nombreController = TextEditingController();
final _apellidoController = TextEditingController();
final _puestoController = TextEditingController();
final _emailController = TextEditingController();
final _passwordController = TextEditingController();
final _telfonoController = TextEditingController();
Color colorPrincipal = HexColor("#3C9CA8");
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
                height: MediaQuery.of(context).size.height*0.08,
                child: 
                  
                  CustomDropdown(
                  
        valueIndex: drop,
        enabledColor: colorPrincipal,
        disabledIconColor: Colors.white,
        enabledIconColor: Colors.white,
        enableTextColor: Colors.white,
        elementTextColor: Colors.white,
        openColor: colorPrincipal,
        
        hint: "Tipo de Usuario: ",
        items: [
          CustomDropdownItem(text: "Administrador"),
          CustomDropdownItem(text: "Inventario"),
          CustomDropdownItem(text: "Compras"),
          CustomDropdownItem(text: "Ventas"),
          CustomDropdownItem(text: "Producciòn"),
          
        ],
        onChanged: (newValue) {
          setState(() => drop = newValue);
          print(drop);
          switch(drop){
                            case 0:
                            extensionEmail="_admin@marfel.com";
                            break;
                            case 1:
                            extensionEmail="_inventario@marfel.com";
                            break;
                            case 2:
                            extensionEmail="_compras@marfel.com";
                            break;
                            case 3:
                            extensionEmail="_ventas@marfel.com";
                            break;
                            case 4:
                            extensionEmail="_produccion@marfel.com";
                            break;
                            
                          }
        },
      )
                
              
              ),
           _buildTextField(Icons.phone, "Telefono", _telfonoController),
           Text("$finalEmail",
              style: TextStyle(
                color: Colors.black
              ),
              ),
           Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white, border: Border.all(color: colorPrincipal)),
      child: TextField(
        controller: _emailController,
        onChanged: (valor) {
                  if(valor=="")
                  {
                    finalEmail="";
                  }
                  else
                  {
                    finalEmail = _emailController.text+extensionEmail.trim();
                  }
                  
                  setState(() {});
                },
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          labelText: "Correo",
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          labelStyle: TextStyle(color: colorPrincipal),
          icon: Icon(Icons.email, color: colorPrincipal),
        ),
      ),
    ),
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
                      switch(drop){
                            case 0:
                            extensionEmail="_admin@marfel.com";
                            puestoSelect = "Admin";
                            break;
                            case 1:
                            extensionEmail="_inventario@marfel.com";
                            puestoSelect = "Inventario";
                            break;
                            case 2:
                            extensionEmail="_compras@marfel.com";
                            puestoSelect = "Compras";
                            break;
                            case 3:
                            extensionEmail="_ventas@marfel.com";
                            puestoSelect = "Ventas";
                            break;
                            case 4:
                            extensionEmail="_produccion@marfel.com";
                            puestoSelect = "Produccion";
                            break;
                            
                          }
                          finalEmail = _emailController.text+extensionEmail.trim();
                          context.read<AuthenticationService>().signUp(
                            email: finalEmail,
                            password: _passwordController.text.trim(),
                          ).then((value) => {
                            _passwordController.text="",
                            _emailController.text="",
                            drop=0,
                            finalEmail="",
                            setState(() {}),
                            });
                       FirebaseFirestore.instance.collection("Empleados").doc(_nombreController.text+" "+_apellidoController.text).set({
                       "Nombre": _nombreController.text,
                       "Apellido": _apellidoController.text,
                       "Correo": finalEmail,
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