import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paleteria_marfel/Clientes/VistaClientes.dart';
import 'package:paleteria_marfel/Compras/VistaComprasList.dart';
import 'package:paleteria_marfel/FirebaseAuth/Authentication_Service.dart';
import 'package:paleteria_marfel/Gastos/VistaGastos.dart';
import 'package:paleteria_marfel/Graficas/VistaGraficas.dart';
import 'package:paleteria_marfel/HexaColors/HexColor.dart';
import 'package:paleteria_marfel/Inventario/VistaInventario.dart';
import 'package:paleteria_marfel/InventarioStock/InventarioMp.dart';
import 'package:paleteria_marfel/Personal/VistaPersonal.dart';
import 'package:paleteria_marfel/Producci%C3%B3n/VistaProduccion.dart';
import 'package:paleteria_marfel/Ventas/VistaVentas.dart';
import 'package:provider/provider.dart';
import 'package:yudiz_modal_sheet/yudiz_modal_sheet.dart';



 class CustomAppBar extends StatefulWidget {
   final String usuario;
  CustomAppBar({Key key, this.usuario}) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}


Color colorPrincipal = HexColor("#80DEEA");
int tipoAcceso = 0;

class _CustomAppBarState extends State<CustomAppBar> {
   @override
  void initState() {
    super.initState();
    
    var parts = widget.usuario.split("_");
    var prefix = parts[0].trim();
    
    
    print(prefix);

  if(widget.usuario.toString().toUpperCase() == "ADMIN@MARFEL.COM" || widget.usuario.toString()== "$prefix"+"_admin@marfel.com")
  {
    tipoAcceso = 1;
  }
  if(widget.usuario.toString().toUpperCase() == "VENTAS@MARFEL.COM" || widget.usuario.toString()== "$prefix"+"_ventas@marfel.com")
  {
    tipoAcceso = 2;
  }
  if(widget.usuario.toString().toUpperCase() == "INVENTARIO@MARFEL.COM" || widget.usuario.toString()== "$prefix"+"_inventario@marfel.com")
  {
    tipoAcceso = 3;
  }
  
  }

  @override
  Widget build(BuildContext context) {

   
    


    return Drawer(

      child:Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width:double.infinity,
            height: MediaQuery.of(context).size.height*0.19,
            padding:EdgeInsets.only(left: 30, right: 30, top: 30),
            color: colorPrincipal,
            child: Center(
              child: Column(
                children:<Widget>[
                  Container(
                  width:150,
                  height:MediaQuery.of(context).size.height*0.15,
                  decoration:BoxDecoration(
                    shape: BoxShape.circle,
                    image:DecorationImage(
                      image: AssetImage('assets/icono_provisional.png'), fit: BoxFit.fill
                    ),
                  
                  )
                  ),
                  
                ]
                
              ),
              
            ),

            
            
          ),

          Container(
            height:MediaQuery.of(context).size.height*0.81,
            color: colorPrincipal,
            child: Column(
            children:<Widget>[
              tipoAcceso == 1 || tipoAcceso == 2 ? 
            ListTile(
                    leading: Icon(Icons.shopping_cart_rounded,size: 25, color: Colors.white,),
                    title:Text(
                      'VENTAS',
                      style:TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white
                      )
                    ),
                    onTap: (){
                                                                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: VistaVentas(
                                                                    usuario: widget.usuario,
                                                                  )));

                    },
                  ):SizedBox(),
                  tipoAcceso == 1?
                   ListTile(
                    leading: Icon(Icons.shopping_bag_sharp,size: 25, color: Colors.white,),
                    title:Text(
                      'COMPRAS',
                      style:TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white
                      )
                    ),
                    onTap: (){
                                            Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: VistaCompraLista(
                                              usuario: widget.usuario,
                                            )));

                    },
                  ):SizedBox(),
                  tipoAcceso == 1 || tipoAcceso == 3?
                  ListTile(
                    leading: Icon(Icons.storage_outlined, size: 25, color: Colors.white,),
                    title:Text(
                      'STOCK',
                      style:TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white
                      )
                    ),
                    onTap: (){
                                            Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: InventarioMp(
                                              usuario: widget.usuario,
                                            )));

                    },
                  ):SizedBox(),
                  tipoAcceso == 1?
                   ListTile(
                    leading: Icon(Icons.monetization_on,size: 25, color: Colors.white,),
                    title:Text(
                      'GASTOS',
                      style:TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white
                      )
                    ),
                    onTap: (){
                     
                      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: VistaGastos(
                        usuario: widget.usuario,
                      )));

                    },
                  ):SizedBox(),
                  tipoAcceso == 1 || tipoAcceso == 3?
                   ListTile(
                    leading: Icon(Icons.inventory,size: 25, color: Colors.white,),
                    title:Text(
                      'INVENTARIO',
                      style:TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white
                      )
                    ),
                    onTap: (){
                      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: VistaInventario(
                        usuario: widget.usuario,
                      )));
                    },
                  ):SizedBox(),
                  tipoAcceso == 1?
                   ListTile(
                    leading: Icon(Icons.work,size: 25, color: Colors.white,),
                    title:Text(
                      'PRODUCCIÓN',
                      style:TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white
                      )
                    ),
                    onTap: (){
                      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: VistaProduccion(
                        usuario: widget.usuario,
                      )));
                    },
                  ):SizedBox(),
                  tipoAcceso == 1?
                   ListTile(
                    leading: Icon(Icons.bar_chart, size: 25, color: Colors.white,),
                    title:Text(
                      'GRAFICAS',
                      style:TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white
                      )
                    ),
                    onTap: (){
                                            Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: VistaGraficas(
                                              usuario: widget.usuario,
                                            )));

                    },
                  ):SizedBox(),
                  tipoAcceso == 1?
                   ListTile(
                    leading: Icon(Icons.person, size: 25, color: Colors.white,),
                    title:Text(
                      'CLIENTES',
                      style:TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white
                      )
                    ),
                    onTap: (){
                      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: VistaClientes(
                        usuario: widget.usuario,
                      )));
                    },
                  ):SizedBox(),
                  tipoAcceso == 1?
                   ListTile(
                    leading: Icon(Icons.supervised_user_circle,size: 25, color: Colors.white,),
                    title:Text(
                      'PERSONAL',
                      style:TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white
                      )
                    ),
                    onTap: (){
                      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: VistaPersonal(
                        usuario: widget.usuario,
                      )));
                    },
                  ):SizedBox(),
                  Spacer(),
                  ListTile(
                trailing: Wrap(
                  spacing: 180, // space between two icons
                  children: <Widget>[
                   
                   IconButton(icon: Icon(Icons.login_outlined,size: 25, color: Colors.white),
                    onPressed: (){
                      cerrarSesion(context);
                    },
                   
                   ),
                  ],
                ),
              )

            ])),

            

              

                 
        ],
      )
     
    );
  }

  cerrarSesion(BuildContext context)
  {
    YudizModalSheet.show(
    context: context,
    child: Container(
      decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))
               ),
      height: 100,
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 15,),
            Text("¿Desea Cerrar Sesión?", style: (
                                      TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: colorPrincipal
                                      )
                                    ),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton.icon(
                color: Colors.transparent,
                elevation: 0,
                onPressed: (){
                  context.read<AuthenticationService>().signOut();
                 
                  Navigator.pop(context);
                }, 
                icon: Icon(Icons.check_circle, color: Color(0xff00cf8d),), 
                label: Text("Confirmar", style: TextStyle(color: colorPrincipal),)),
                
              ],
            )
          ],
        )
      ),
    ),
    direction: YudizModalSheetDirection.BOTTOM);
  }

}