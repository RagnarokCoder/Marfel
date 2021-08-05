
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_dropdown/custom_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';
import 'package:paleteria_marfel/HexaColors/HexColor.dart';
import 'package:yudiz_modal_sheet/yudiz_modal_sheet.dart';

class VistaGastos extends StatefulWidget {

  final String usuario;
  VistaGastos({Key key, this.usuario}) : super(key: key);
  @override
  _VistaGastosState createState() => _VistaGastosState();
}

Color colorPrincipal = HexColor("#3C9CA8");
bool icono = false;
NumberFormat f = new NumberFormat("#,##0.00", "es_US");
final _nombreController = TextEditingController();
final _cantidadController = TextEditingController();
int diaSel, mesSel, yearSel;
dynamic total = 0;
int drop1;
String tipoGasto="";
String selectGasto="";

class _VistaGastosState extends State<VistaGastos> {

  


 

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
       backgroundColor: Colors.white,
      appBar: AppBar(
         backgroundColor: colorPrincipal,
         elevation: 5,
         title: Text("Gastos"),
         centerTitle: true,
         
       ),
        drawer: CustomAppBar(usuario: widget.usuario,),
       body: ListView(
         children: [
           Container(
             margin: EdgeInsets.all(15),
             height: size.height*0.08,
             color: Colors.white,
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
                 IconButton(
                   icon: Icon(Icons.date_range),
                   onPressed: (){
                     showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            helpText: "Seleccione una fecha",
                            cancelText: "Cancelar",
                            confirmText: "Seleccionar",
                            builder: (BuildContext context, Widget child) {
                              return Theme(
                                data: ThemeData.dark().copyWith(
                                  colorScheme: ColorScheme.dark(
                                    primary: Colors.white, //color botones
                                    onPrimary: Colors.black,
                                    surface: colorPrincipal,
                                    onSurface: Colors.white,
                                  ),
                                  dialogBackgroundColor: colorPrincipal,
                                  buttonColor: Colors.white,
                                ),
                                child: child,
                              );
                            },
                            firstDate: DateTime(2001),
                            lastDate: DateTime(2222))
                        .then((date) {
                      diaSel = int.parse(DateFormat('dd').format(date));
                      mesSel = int.parse(DateFormat('MM').format(date));
                      yearSel = int.parse(DateFormat('yyyy').format(date));
                      FirebaseFirestore.instance.collection('Gastos').where("Dia", isEqualTo: diaSel)
            .where("Mes", isEqualTo: mesSel)
            .where("Año", isEqualTo: yearSel).snapshots().listen((result) {
              total = 0;
      result.docs.forEach((result) {
        setState(() {
          total += result.data()['Cantidad'];
        });
      });
    });
                      Future.delayed(const Duration(milliseconds: 1000), () {
                setState(() {
                    
                });
                });
                    });
                   },
                 ),
                 Container(
                   
                   child: Text("Total: \$"+f.format(total),
                   style: TextStyle(
                     color: Colors.black,
                     fontSize: 16,
                     fontWeight: FontWeight.bold
                   ),
                   ),
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
          diaSel == null ?
          Center(
            child: Column(
              children: [
                Image.asset("assets/marfelLoad.gif"),
                Text("Seleccione Una Fecha...",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
                )
              ],
            )
          ):
           Container(
             height: size.height*0.7,
             color: Colors.white,
             child: ListView(
               children: [

                  Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(5),
                    child: StreamBuilder<QuerySnapshot>(
                          
            stream: FirebaseFirestore.instance.collection('Gastos').where("Dia", isEqualTo: diaSel)
            .where("Mes", isEqualTo: mesSel)
            .where("Año", isEqualTo: yearSel)
            .where("TipoGasto", isEqualTo: selectGasto)
            .snapshots(),
            builder: (context, snapshot) {
              return Column(children: snapshot.data.docs.map<Widget>((doc) => _buildListItem(doc)).toList());
            },
            
          ),
                    
                  ),
                  
               ],
             ),
           )
         ],
       ),
       bottomNavigationBar: Container(
      height: MediaQuery.of(context).size.height*0.1,
      decoration: BoxDecoration(
        color: Colors.white,
        
      ),
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
        decoration: BoxDecoration(
                color: colorPrincipal,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                shape: BoxShape.rectangle
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        // ignore: deprecated_member_use
                        FlatButton(
                    padding: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.elliptical(50,75))),
              color: colorPrincipal,
              onPressed: () {
                
                icono = false;
                setState(() {
                  selectGasto = "Ordinario";
                });
                
              },
              child: Text("Ordinario",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16
              ),
              ),
            ),
            icono == false?
            Icon(Icons.circle, size: 15, color: Colors.white) : SizedBox(),
                      ],
                    )
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        // ignore: deprecated_member_use
                        FlatButton(
                    padding: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.elliptical(50,75))),
              color: colorPrincipal,
              onPressed: () {
                
                icono = true;
                setState(() {
                  selectGasto = "ExtraOrdinario";
                });
              },
              child: Text("Extraordinario",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16
              ),
              ),
            ),
            icono == true?
            Icon(Icons.circle, size: 15, color: Colors.white) : SizedBox(),
                      ],
                    )
                  ),
                ],
              ),
      )
    ),
    );
  }

  _buildListItem(DocumentSnapshot doc) {
     
    
     
    return Padding(
      padding: EdgeInsets.all(7.0),
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(doc.data()['Nombre'],
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold
            ),
            ),
            Text("\$"+f.format(doc.data()['Cantidad']),
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold
            ),
            ),
            Text("${doc.data()['Dia']}/${doc.data()['Mes']}/${doc.data()['Año']}",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold
            ),
            ),
          ],
        )
      )
      
    );
    
  }
  //Builder Extraordinario
  // ignore: unused_element
  _buildGastoExtraordinario() {

    return Padding(
      padding: EdgeInsets.all(7.0),
      child: Container(
        decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
        height: MediaQuery.of(context).size.height*0.20,

        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
              margin: EdgeInsets.all(5),
              height: MediaQuery.of(context).size.height*0.05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Gasto Extraordinario Detectado",
                   style: TextStyle(
                     color: Colors.black,
                     fontSize: 18,
                     fontWeight: FontWeight.bold
                   ),
                   ),
                ],
              )
            ),
            Container(
              color: Colors.white,
              
              height: MediaQuery.of(context).size.height*0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
      height: MediaQuery.of(context).size.height*0.08,
      width: MediaQuery.of(context).size.width*0.18,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              'assets/warning_icon.png'),
          fit: BoxFit.fill,
        ),
        
      ),
    ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Congelador whirlpool 7 pies",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600
                      ),
                      ),
                      Text("\$18,000",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600
                      ),
                      ),
                      
                    ],
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
              
              height: MediaQuery.of(context).size.height*0.03,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("26/03/21",
                   style: TextStyle(
                    color: Colors.grey.shade600,
                     fontSize: 16,
                     fontWeight: FontWeight.bold
                   ),
                   ),
                ],
              )
            ),
          ],
        ),
       
      )
      
    );
    
  }



  buildAlert(BuildContext context)
  {
    YudizModalSheet.show(
    context: context,
    
    child: 
    StatefulBuilder(  
               builder: (BuildContext context, StateSetter setState) {
                 return
    Container(
      decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))
               ),
      height: MediaQuery.of(context).size.height-400,
      child: Center(
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.all(15),
                  child: Text("Nuevo Gasto",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18
                ),
                ),
                ),
                
                Container(
                  margin: EdgeInsets.all(10),
                  // ignore: deprecated_member_use
                  child: RaisedButton.icon(
                color: Colors.transparent,
                elevation: 0,
                onPressed: (){

                  if(_nombreController.text == "" || _cantidadController.text == "" ){
                    print("Campos incorrectos");
                  }
                  else{
                        FirebaseFirestore.instance.collection("Gastos").add({
                                            "Mes": DateTime.now().month, 
                                            "Dia": DateTime.now().day, 
                                            "Año": DateTime.now().year,
                                            "Nombre": _nombreController.text,
                                            "Cantidad": double.parse(_cantidadController.text),
                                            "TipoGasto": tipoGasto,
                                            "Usuario": widget.usuario
                                          }).then((value) {
                                            _nombreController.text="";
                                            _cantidadController.text="";
                                            drop1=null;
                                          });
                                        
                                          Navigator.pop(context);
                  }
                  
                 
                }, 
                icon: Icon(Icons.add_circle_rounded, color: colorPrincipal), 
                label: Text("Agregar", style: TextStyle(color: Colors.black),)),
                )
                
              ],
            ),
            SizedBox(height: 15,),
            Container(
              margin: EdgeInsets.all(15),
              child: _buildTextField( Icons.person_add, "Nombre", _nombreController),
            ),
            Container(
              margin: EdgeInsets.all(15),
              child: _buildTextFieldCantidad( Icons.attach_money, "Cantidad", _cantidadController),
            ),
            Container(
              margin: EdgeInsets.all(15),
              child: CustomDropdown(
               enabledColor: colorPrincipal,
        disabledIconColor: Colors.white,
        enabledIconColor: Colors.white,
        enableTextColor: Colors.white,
        elementTextColor: Colors.white,
        openColor: colorPrincipal,
        valueIndex: drop1,
        hint: "Categoria",
        items: [
          CustomDropdownItem(text: "Ordinario"),
          CustomDropdownItem(text: "ExtraOrdinario"),
        ],
        onChanged: (newValue) {
          setState(() => drop1 = newValue);

          switch(drop1)
          {
            case 0:
            tipoGasto="Ordinario";
            break;
            case 1:
            tipoGasto="ExtraOrdinario";
            break;
            
          }
        },
      ),
            )
            
            
          ],
        )
      ),
    );
               }
    ),
    direction: YudizModalSheetDirection.BOTTOM);
  }


_buildTextField( IconData icon, String labelText, TextEditingController controllerPr)
  {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: colorPrincipal)
      ),
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


