import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;



class GraficaGastos extends StatefulWidget {
  final String usuario;
  GraficaGastos({Key key, this.usuario}) : super(key: key);
  @override
  _GraficaGastosState createState() => _GraficaGastosState();

  
}

List compras = [];
List filteredCompras = [];
bool icono = true;

class _GraficaGastosState extends State<GraficaGastos> {

      getCompras() async {
          var url = 'https://api-paleteria-marfel.herokuapp.com/api/v1/bill';
          final response = await http.get(url, headers: {
            'content-type': 'application/json',
            'Accept': 'application/json',
          });

          

         return json.decode(response.body)['data']['gastos'];
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
        title: Text("Lista de Gastos"),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.white), onPressed: (){
             
    Navigator.of(context).pop();  

        }),
        centerTitle: true,
      ),
      drawer: CustomAppBar(usuario: widget.usuario,),

      body: ListView(
        children:<Widget>[
          Container(height: MediaQuery.of(context).size.height*1,
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