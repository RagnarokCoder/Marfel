import 'package:flutter/material.dart';
import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class ProduccionTotal extends StatefulWidget {
  @override
  _ProduccionTotalState createState() => _ProduccionTotalState();
}

class _ProduccionTotalState extends State<ProduccionTotal> {

   getInventario() async {
    var url = 'https://api-paleteria-marfel.herokuapp.com/api/v1/production';
    final response = await http.get(url, headers: {
      'content-type': 'application/json',
      'Accept': 'application/json',
    });

    return json.decode(response.body)['data']['production'];
  }
 List distinctIds = [];
  List produccion = [];
List filteredProduccion = [];
List nombredepaletas = [];
var totaldeunsabor2 = 0;
List totaldepaletas = [];
  @override
  void initState() {
    getInventario().then((body) {
      produccion = filteredProduccion = body;

      for (int i = 0; i < produccion.length; i++) {
        nombredepaletas = produccion
            .where(
                (country) => country['Sabor'].contains(produccion[i]["Sabor"]))
            .toList();

        totaldeunsabor2 = 0;
        for (int i = 0; i < nombredepaletas.length; i++) {
          totaldeunsabor2 += nombredepaletas[i]["Cantidad"];
        }

       

        totaldepaletas
            .add(produccion[i]["Sabor"] + "    " + totaldeunsabor2.toString());
      }

     
       distinctIds = totaldepaletas.toSet().toList();
       
      print(distinctIds);
      setState(() {});
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: colorPrincipal,
        elevation: 5,
        title: Text("Total de produccion"),
        centerTitle: true,
      ),

      body: ListView(
      children: [
Container(
   height: MediaQuery.of(context).size.height ,
            width: MediaQuery.of(context).size.width,
    child: ListView.builder(
          itemCount: distinctIds.length,
          itemBuilder: (BuildContext ctxt, int index){
            return Padding(  padding: EdgeInsets.all(5.0),

            child:Container(
             
              child:Column(
              
                children:[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                  Text(distinctIds[index],style: TextStyle(fontSize: 25,fontWeight: FontWeight.w700),)
                  ],)
                
                ]
              )

            )
            
            
           
            );
            
         
          },
        ))

      ],
      ),
      
    );
  }
}