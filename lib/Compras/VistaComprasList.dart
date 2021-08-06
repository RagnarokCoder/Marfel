import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paleteria_marfel/Compras/AgregarCompra.dart';
import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';
import 'package:http/http.dart' as http;



class VistaCompraLista extends StatefulWidget {
  final String usuario;
  VistaCompraLista({Key key, this.usuario}) : super(key: key);
  @override
  _VistaCompraListaState createState() => _VistaCompraListaState();

  
}

List compras = [];
List filteredCompras = [];
bool icono = false;
NumberFormat f = new NumberFormat("#,##0.00", "es_US");

class _VistaCompraListaState extends State<VistaCompraLista> {

      getCompras() async {
          var url = 'https://api-paleteria-marfel.herokuapp.com/api/v1/bought';
          final response = await http.get(url, headers: {
            'content-type': 'application/json',
            'Accept': 'application/json',
          });

          

         return json.decode(response.body)['data']['boughts'];
        }

   

 @override
  void initState() {
    getCompras().then((body) {
      compras = filteredCompras = body;

      print(compras[0]);

      setState(() {
        });


     
    });

    super.initState();
  }
  void _filterCompras(value) {
    setState(() {
      filteredCompras = compras
          .where((country) =>
              country['Producto'].toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }
bool isSearching = false;

  @override
  Widget build(BuildContext context) {
  Size size = MediaQuery.of(context).size;
   
    return Scaffold(
       drawer: CustomAppBar(usuario: widget.usuario,),
      appBar: AppBar(
        
      
         
        backgroundColor: colorPrincipal,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(),
            Text('Compras',
            style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            !isSearching
            ? SizedBox()
            : Container(
              width: MediaQuery.of(context).size.width*0.3,
              child: TextField(
                onChanged: (value) {
                  _filterCompras(value);
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    hintText: "Buscador",
                    hintStyle: TextStyle(color: Colors.white, fontSize: 14)),
              ),
            )
          ],
        ),
        actions: <Widget>[
           IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AgregarCompra(
                                            usuario: widget.usuario
                                          )),
                                    );
                  },
                ),
          isSearching
              ? IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      this.isSearching = false;
                      filteredCompras = compras;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      this.isSearching = true;
                    });
                  },
                ),
               
        ],
        
      ),
     

      body: ListView(
        children:<Widget>[

          Container(
             height: size.height*0.9,
             color: Colors.white,
             child: ListView(
               children: [

                  Container(
                    height: MediaQuery.of(context).size.height * 0.9,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(15),
                    child: filteredCompras.length > 0
                        ? ListView.builder(
                            itemCount: filteredCompras.length,
                            itemBuilder: (BuildContext context, int index) {

                              return Padding(
      padding: EdgeInsets.all(1),
      child: Container(
        
        height: MediaQuery.of(context).size.height*0.1,
        color: Colors.white,
        child: Column(
          children: [
            Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.all(5),
              child: Text(filteredCompras[index]['Producto'],
                   style: TextStyle(
                     color: Colors.black,
                     fontSize: 14,
                     fontWeight: FontWeight.bold
                   ),
                   ),
            ),
            Container(
              margin: EdgeInsets.all(5),
              child: Column(
                children: [
                  Text("\$ ${f.format(filteredCompras[index]['Costo'])} ",
                   style: TextStyle(
                     color: Colors.black,
                     fontSize: 14,
                     fontWeight: FontWeight.bold
                   ),
                   ),
                   Text("${f.format(filteredCompras[index]['Cantidad'])} ${filteredCompras[index]['UnidadMedida']}",
                   style: TextStyle(
                     color: Colors.black,
                     fontSize: 14,
                     fontWeight: FontWeight.bold
                   ),
                   ),
                ],
              )
            ),

            Container(
              margin: EdgeInsets.all(5),
              child: Text(filteredCompras[index]['Dia'].toString()+"/"+filteredCompras[index]['Mes'].toString()+"/"+filteredCompras[index]['Año'].toString(), 
                   style: TextStyle(
                     color: Colors.black,
                     fontSize: 14,
                     fontWeight: FontWeight.bold
                   ),
                   ),
            ),
            
          ],
        ),
        Divider(
          height: 2,
        
          color: Colors.black
        )
          ],
        )
        
       
      )
      
    );
    
                              
                              
                            })
                        : Center(
                            child: Image.asset("assets/marfelLoad.gif"),
                          ),
                  ),
                  
               ],
             ),
           ),
          
        ]
      ),
    );
  }
}


