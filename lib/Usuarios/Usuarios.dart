

import 'package:custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:paleteria_marfel/FirebaseAuth/Authentication_Service.dart';
import 'package:paleteria_marfel/HexaColors/HexColor.dart';
import 'package:provider/provider.dart';
import 'package:yudiz_modal_sheet/yudiz_modal_sheet.dart';

class Usuarios extends StatefulWidget {
  final String usuario;
  Usuarios({Key key, this.usuario}) : super(key: key);

  @override
  _UsuariosState createState() => _UsuariosState();
}


int _checkboxValue;
final emailController = TextEditingController();
final passwordController = TextEditingController();
String extensionEmail="";
String finalEmail="...";
Color colorPrincipal = HexColor("#3C9CA8");

class _UsuariosState extends State<Usuarios> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorPrincipal,
        appBar: AppBar(
          title: Text('Nuevo Usuario',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
          ),
          backgroundColor: colorPrincipal,
          centerTitle: true,

        ),
        body:
        ListView(
          children: [
         Container(
           height: MediaQuery.of(context).size.height*0.8,
          padding: new EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FadeInImage(
                height: MediaQuery.of(context).size.height*0.3,
                image: NetworkImage(
                    'https://www.immigration.ca/wp-content/uploads/2020/05/Coronavirus_333965767.jpeg'),
                placeholder: AssetImage('assets/marfelLoad.gif'),
                fadeInDuration: Duration(milliseconds: 200),
              ),
              
              Container(
                height: MediaQuery.of(context).size.height*0.08,
                child: 
                  
                  CustomDropdown(
                  
        valueIndex: _checkboxValue,
        enabledColor: colorPrincipal,
        disabledIconColor: Colors.white,
        enabledIconColor: Colors.white,
        enableTextColor: Colors.white,
        elementTextColor: Colors.white,
        openColor: colorPrincipal,
        
        hint: "Tipo de Usuario: ",
        items: [
          CustomDropdownItem(text: "Inventario"),
          CustomDropdownItem(text: "Ventas"),
          CustomDropdownItem(text: "Pedidos"),
          CustomDropdownItem(text: "Produccion"),
          CustomDropdownItem(text: "Contabilidad"),
        ],
        onChanged: (newValue) {
          setState(() => _checkboxValue = newValue);
          print(_checkboxValue);
          switch(_checkboxValue){
                            case 0:
                            extensionEmail="_inventario@marfel.com";
                            break;
                            case 1:
                            extensionEmail="_ventas@marfel.com";
                            break;
                            case 2:
                            extensionEmail="_pedidos@marfel.com";
                            break;
                            case 3:
                            extensionEmail="_produccion@marfel.com";
                            break;
                            case 4:
                            extensionEmail="_contabilidad@marfel.com";
                            break;
                          }
        },
      )
                
              
              ),
              
              
              Text("$finalEmail",
              style: TextStyle(
                color: Colors.white
              ),
              ),

              Container(
              margin: EdgeInsets.all(15.0),
              height: 90,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: colorPrincipal,
                  borderRadius: BorderRadius.circular(10),
                  ),
              child: Column(
                children: <Widget>[
               
                  Container(

                      child: TextField(
                        onChanged: (valor) {
                  if(valor=="")
                  {
                    finalEmail="";
                  }
                  else
                  {
                    finalEmail = emailController.text+extensionEmail.trim();
                  }
                  
                  setState(() {});
                },
                        controller: emailController,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      prefix: SizedBox(
                        child: Icon(
                          Icons.email,
                          size: 18,
                          color: Colors.white,
                        ),
                        height: 15.0,
                        width: 15.0,
                      ),
                      labelText: "Correo: ",
                      prefixStyle: TextStyle(color: Colors.white, fontSize: 15),
                      labelStyle: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  )),
                  
                  
                ],
              ),
            ),
              
              Container(
              margin: EdgeInsets.all(15.0),
              height: 90,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: colorPrincipal,
                  borderRadius: BorderRadius.circular(10),
                  ),
              child: Column(
                children: <Widget>[
               
                  Container(

                      child: TextField(
                       
                        controller: passwordController,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      prefix: SizedBox(
                        child: Icon(
                          Icons.lock,
                          size: 18,
                          color: Colors.white,
                        ),
                        height: 15.0,
                        width: 15.0,
                      ),
                      labelText: "Contraseña: ",
                      prefixStyle: TextStyle(color: Colors.white, fontSize: 15),
                      labelStyle: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  )),
                  
                  
                ],
              ),
            ),
              
            ],
            
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height*0.05,
          width: MediaQuery.of(context).size.width*0.6,
          margin: EdgeInsets.only(left: 15, right: 15),
          child: RaisedButton(
    textColor: colorPrincipal,
    color: Colors.white,
    child: Text("Agregar"),
    onPressed: () {
      switch(_checkboxValue){
                            case 0:
                            extensionEmail="_inventario@marfel.com";
                            break;
                            case 1:
                            extensionEmail="_ventas@marfel.com";
                            break;
                            case 2:
                            extensionEmail="_pedidos@marfel.com";
                            break;
                            case 3:
                            extensionEmail="_produccion@marfel.com";
                            break;
                            case 4:
                            extensionEmail="_contabilidad@marfel.com";
                            break;
                          }

                          if(emailController.text.isEmpty || passwordController.text.isEmpty)
                          {
                            camposVacios(context);
                          }
                          else
                          {
                            finalEmail = emailController.text+extensionEmail.trim();
                          context.read<AuthenticationService>().signUp(
                            email: finalEmail,
                            password: passwordController.text.trim(),
                          ).then((value) => {
                            passwordController.text="",
                            emailController.text="",
                            _checkboxValue=0,
                            finalEmail="",
                            setState(() {}),
                            usuarioCreado(context)
                          });
                          }                       
    },
    shape:  RoundedRectangleBorder(
      borderRadius:  BorderRadius.circular(15.0),
    ),
  ),
        )
        ]
        )
        );
  }

  usuarioCreado(BuildContext context) {
    YudizModalSheet.show(
        context: context,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50))),
          height: 100,
          child: Center(
              child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Text(
                "Usuario Creado Correctamente!",
                style: (TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton.icon(
                      color: Colors.transparent,
                      elevation: 0,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.check_circle,
                        color: colorPrincipal,
                      ),
                      label: Text(
                        "Confirmar",
                        style: TextStyle(color: Colors.black),
                      )),
                ],
              )
            ],
          )),
        ),
        direction: YudizModalSheetDirection.BOTTOM);
  }

  camposVacios(BuildContext context) {
    YudizModalSheet.show(
        context: context,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50))),
          height: 100,
          child: Center(
              child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Text(
                "No Deje Campos Vacios!",
                style: (TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton.icon(
                      color: Colors.transparent,
                      elevation: 0,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.check_circle,
                        color: colorPrincipal,
                      ),
                      label: Text(
                        "Confirmar",
                        style: TextStyle(color: Colors.black),
                      )),
                ],
              )
            ],
          )),
        ),
        direction: YudizModalSheetDirection.BOTTOM);
  }
}