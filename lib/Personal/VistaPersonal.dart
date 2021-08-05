import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';
import 'package:paleteria_marfel/HexaColors/HexColor.dart';
import 'package:paleteria_marfel/Personal/Amonestar.dart';
import 'package:paleteria_marfel/Personal/DetallesPersonal.dart';
import 'package:paleteria_marfel/Personal/NuevoEmpleado.dart';
import 'package:yudiz_modal_sheet/yudiz_modal_sheet.dart';


class VistaPersonal extends StatefulWidget {
  final String usuario;
  VistaPersonal({Key key, this.usuario}) : super(key: key);

  @override
  _VistaPersonalState createState() => _VistaPersonalState();
}
int laboral = 0;
Color colorPrincipal = HexColor("#3C9CA8");
final _nombreController = TextEditingController();
final _apellidoController = TextEditingController();
final _emailController = TextEditingController();
final _telfonoController = TextEditingController();

class _VistaPersonalState extends State<VistaPersonal> { 

  

    List personal = [];
    List filteredPersonal = [];


  getPersonal() async {
    var url = 'https://api-paleteria-marfel.herokuapp.com/api/v1/worker';
    final response = await http.get(url, headers: {
      'content-type': 'application/json',
      'Accept': 'application/json',
    });
    var r = json.decode(response.body);
    print(r);

    //return json.decode(response.body)['data']['productos'];
  }


    @override
  void initState() {

    



    getPersonal().then((body) {
      personal = filteredPersonal = body;
    });

      Future.delayed(const Duration(seconds: 4), () {

  setState(() {
  });

});
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         backgroundColor: colorPrincipal,
         elevation: 5,
         title: Text("Personal"),
         centerTitle: true,
         
       ),
       drawer: CustomAppBar(usuario: widget.usuario,),
       body: ListView(
         children: [
           Container(
             margin: EdgeInsets.all(15),
             color: Colors.transparent,
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
                     Navigator.push(context, PageTransition(type: PageTransitionType.topToBottom, child: Amonestar(
                       usuario: widget.usuario,
                     )));
                   },
                   label: Text("Amonestar", 
                   style: TextStyle(color: Colors.white),
                   ),
                   icon: Icon(Icons.warning, size: 18, color: Colors.white,),
                   
                 ),

                
                 
               ],
             ),
           ),
           Divider(
            height: 12,
            indent: MediaQuery.of(context).size.width*0.05,
            endIndent: MediaQuery.of(context).size.width*0.05,
            color: colorPrincipal,
          ),
           Container(
             color: Colors.white,
             height: MediaQuery.of(context).size.height*0.8,
             child: ListView(
               children: [
                 StreamBuilder<QuerySnapshot>(
                          
            stream: FirebaseFirestore.instance.collection('Empleados')
            .snapshots(),
            builder: (context, snapshot) {
              return Column(children: snapshot.data.docs.map<Widget>((doc) => _buildListItem(doc)).toList());
            },
            
          ),
               ],
             ),
           )
         ],
       ),
       floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: NuevoEmpleado()));
        },
        label: Text('Empleado', style: TextStyle(color: Colors.white),),
        icon: Icon(Icons.add, color: Colors.white),
        backgroundColor: colorPrincipal,
      ),
    );
  }

  //Card Builder
   _buildListItem(DocumentSnapshot doc) {
     
     String empleado = "${doc.data()['Nombre']} ${doc.data()['Apellido']}";
     
    return Padding(
      padding: EdgeInsets.all(7.0),
      child: Container(
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
        height: MediaQuery.of(context).size.height*0.08,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(top: 5),
              color: Colors.white,
              height: MediaQuery.of(context).size.height*0.07,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                   children: [
                      IconButton(
                      onPressed: (){
                        buildAlert(context, doc);
                      },
                      icon: Icon(Icons.delete, color: Colors.red.shade600),
                    ),
                    IconButton(
                      onPressed: (){
                        editarEmpleado(context, doc);
                      },
                      icon: Icon(Icons.edit, color: colorPrincipal),
                    )
                   ],
                  ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 5,),
                          Text(doc.data()['Nombre'],
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                          ),
                          SizedBox(height: 2,),
                          Text(doc.data()['Apellido'],
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14,
                            
                          ),
                          ),
                          
                        ],
                      ),
                      // ignore: deprecated_member_use
                      RaisedButton.icon(
                   color: Colors.white,
                   elevation: 0,
                   shape: RoundedRectangleBorder(
                            
  borderRadius: BorderRadius.circular(10.0),
  side: BorderSide(color: Colors.transparent)
),
                   onPressed: (){
                     Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: DetallesPersonal(empleado: empleado,)));
                   },
                   label: Text("Ver mas", 
                   style: TextStyle(color: colorPrincipal),
                   ),
                   icon: Icon(Icons.more_horiz, size: 18, color: colorPrincipal,),
                   
                 ),
                      
                ],
              ),
            ),
            
          ],
        )
      )
      
    );
    
  }

   Icon amonestacionSocial() => Icon(Icons.arrow_drop_up_sharp, color: Colors.purple, size: 35,);

   Icon iconoAmonestacion() => Icon(Icons.circle, color: Colors.pink);

   
  buildAlert(BuildContext context, DocumentSnapshot doc)
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
                  Text("¿Desea Eliminar Este Empleado?",
            style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(width: 10,),
            Icon(Icons.error, color: Colors.white, size: 20,),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton.icon(
                   color: colorPrincipal,
                   shape: RoundedRectangleBorder(
                            
  borderRadius: BorderRadius.circular(10.0),
  side: BorderSide(color: Colors.transparent)
),
                   onPressed: (){
                     FirebaseFirestore.instance.collection("Empleados").doc(doc.id).delete().then((value) => {
                       Navigator.pop(context)
                     });
                   },
                   label: Text("Confirmar", 
                   style: TextStyle(color: Colors.white),
                   ),
                   icon: Icon(Icons.check, size: 18, color: Colors.white,),
                   
                 ),
                 RaisedButton.icon(
                   color: colorPrincipal,
                   shape: RoundedRectangleBorder(
                            
  borderRadius: BorderRadius.circular(10.0),
  side: BorderSide(color: Colors.transparent)
),
                   onPressed: (){
                     Navigator.pop(context);
                   },
                   label: Text("Cancelar", 
                   style: TextStyle(color: Colors.white),
                   ),
                   icon: Icon(Icons.cancel, size: 18, color: Colors.white,),
                   
                 ),
              ],
            )
          ],
        ),
      ),
    ),
    direction: YudizModalSheetDirection.BOTTOM);
  }

  editarEmpleado(BuildContext context, DocumentSnapshot doc)
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
      height: MediaQuery.of(context).size.height*0.7,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Detalles De Empleado\nPuesto: ${doc.data()['Puesto']}",
            style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(width: 10,),
            Icon(Icons.error, color: Colors.white, size: 20,),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              height: MediaQuery.of(context).size.height*0.5,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
            _buildTextField(Icons.person_add_alt_1_sharp, "${doc.data()['Nombre']}", _nombreController),
           _buildTextField(Icons.person_add_alt_1_sharp, "${doc.data()['Apellido']}", _apellidoController),
           _buildTextField(Icons.phone, "${doc.data()['Telefono']}", _telfonoController),
           _buildTextField(Icons.email, "${doc.data()['Correo']}", _emailController),
           
                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton.icon(
                   color: colorPrincipal,
                   shape: RoundedRectangleBorder(
                            
  borderRadius: BorderRadius.circular(10.0),
  side: BorderSide(color: Colors.transparent)
),
                   onPressed: (){
                     FirebaseFirestore.instance.collection("Empleados").doc(doc.id).update({
                      "Nombre": _nombreController.text != "" ?_nombreController.text: doc.data()['Nombre'],
                      "Apellido": _apellidoController.text != "" ?_apellidoController.text: doc.data()['Apellido'],
                      "Telefono": _telfonoController.text != "" ?_telfonoController.text: doc.data()['Telefono'],
                      "Correo": _emailController.text != "" ?_emailController.text: doc.data()['Correo']
                     }).then((value) => {
                       buildAlertCorrecto(context),
                        _nombreController.text="",
                        _apellidoController.text="",
                        _emailController.text="",
                        _telfonoController.text=""
                     });
                   },
                   label: Text("Actualizar", 
                   style: TextStyle(color: Colors.white),
                   ),
                   icon: Icon(Icons.update, size: 18, color: Colors.white,),
                   
                 ),
                 RaisedButton.icon(
                   color: colorPrincipal,
                   shape: RoundedRectangleBorder(
                            
  borderRadius: BorderRadius.circular(10.0),
  side: BorderSide(color: Colors.transparent)
),
                   onPressed: (){
                     Navigator.pop(context);
                   },
                   label: Text("Cancelar", 
                   style: TextStyle(color: Colors.white),
                   ),
                   icon: Icon(Icons.cancel, size: 18, color: Colors.white,),
                   
                 ),
              ],
            )
          ],
        ),
      ),
    ),
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
                  Text("Información Actualizada!",
            style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(width: 10,),
            Icon(Icons.check_circle, color: Colors.white, size: 20,),
                ],
              ),
            ),
            Text("La Informacion del empleado ha\n sido actualizada correctamente!",
            style: TextStyle(color: Colors.white, fontSize: 15),
            )
          ],
        ),
      ),
    ),
    direction: YudizModalSheetDirection.BOTTOM);
  }

}