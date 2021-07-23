

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:paleteria_marfel/HexaColors/HexColor.dart';



class Amonestar extends StatefulWidget {
  final String usuario;
  Amonestar({Key key, this.usuario}) : super(key: key);

  @override
  _AmonestarState createState() => _AmonestarState();
}

Color colorPrincipal = HexColor("#80DEEA");
int  _checkboxValue1;
String user="...";
var selectedCurrency1;
final _motivoController = TextEditingController();

class _AmonestarState extends State<Amonestar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         backgroundColor: colorPrincipal,
         elevation: 5,
         title: Text("Amonestar"),
         centerTitle: true,
         
       ),
       body: ListView(
         children: [
           Container(
             margin: EdgeInsets.only(left: 20, top: 30, bottom: 5),
             child: Text("Empleado",
           style: TextStyle(
             color: Colors.black,
             fontWeight: FontWeight.bold,
             fontSize: 18
           ),
           ),
           ),
            Container(
                   margin: EdgeInsets.all(20),
             color: colorPrincipal,
             height: MediaQuery.of(context).size.height*0.08,
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: [
                 SizedBox(width: 10,),
                 Text("Selecciona: ", 
                 style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                 ),
                 Expanded(
                   child: StreamBuilder<QuerySnapshot>(
                       
                  stream: FirebaseFirestore.instance.collection('Empleados')
                  .snapshots(),
                  
                  builder: (context, snapshot) {
                    
                    if (!snapshot.hasData)

                      const Text("Loading.....");
                    else {
                      List<DropdownMenuItem> currencyItems = [];
                      for (int i = 0; i < snapshot.data.docs.length; i++) {
                        DocumentSnapshot snap = snapshot.data.docs[i];
                        currencyItems.add(
                          DropdownMenuItem(
                            
                            child: Text(
                              
                              snap.reference.id,
                              style: TextStyle(color: Colors.white),
                              
                            ),
                            value: "${snap.id}",
                          ),
                        );
                      }return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          
                          
                          DropdownButton(
                            
                            items: currencyItems,
                            onChanged: (currencyValue) {
                              final snackBar = SnackBar(
                                backgroundColor: colorPrincipal,
                                content: Text(
                                  'Producto: $currencyValue',
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                              // ignore: deprecated_member_use
                              Scaffold.of(context).showSnackBar(snackBar);
                              setState(() {
                                selectedCurrency1 = currencyValue;
                                print
                                (selectedCurrency1);
                                
                               
                              });
                            },
                            value: selectedCurrency1,
                            isExpanded: false,
                            hint: new Text(
                              "Nombre: ",
                              style: TextStyle(color: Colors.white),
                            ),
                            dropdownColor: colorPrincipal,
                            icon: Icon(Icons.arrow_drop_down, color: Colors.white, size: 22.0,),
                          ),
                        ],
                      );
                    }
                    return LinearProgressIndicator();
                  }),
                 )
               ],
             )
           ),
           Container(
             margin: EdgeInsets.only(left: 20, bottom: 5),
             child: Text("Motivo",
           style: TextStyle(
             color: Colors.black,
             fontWeight: FontWeight.bold,
             fontSize: 18
           ),
           ),
           ),
           Container(
             color: Colors.grey.shade600.withOpacity(0.4),
             margin: EdgeInsets.only(left: 20, right: 20, bottom: 30),
             child: TextFormField(   
             controller: _motivoController,
             minLines: 6, 
             keyboardType: TextInputType.multiline,
             maxLines: null,
             )
           ),
           Container(
             margin: EdgeInsets.only(left: 20, bottom: 5),
             child: Text("Tipo de amonestación",
           style: TextStyle(
             color: Colors.black,
             fontWeight: FontWeight.bold,
             fontSize: 18
           ),
           ),
           ),
           Container(
             margin: EdgeInsets.only(left: 20, right: 20, bottom: 30),
             height: MediaQuery.of(context).size.height*0.08,
             color: colorPrincipal,
             child: CustomDropdown(
        valueIndex: _checkboxValue1,
        enabledColor: colorPrincipal,
        disabledIconColor: Colors.white,
        enabledIconColor: Colors.white,
        enableTextColor: Colors.white,
        elementTextColor: Colors.white,
        openColor: colorPrincipal,
        
        hint: "Seleccione un Tipo... ",
        items: [
          CustomDropdownItem(text: "Amonestación Laboral"),
          CustomDropdownItem(text: "Amonestación Social"),
        ],
        onChanged: (newValue) {
          setState(() => _checkboxValue1 = newValue);
          print(_checkboxValue1);
        },
      )
           ),
           Container(
             margin: EdgeInsets.all(20),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Text("Amonestación Hecha Por: ${widget.usuario}",
           style: TextStyle(
             color: Colors.grey.shade700,
             fontWeight: FontWeight.bold,
             fontSize: 16
           ),
           ),
               ],
             )
           ),
           Container(
             margin: EdgeInsets.all(20),
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
                     
                     
                
                     FirebaseFirestore.instance.collection("Personal").add({"Nombre": "$selectedCurrency1", "Motivo": _motivoController.text, "TipoAmonestacion": _checkboxValue1, "HechaPor": widget.usuario}).
                     then((value) => {
                       _motivoController.text = "",
                       _checkboxValue1 = 0
                     });
                     setState(() {
                       
                     });
                   },
                   label: Text("Amonestar", 
                   style: TextStyle(color: Colors.white),
                   ),
                   icon: Icon(Icons.warning_rounded, size: 18, color: Colors.white,),
                   
                 ),
               ],
             )
           )
         ],
       ),
    );
  }
}