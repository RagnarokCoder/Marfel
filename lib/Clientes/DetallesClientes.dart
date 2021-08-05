
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paleteria_marfel/Clientes/VistaClientes.dart';
import 'package:paleteria_marfel/HexaColors/HexColor.dart';
import 'package:yudiz_modal_sheet/yudiz_modal_sheet.dart';


class DetallesClientes extends StatefulWidget {
  final String nombre;
  final String correo, telefono, direccion, id;
  final dynamic descuento;
  final String usuario;
  
  DetallesClientes({Key key, this.nombre, this.correo, this.telefono, this.direccion, this.descuento,  this.id, this.usuario}) : super(key: key);
  
  @override
  _DetallesClientesState createState() => _DetallesClientesState();
}


NumberFormat f = new NumberFormat("#,##0.00", "es_US");
final _nombreController = TextEditingController();
final _direccionController = TextEditingController();
final _telefonoController = TextEditingController();
final _correoController = TextEditingController();
final _abonarController = TextEditingController();
dynamic deudaActual, interesActual, meses;
String diferido;
dynamic totalabono = 0;
dynamic restante=0;
bool open=false, open1=false;
Color colorPrincipal = HexColor("#3C9CA8");

class _DetallesClientesState extends State<DetallesClientes> {
  

   @override
   void initState() { 
     super.initState();
     setState(() {
      DocumentReference documentReference =
                FirebaseFirestore.instance.collection("Clientes").doc(widget.id);
            documentReference.get().then((datasnapshot) {
              if (datasnapshot.exists) {
                
                
                setState(() {
                  totalabono = datasnapshot.data()['Deuda'];
                  interesActual = datasnapshot.data()['Interes'];
                  meses = datasnapshot.data()['CantidadInteres'];
                  diferido = datasnapshot.data()['Diferido'];
                  if(totalabono == null || interesActual == null || meses == null || diferido == null)
                  {
                    totalabono=0;
                    interesActual=0;
                    meses=0;
                    diferido="";
                  }
                });
               
              }
              else{
                print("No Existe");
              }
            });
    });
   }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    

    
    return Scaffold(
       appBar: AppBar(
         backgroundColor: colorPrincipal,
         automaticallyImplyLeading: false,
         elevation: 5,
         title: Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             IconButton(
               icon: Icon(Icons.arrow_back, color: Colors.white,), 
             onPressed: (){
               Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: VistaClientes(
                                                        usuario: widget.usuario,
                                                      )));
             }
             ),
             Text("Detalles: "+"${widget.nombre}"),
             SizedBox(),
           ],
         ),
         centerTitle: true,
       ),
       body: ListView(
         children: [
           Container(
             height: size.height*0.65,
             
             margin: EdgeInsets.only(left: 20, right: 20, top: 20),
             child: Column(
               children: [
                 Container(
                  margin: EdgeInsets.all(15),
                  child: _buildTextField(
                      Icons.person, "${widget.nombre}", _nombreController),
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  child:
                      _buildTextField(Icons.email, "${widget.correo}", _correoController),
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  child: _buildTextField(
                      Icons.phone, "${widget.telefono}", _telefonoController),
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  child: _buildTextField(
                      Icons.house, "${widget.direccion}", _direccionController),
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  child: Text("Descuento Actual: "+"${widget.descuento}%",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                  )
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
             ),
           ),
           Container(
             height: MediaQuery.of(context).size.height*0.08,
             margin: EdgeInsets.all(10),
             
             child: Column(
               children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                   Text("\$"+"${f.format(totalabono)}", 
                 style: TextStyle(
                   color: colorPrincipal,
                   fontSize: 15
                 ),
                 ),
                 Text(" Interes del"+" $interesActual"+"%", 
                 style: TextStyle(
                   color: Colors.black,
                   fontSize: 15
                 ),
                 ),
                   ],
                 ),
                 Text("Diferido a"+" $meses"+" $diferido", 
                 style: TextStyle(
                   color: Colors.black,
                   fontSize: 15
                 ),
                 ),
               ],
             )
           ),
           
           Container(
             height: MediaQuery.of(context).size.height*0.05,
             margin: EdgeInsets.all(10),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: [
                 
                 // ignore: deprecated_member_use
                 RaisedButton.icon(
                   color: colorPrincipal,
                   shape: RoundedRectangleBorder(
                            
  borderRadius: BorderRadius.circular(10.0),
  side: BorderSide(color: Colors.transparent)
),
                   onPressed: (){
                     _abonarCapital();
                   },
                   label: Text("Abonar", 
                   style: TextStyle(color: Colors.white),
                   ),
                   icon: Icon(Icons.swap_horizontal_circle_rounded, size: 18, color: Colors.white,),
                   
                 ),
                 // ignore: deprecated_member_use
                 RaisedButton.icon(
                   color: colorPrincipal,
                   shape: RoundedRectangleBorder(
                            
  borderRadius: BorderRadius.circular(10.0),
  side: BorderSide(color: Colors.transparent)
),
                   onPressed: (){
                     _liquidarCuenta();
                   },
                   label: Text("Liquidar", 
                   style: TextStyle(color: Colors.white),
                   ),
                   icon: Icon(Icons.update, size: 18, color: Colors.white,),
                   
                 ),
               ],
             )
           ),
           Container(
             height: MediaQuery.of(context).size.height*0.05,
             margin: EdgeInsets.all(10),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 // ignore: deprecated_member_use
                 RaisedButton.icon(
                   color: colorPrincipal,
                   shape: RoundedRectangleBorder(
                            
  borderRadius: BorderRadius.circular(10.0),
  side: BorderSide(color: Colors.transparent)
),
                   onPressed: (){
                     if(_nombreController.text==""&&_correoController.text==""&& _telefonoController.text==""&& _direccionController.text==""&&descuento==0)
                     {
                       setState(() {
                         open = true;
                       });
                       if(open==true)
                       {
                         buildAlert(context);
                         Future.delayed(const Duration(seconds: 2), () {
                        setState(() {
                          open=false;
                          Navigator.of(context).pop();
                          print(open);
                        });
                        });
                       }
                     }
                     else
                     {
                       FirebaseFirestore.instance.collection("Clientes").doc(widget.id).update({
                         "Nombre": _nombreController.text==""? "${widget.nombre}":"${_nombreController.text}",
                         "Correo": _correoController.text==""? "${widget.correo}":"${_correoController.text}",
                         "Telefono": _telefonoController.text==""? "${widget.telefono}":"${_telefonoController.text}",
                         "Direccion": _direccionController.text==""? "${widget.direccion}":"${_direccionController.text}",
                         "Descuento": descuento==0? widget.descuento:descuento,
                       }).then((value) => {
                         setState(() {
                         open1 = true;
                         _nombreController.text="";
                         _correoController.text="";
                         _telefonoController.text="";
                         _direccionController.text="";
                         descuento=0;
                       }),
                       if(open1==true)
                       {
                         buildAlertCorrecto(context),
                         Future.delayed(const Duration(seconds: 2), () {
                        setState(() {
                          open1=false;
                          Navigator.of(context).pop();
                        });
                        })
                       }
                         
                       });
                       
                     }
                   },
                   label: Text("Actualizar", 
                   style: TextStyle(color: Colors.white),
                   ),
                   icon: Icon(Icons.update, size: 18, color: Colors.white,),
                   
                 ),
               ],
             )
           )
         ],
       ),
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

Future<void> _abonarCapital() async {
  
  return showDialog<void>(
    builder: (context) => StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
          title: Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Abonar A Capital', 
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
          ),
              ],
            ),
          ),
          
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                
                Text('Saldo Actual: \$${f.format(totalabono)}'),
                SizedBox(height: 8,),
                _buildTextFieldCantidad(
                        Icons.attach_money, "Abono", _abonarController),
                        
              ],
            ),
          ),
          actions: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // ignore: deprecated_member_use
                FlatButton.icon(
              color: colorPrincipal,
              label: Text('Acceptar', style: TextStyle(color: Colors.white)),
              icon: Icon(Icons.check, size: 18, color: Colors.white,),
              onPressed: () {
                
                restante = totalabono-double.parse(_abonarController.text);
                
               FirebaseFirestore.instance.collection("Clientes").doc("${widget.id}").update({"Deuda": restante});
               setState((){
                 _abonarController.text="";
                restante=0;
               });
                Navigator.of(context).pop();
              },
            ),
            
            // ignore: deprecated_member_use
            FlatButton.icon(
              color: colorPrincipal,
              label: Text('Cancelar', style: TextStyle(color: Colors.white)),
              icon: Icon(Icons.cancel, size: 18, color: Colors.white,),
              onPressed: () {
                
                Navigator.of(context).pop();
              },
            ),
              ],
            )
            )
          ],
        );
      },
      ), context: context,
    barrierDismissible: false,
  );
}

Future<void> _liquidarCuenta() async {
  
  return showDialog<void>(
    builder: (context) => StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
          title: Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Liquidar Cuenta', 
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
          ),
              ],
            ),
          ),
          
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                
                Container(
                  child: Text('La cuenta quedará liquidada por completo\n¿Esta de Acuerdo?',
                style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            
          ),
                ),
                )
                
                        
              ],
            ),
          ),
          actions: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // ignore: deprecated_member_use
                FlatButton.icon(
              color: colorPrincipal,
              label: Text('Acceptar', style: TextStyle(color: Colors.white)),
              icon: Icon(Icons.check, size: 18, color: Colors.white,),
              onPressed: () {
                
               FirebaseFirestore.instance.collection("Clientes").doc("${widget.id}").update({"Deuda": 0});
               setState((){
                 _abonarController.text="";
               });
                Navigator.of(context).pop();
              },
            ),
            
            // ignore: deprecated_member_use
            FlatButton.icon(
              color: colorPrincipal,
              label: Text('Cancelar', style: TextStyle(color: Colors.white)),
              icon: Icon(Icons.cancel, size: 18, color: Colors.white,),
              onPressed: () {
                
                Navigator.of(context).pop();
              },
            ),
              ],
            )
            )
          ],
        );
      },
      ), context: context,
    barrierDismissible: false,
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
            Text("No hay nada que actualizar",
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
                  Text("Actualización Correcta!",
            style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(width: 10,),
            Icon(Icons.check, color: Colors.white, size: 20,),
                ],
              ),
            ),
            Text("Los Datos han sido subidos correctamente",
            style: TextStyle(color: Colors.white, fontSize: 15),
            )
          ],
        ),
      ),
    ),
    direction: YudizModalSheetDirection.BOTTOM);
  }


_buildTextFieldCantidad( IconData icon, String labelText, TextEditingController controllerPr)
  {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: colorPrincipal)
      ),
      child: TextField(
        keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
        inputFormatters: [
                                    FilteringTextInputFormatter.deny(
                                        new RegExp('[\\-|\\ ]'))
                                  ],

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