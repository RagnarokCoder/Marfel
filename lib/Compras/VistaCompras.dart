import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:paleteria_marfel/Compras/VistaComprasList.dart';
import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;



class VistaCompra extends StatefulWidget {
  @override
  _VistaCompraState createState() => _VistaCompraState();

  
}

List compras = [];
List filteredCompras = [];
bool icono = true;

class _VistaCompraState extends State<VistaCompra> {

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


  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrincipal,
        elevation: 5,
        title: Text("Más Comprado"),
        centerTitle: true,
      ),
      drawer: CustomAppbar(),

      body: ListView(
        children:<Widget>[
          Container(height: MediaQuery.of(context).size.height*0.78,
            child: SfCartesianChart(
              isTransposed: true,
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(),
               
              series: <ChartSeries>[
                ColumnSeries<SalesData,String>(dataSource:
                 getColumnData(),
                 xValueMapper: (SalesData sales,_)=>sales.x,
                 yValueMapper: (SalesData sales,_)=>sales.y,
                   width: .1,
                 pointColorMapper: (SalesData sales, _) => Colors.pinkAccent[100],
                 dataLabelSettings: DataLabelSettings(
                   isVisible: true,
                   
                   
                 )

                )
              ],
             
              
            ),
          ),

          Container(
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
                
            
                setState(() {
                   Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => VistaCompraLista()),
                                    );
                });
                
              },
              child: Text("Insumos",
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
                
                
                setState(() {
                 
                });
              },
              child: Text("Más comprados",
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
        ]
      ),
    );
  }
}


class SalesData{
  String x;
  dynamic y;
  SalesData(this.x,this.y);
}

 dynamic getColumnData(){
          List<SalesData> columnData=<SalesData>[
            for(int i = 0; i<compras.length; i++)
            SalesData(compras[i]["Nombre"], compras[i]["Costo"]  ),
            
          ];

          return columnData;
        }