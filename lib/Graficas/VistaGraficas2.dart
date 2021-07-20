import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';
import 'package:paleteria_marfel/Grafica_ventas/venta_grafica.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:fl_chart/fl_chart.dart';

import 'GraficaGastos.dart';

class VistaGraficas2 extends StatefulWidget {
  VistaGraficas2({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _VistaGraficas2State createState() => _VistaGraficas2State();
}
 
List gastos= [] ;
List trabajadores = [];
  List filteredGastos = [];
List<double>  datos = [];



class _VistaGraficas2State extends State<VistaGraficas2> {
 
   double total = 0;
   int totaltrabajadores = 0;


  
  final List<FlSpot> dummyData1 = [
    FlSpot(1, 1.4),
    FlSpot(2, 3.4),
    FlSpot(3, 2),
    FlSpot(4, 2.2),
    FlSpot(5, 1.8),

  ];
    
  
  

   getGastos() async {
    var url = 'https://api-paleteria-marfel.herokuapp.com/api/v1/bill';
    final response = await http.get(url, headers: {
      'content-type': 'application/json',
      'Accept': 'application/json',
    }); 
    return json.decode(response.body)['data']['gastos'];
  }

  gettrabajadores() async {
    var url = 'https://api-paleteria-marfel.herokuapp.com/api/v1/worker';
    final response = await http.get(url, headers: {
      'content-type': 'application/json',
      'Accept': 'application/json',
    }); 
  
    return json.decode(response.body)['data']['personal'];
  }


  @override
  void initState() { 
  

  
     getGastos().then((body) {
      gastos = filteredGastos = body;
    
      
      
      for (int i = 0; i < gastos.length; i++) {
        total += gastos[i]["Costo"];
        
        
         
       

     
    }



    
    setState(() {
  });

    }); 


    gettrabajadores().then((body) {
      trabajadores = body;

      
      totaltrabajadores = trabajadores.length;
    
    setState(() {
  });

    });
   


    super.initState();

  }

  Material myTextItems(String title, String subtitle){
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child:Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment:MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment:MainAxisAlignment.center,
               children: <Widget>[

                  Padding(
                   padding: EdgeInsets.all(8.0),
                      child:Text(title,style:TextStyle(
                        fontSize: 20.0,
                        color: Colors.blueAccent,
                      ),),
                    ),

                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:Text(subtitle,style:TextStyle(
                      fontSize: 30.0,
                    ),),
                  ),

               ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Material myCircularItems(String title, String subtitle){
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child:Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment:MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment:MainAxisAlignment.center,
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:Text(title,style:TextStyle(
                      fontSize: 20.0,
                      color: Colors.blueAccent,
                    ),),
                  ),

                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:Text(subtitle,style:TextStyle(
                      fontSize: 30.0,
                    ),),
                  ),

               

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Material mychart1Items(String title, String priceVal,String subtitle) {

   
        
        return Material(
          color: Colors.white,
          elevation: 14.0,
          borderRadius: BorderRadius.circular(24.0),
          shadowColor: Color(0x802196F3),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
    
                      Padding(
                        padding: EdgeInsets.all(1.0),
                        child: Text(title, style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.blueAccent,
                        ),),
                      ),
    
                      Padding(
                        padding: EdgeInsets.all(1.0),
                        child: Text(priceVal, style: TextStyle(
                          fontSize: 30.0,
                        ),),
                      ),
                      Padding(
                        padding: EdgeInsets.all(1.0),
                        child: Text(subtitle, style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.blueGrey,
                        ),),
                      ),
    
                      Padding(
                        padding: EdgeInsets.all(1.0),
                        child: Container(  
                      height: 120,
                      width: 350,
                      child:SfCircularChart(
                        
                         tooltipBehavior: TooltipBehavior(enable: true),
                        series: <CircularSeries>[
                        
                        // Render pie chart
                        PieSeries<SalesData2, String>(
                           enableTooltip: true, 
                            dataSource: getColumnData2(),
                            xValueMapper: (SalesData2 data, _) => data.x,
                            yValueMapper: (SalesData2 data, _) => data.y,
                            dataLabelSettings:DataLabelSettings(isVisible : true)
                        )
                    ])),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Material mychart2Items(String title, String priceVal,String subtitle) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(title, style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.blueAccent,
                    ),),
                  ),

                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(priceVal, style: TextStyle(
                      fontSize: 30.0,
                    ),),
                  ),
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(subtitle, style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.blueGrey,
                    ),),
                  ),

                  Padding(
                  
                    padding: EdgeInsets.all(1.0),
                    child:Container(  
                      height: 200,
                      width: 350,
                      child:SfCartesianChart(
                      
              isTransposed: true,
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(
                
              ),
               
              series: <ChartSeries>[
                ColumnSeries<SalesData,String>(dataSource:
                 getColumnData(),
                 xValueMapper: (SalesData sales,_)=>sales.x,
                 
                 yValueMapper: (SalesData sales,_)=>sales.y,
                  sortingOrder: SortingOrder.ascending,
                  sortFieldValueMapper: (SalesData data, _) => data.y,
                   width: .1,
                   
                   
                 pointColorMapper: (SalesData sales, _) => Colors.pinkAccent[100],
                 dataLabelSettings: DataLabelSettings(
                   isVisible: true,
                 
                   
                 )

                )
              ],
             
              
            )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
          title: Text("Detalles"),
          centerTitle: true,
        ),
      body:Container(
          color:Color(0xffE5E5E5),
          child:StaggeredGridView.count(
            crossAxisCount: 4,
           crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
        children: <Widget>[
               InkWell(  onTap: () {                          
                       Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                        builder: (context) => venta_gastos()),
                                    );
        },    
          child:Padding(
            
            
            padding: const EdgeInsets.all(8.0),
            child: mychart1Items("Ventas por Mes","20,234.32",""),
          )),

       
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: myCircularItems("Total Ventas","45,785.05"),
          ),
          Padding(
            padding: const EdgeInsets.only(right:8.0),
            child: myTextItems("Total Gastos",total.toString()),
          ),
          Padding(
            padding: const EdgeInsets.only(right:8.0),
            child: myTextItems("Trabajadores",totaltrabajadores.toString()),
          ),
          InkWell(
            onTap: (){
                  Navigator.push(
                                      context,
                                     MaterialPageRoute(
                                         builder: (context) => GraficaGastos()),
                                  );
            },
          child:Padding(
            padding: const EdgeInsets.all(8.0),
            child: mychart2Items("Gastos",total.toString(),""),
          )),

        ],
        staggeredTiles: [
          StaggeredTile.extent(4, 250.0),//tamaño de cada widget
          StaggeredTile.extent(2, 250.0),
          StaggeredTile.extent(2, 120.0),
          StaggeredTile.extent(2, 120.0),
          StaggeredTile.extent(4, 350.0),
        ],
      ),
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
            for(int i = 0; i<5; i++)
            SalesData(gastos[i]["Nombre"], gastos[i]["Costo"]),
            
          ];

         
          
          return columnData;
        }




class SalesData2{
  String x;
  dynamic y;
  SalesData2(this.x,this.y);
}

 dynamic getColumnData2(){
          List<SalesData2> columnData=<SalesData2>[
            for(int i = 0; i<5; i++)
            SalesData2(gastos[i]["Mes"].toString(), gastos[i]["Costo"]),
            
          ];

         
          
          return columnData;
        }



