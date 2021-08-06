  

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_dropdown/custom_dropdown.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:paleteria_marfel/Graficas/GananciaDetails.dart';
import 'package:paleteria_marfel/HexaColors/HexColor.dart';



class LineChartSample1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

var anoActual = DateTime.now().year;

double totalVentas = 0;
int anoSeleccionado;
 dynamic venta, venta1;
double ventasEnero=0, ventasMarzo=0, ventasAbril=0, ventasMayo=0, ventasJunio=0, ventasJulio=0, ventasAgosto=0, ventasSep=0, ventasOct=0, ventasNov=0, ventasDic=0;
double gastosEnero=0, gastosFebrero=0, gastosMarzo=0, gastosAbril=0, gastosMayo=0, gastosJunio=0, gastosJulio=0, gastosAgosto=0, gastosSep=0, gastosOct=0, gastosNov=0, gastosDic=0;
double comprasEnero=0, comprasFebrero=0, comprasMarzo=0, comprasAbril=0, comprasMayo=0, comprasJunio=0, comprasJulio=0, comprasAgosto=0, comprasSep=0, comprasOct=0, comprasNov=0, comprasDic=0;

 // ignore: deprecated_member_use
 dynamic arrVent = new List(11);
// ignore: deprecated_member_use
dynamic arrGast = new List(11);
dynamic aux, aux1, mayor;
int _checkboxValue, actionbutton;
int _checkboxValue1;
//formato moneda
NumberFormat f = new NumberFormat("#,##0.00", "es_US");
//total ventas
double totalVentasAno = 0;
//total gastos
double totalGastosAno = 0;
//total compras
double totalComprasAno = 0;
//ganancias
  int touchedIndex = -1;
double gananciaMesActual=0, gananciasFeb =0, gananciasMar =0, gananciasAbr =0, gananciasMay =0, gananciasJun =0, gananciasJul =0, gananciasAgo =0, gananciasSep =0, gananciasOct =0, gananciasNov =0, gananciasDic =0;
double gananciaAno=0;
//MES
String mesSelect = "";
//widget
bool cargando;
Color colorPrincipal = HexColor("#3C9CA8");
Color colorVentas = HexColor("#FFD700");
Color colorGastos = HexColor("#115173");
Color colorCompras = HexColor("#E94560");
//seleccionadas
double venAct=0, gasAct=0, comAct=0; 


class LineChartSample1State extends State<LineChartSample1> {
  bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
    

      

  }
 
  @override
  Widget build(BuildContext context)  {


               
         
    

    return  AspectRatio(
      aspectRatio: 1.23,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          gradient: LinearGradient(
            colors: [
              Color(0xff2c274c),
              Color(0xff46426c),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Scaffold(
          appBar: _getCustomAppBar(),
          backgroundColor: Colors.white,
         body:
           Container(
             height: MediaQuery.of(context).size.height,
             child:  ListView(
              
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height*0.1,
                  child: Row(
                    children: [
                      Container(
                  width: MediaQuery.of(context).size.width*0.5,
                  height: MediaQuery.of(context).size.height*0.08,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 70,
                        width: 120,
                        child: CustomDropdown(
        valueIndex: _checkboxValue,
        enabledColor: colorPrincipal,
        disabledIconColor: Colors.black,
        enabledIconColor: Colors.black,
        enableTextColor: Colors.white,
        elementTextColor: Colors.white,
        openColor: colorPrincipal,
        
        hint: "Año: ",
        items: [
          CustomDropdownItem(text: "2021"),
          CustomDropdownItem(text: "2022"),
          CustomDropdownItem(text: "2023"),
          CustomDropdownItem(text: "2024"),
          CustomDropdownItem(text: "2025"),
        ],
        onChanged: (newValue) {
          setState(() => _checkboxValue = newValue);
          print(_checkboxValue);
          setState(() {
            bottonGenerar();
          });
          Future.delayed(const Duration(seconds: 1), () {
                setState(() {
                     
                });
                });
                 

                switch(_checkboxValue)
                {
                  case 0:
                  anoSeleccionado=2021;
                  break;
                  case 1:
                  anoSeleccionado=2022;
                  break;
                  case 2:
                  anoSeleccionado=2023;
                  break;
                  case 3:
                  anoSeleccionado=2024;
                  break;
                }
        },
      ),
                      ),
      
              
             
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width*0.5,
                  height: MediaQuery.of(context).size.height*0.08,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 70,
                        width: MediaQuery.of(context).size.width*0.4,
                        child: CustomDropdown(
        valueIndex: _checkboxValue1,
        enabledColor: colorPrincipal,
        disabledIconColor: Colors.black,
        enabledIconColor: Colors.black,
        enableTextColor: Colors.white,
        elementTextColor: Colors.white,
        openColor: colorPrincipal,
        
        hint: "Mes: ",
        items: [
          CustomDropdownItem(text: "ENERO"),
          CustomDropdownItem(text: "FEBRERO"),
          CustomDropdownItem(text: "MARZO"),
          CustomDropdownItem(text: "ABRIL"),
          CustomDropdownItem(text: "MAYO"),
          CustomDropdownItem(text: "JUNIO"),
          CustomDropdownItem(text: "JULIO"),
          CustomDropdownItem(text: "AGOSTO"),
          CustomDropdownItem(text: "SEPTIEMBRE"),
          CustomDropdownItem(text: "OCTUBRE"),
          CustomDropdownItem(text: "NOVIEMBRE"),
          CustomDropdownItem(text: "DICIEMBRE"),
        ],
        onChanged: (newValue) {
          setState(() => _checkboxValue1 = newValue);
          setState(() {
            switch(_checkboxValue1)
          {
            case 0:
            mesSelect="Enero";
            venAct = ventasEnero;
            gasAct = gastosEnero;
            comAct = comprasEnero;
            break;
            case 1:
            mesSelect="Febrero";
            venAct = totalVentas;
            gasAct = gastosFebrero;
            comAct = comprasFebrero;
            break;
            case 2:
            mesSelect="Marzo";
            venAct = ventasMarzo;
            gasAct = gastosMarzo;
            comAct = comprasMarzo;
            break;
            case 3:
            mesSelect="Abril";
            venAct = ventasAbril;
            gasAct = gastosAbril;
            comAct = comprasAbril;
            break;
            case 4:
            mesSelect="Mayo";
            venAct = ventasMayo;
            gasAct = gastosMayo;
            comAct = comprasMayo;
            break;
            case 5:
            mesSelect="Junio";
            venAct = ventasJunio;
            gasAct = gastosJunio;
            comAct = comprasJunio;
            break;
            case 6:
            mesSelect="Julio";
            venAct = ventasJulio;
            gasAct = gastosJulio;
            comAct = comprasJulio;
            break;
            case 7:
            mesSelect="Agosto";
            venAct = ventasAgosto;
            gasAct = gastosAgosto;
            comAct = comprasAgosto;
            break;
            case 8:
            mesSelect="Septiembre";
            venAct = ventasSep;
            gasAct = gastosSep;
            comAct = comprasSep;
            break;
            case 9:
            mesSelect="Octubre";
            venAct = ventasOct;
            gasAct = gastosOct;
            comAct = comprasOct;
            break;
            case 10:
            mesSelect="Noviembre";
            venAct = ventasNov;
            gasAct = gastosNov;
            comAct = comprasNov;
            break;
            case 11:
            mesSelect="Diciembre";
            venAct = ventasDic;
            gasAct = gastosDic;
            comAct = comprasDic;
            break;
          }
          });
        },
      ),
                      ),
      
              
             
                    ],
                  ),
                ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(mesSelect==""? "...": mesSelect,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                ),
                venAct==0?
                Container(
                  height: MediaQuery.of(context).size.height*0.3,
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Image.asset("assets/marfelLoad.gif"),
                ):
                Card(
                   margin: EdgeInsets.only(left: 10, right: 10),
        color: colorPrincipal,
        elevation: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
           
            Container(
              
              height: MediaQuery.of(context).size.height*0.3,
              
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                      
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      sections: 
                      _checkboxValue1==0?
                      showingSections(ventasEnero, gastosEnero, comprasEnero):
                      _checkboxValue1==1?
                      showingSections(totalVentas, gastosFebrero, comprasFebrero):
                      _checkboxValue1==2?
                      showingSections(ventasMarzo, gastosMarzo, comprasMarzo):
                      _checkboxValue1==3?
                      showingSections(ventasAbril, gastosAbril, comprasAbril):
                      _checkboxValue1==4?
                      showingSections(ventasMayo, gastosMayo, comprasMayo):
                      _checkboxValue1==5?
                      showingSections(ventasJunio, gastosJunio, comprasJunio):
                      _checkboxValue1==6?
                      showingSections(ventasJulio, gastosJulio, comprasJulio):
                      _checkboxValue1==7?
                      showingSections(ventasAgosto, gastosAgosto, comprasAgosto):
                      _checkboxValue1==8?
                      showingSections(ventasSep, gastosSep, comprasSep):
                      _checkboxValue1==9?
                      showingSections(ventasOct, gastosOct, comprasOct):
                      _checkboxValue1==10?
                      showingSections(ventasNov, gastosNov, comprasNov):
                      _checkboxValue1==11?
                      showingSections(ventasDic, gastosDic, comprasDic):
                      showingSections(0, 0, 0)
                      
                      
                      ),
                ),
              ),
            ),
            
             Container(
               height: MediaQuery.of(context).size.height*0.2,
               child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:  <Widget>[
                InkWell(
                   child: Row(
                  children: [
                    Container(
                        height: 15,
                        width: 15,
                        color: colorVentas,
                      ),
                      SizedBox(width: 10,),
                    Text("Ventas\n\$"+f.format(venAct).toString(),
                style: TextStyle(
                  color: Colors.black
                ),
                ),
                  ],
                ),
      //tap de grafica pie
      onTap: (){
       
        Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => GananaciasDetails(
                                   mes: _checkboxValue1+1,
                                   year: anoSeleccionado,
                                   mesSel: mesSelect,
                                   coleccion: "Ventas",
                                  )));
      },
                 ),
                //ink gastos
                InkWell(
                   child: Row(
                  children: [
                    Container(
                        height: 15,
                        width: 15,
                        color: colorGastos,
                      ),
                      SizedBox(width: 10,),
                    Text("Gastos\n\$"+f.format(gasAct).toString(),
                style: TextStyle(
                  color: Colors.black
                ),
                ),
                  ],
                ),
      //tap de grafica pie
      onTap: (){
       
        Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => GananaciasDetails(
                                   mes: _checkboxValue1+1,
                                   year: anoSeleccionado,
                                   mesSel: mesSelect,
                                   coleccion: "Gastos",
                                  )));
      },
                 ),
                 // ink compras
                InkWell(
                   child: Row(
                  children: [
                    Container(
                        height: 15,
                        width: 15,
                        color: colorCompras,
                      ),
                      SizedBox(width: 10,),
                    Text("Compras\n\$"+f.format(comAct).toString(),
                style: TextStyle(
                  color: Colors.black
                ),
                ),
                  ],
                ),
      //tap de grafica pie
      onTap: (){
       
        Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => GananaciasDetails(
                                   mes: _checkboxValue1+1,
                                   year: anoSeleccionado,
                                   mesSel: mesSelect,
                                   coleccion: "Compras",
                                  )));
      },
                 ),
              ],
            ),
             )
          ],
        ),
      ),
                 
                
                Container(
                   width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center, //Center Column contents vertically,
crossAxisAlignment: CrossAxisAlignment.center, 
                    children: [
                      SizedBox(width: 15,),
                      Container(
                        height: 15,
                        width: 15,
                        color: colorVentas,
                      ),
                      SizedBox(width: 10,),
                      Text(
                  'Ventas \n'+'\$${f.format(totalVentasAno)}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(width: 15,),
                      Container(
                        height: 15,
                        width: 15,
                        color: colorGastos,
                      ),
                      SizedBox(width: 10,),
                      Text(
                  'Gastos\n'+'\$${f.format(totalGastosAno)}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(width: 15,),
                      Container(
                        height: 15,
                        width: 15,
                        color: colorCompras,
                      ),
                      SizedBox(width: 10,),
                      Text(
                  'Compras\n'+'\$${f.format(totalComprasAno)}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width-100,
                  height: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center, //Center Column contents vertically,
crossAxisAlignment: CrossAxisAlignment.center, //Center Column contents horizontally,
                    children: [
                      
                      SizedBox(width: 15,),
                      Container(
                        width: MediaQuery.of(context).size.width*0.8,
                        child: Marquee(
  child:Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      //Enero
      Text('Enero: \$${f.format(gananciaMesActual)}',
  style: TextStyle(fontWeight: FontWeight.bold, color: gananciaMesActual < 0 ? Colors.red: Colors.green)),
  Icon(gananciaMesActual < 0 ? Icons.arrow_drop_down: Icons.arrow_drop_up, color: gananciaMesActual < 0 ? Colors.red : Colors.green, size: 25),
  
  //Febrero
      Text('Febrero: \$${f.format(gananciasFeb)}',
  style: TextStyle(fontWeight: FontWeight.bold, color: gananciasFeb < 0 ? Colors.red: Colors.green)),
  Icon(gananciasFeb < 0 ? Icons.arrow_drop_down: Icons.arrow_drop_up, color: gananciasFeb < 0 ? Colors.red : Colors.green, size: 25),

  //Marzo
      Text('Marzo: \$${f.format(gananciasMar)}',
  style: TextStyle(fontWeight: FontWeight.bold, color: gananciasMar < 0 ? Colors.red: Colors.green)),
  Icon(gananciasMar < 0 ? Icons.arrow_drop_down: Icons.arrow_drop_up, color: gananciasMar < 0 ? Colors.red : Colors.green, size: 25),
   
  //Abril
      Text('Abril: \$${f.format(gananciasAbr)}',
  style: TextStyle(fontWeight: FontWeight.bold, color: gananciasAbr < 0 ? Colors.red: Colors.green)),
  Icon(gananciasAbr < 0 ? Icons.arrow_drop_down: Icons.arrow_drop_up, color: gananciasAbr < 0 ? Colors.red : Colors.green, size: 25),
    SizedBox(width: 2,),
  //Mayo
      Text('Mayo: \$${f.format(gananciasMay)}',
  style: TextStyle(fontWeight: FontWeight.bold, color: gananciasMay < 0 ? Colors.red: Colors.green)),
  Icon(gananciasMay < 0 ? Icons.arrow_drop_down: Icons.arrow_drop_up, color: gananciasMay < 0 ? Colors.red : Colors.green, size: 25),
     SizedBox(width: 2,),
  //Junio
      Text('Junio: \$${f.format(gananciasJun)}',
  style: TextStyle(fontWeight: FontWeight.bold, color: gananciasJun < 0 ? Colors.red: Colors.green)),
  Icon(gananciasJun < 0 ? Icons.arrow_drop_down: Icons.arrow_drop_up, color: gananciasJun < 0 ? Colors.red : Colors.green, size: 25),
     SizedBox(width: 2,),
  //Julio
      Text('Julio: \$${f.format(gananciasJul)}',
  style: TextStyle(fontWeight: FontWeight.bold, color: gananciasJul < 0 ? Colors.red: Colors.green)),
  Icon(gananciasJul < 0 ? Icons.arrow_drop_down: Icons.arrow_drop_up, color: gananciasJul < 0 ? Colors.red : Colors.green, size: 25),
  //Agosto
      Text('Agosto: \$${f.format(gananciasAgo)}',
  style: TextStyle(fontWeight: FontWeight.bold, color: gananciasAgo < 0 ? Colors.red: Colors.green)),
  Icon(gananciasAgo < 0 ? Icons.arrow_drop_down: Icons.arrow_drop_up, color: gananciasAgo < 0 ? Colors.red : Colors.green, size: 25),
  //Septiembre
      Text('Septiembre: \$${f.format(gananciasSep)}',
  style: TextStyle(fontWeight: FontWeight.bold, color: gananciasSep < 0 ? Colors.red: Colors.green)),
  Icon(gananciasSep < 0 ? Icons.arrow_drop_down: Icons.arrow_drop_up, color: gananciasSep < 0 ? Colors.red : Colors.green, size: 25),
  //Octubre
      Text('Octubre: \$${f.format(gananciasOct)}',
  style: TextStyle(fontWeight: FontWeight.bold, color: gananciasOct < 0 ? Colors.red: Colors.green)),
  Icon(gananciasOct < 0 ? Icons.arrow_drop_down: Icons.arrow_drop_up, color: gananciasOct < 0 ? Colors.red : Colors.green, size: 25),
  //Noviembre
      Text('Noviembre: \$${f.format(gananciasNov)}',
  style: TextStyle(fontWeight: FontWeight.bold, color: gananciasNov < 0 ? Colors.red: Colors.green)),
  Icon(gananciasNov < 0 ? Icons.arrow_drop_down: Icons.arrow_drop_up, color: gananciasNov < 0 ? Colors.red : Colors.green, size: 25),
  //Diciembre
      Text('Diciembre: \$${f.format(gananciasDic)}',
  style: TextStyle(fontWeight: FontWeight.bold, color: gananciasDic < 0 ? Colors.red: Colors.green)),
  Icon(gananciasDic < 0 ? Icons.arrow_drop_down: Icons.arrow_drop_up, color: gananciasDic < 0 ? Colors.red : Colors.green, size: 25),
      
    ],
  ),
  direction: Axis.horizontal,
  animationDuration: Duration(seconds: 40),
  backDuration: Duration(milliseconds: 4000),
  pauseDuration: Duration(milliseconds: 2000),
  
  directionMarguee: DirectionMarguee.oneDirection,

)
                      )
                    ],
                  )
                ),
                Container(
                  width: MediaQuery.of(context).size.width-100,
                  height: 40,
                  child: Row(
                     mainAxisAlignment: MainAxisAlignment.center, //Center Column contents vertically,
crossAxisAlignment: CrossAxisAlignment.center, 
                    children: [
                      
                       Text('\$${f.format(gananciaAno)}',
  style: TextStyle(fontWeight: FontWeight.bold, color: gananciaAno < 0 ? Colors.red: Colors.green)),
  Icon(gananciaAno < 0 ? Icons.arrow_drop_down: Icons.arrow_drop_up, color: gananciaAno < 0 ? Colors.red : Colors.green, size: 25),
                    ],
                  )
                ),
                
                
                
                
                Container(
                  height: MediaQuery.of(context).size.height*0.5,
                  width: MediaQuery.of(context).size.width*0.9,
                  child: LineChart(
                      isShowingMainData ? sampleData1() : sampleData2(),
                      swapAnimationDuration: const Duration(milliseconds: 250),
                    ),
                )
              ],
            ),
           )
            
          
        )
      ),
    );
  }

  LineChartData sampleData1() {
    return LineChartData(

      lineTouchData: LineTouchData(

        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,

          reservedSize: 8,
          getTextStyles: (value) => const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 9,
          ),
          margin: 10,
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return 'ENE';
              case 2:
                return 'FEB';
              case 3:
                return 'MAR';
              case 4:
                return 'ABR';
              case 5:
                return 'MAY';
              case 6:
                return 'JUN';
              case 7:
                return 'JUL';
              case 8:
                return 'AGO';
              case 9:
                return 'SEP';
              case 10:
                return 'OCT';
              case 11:
                return 'NOV';
              case 12:
                return 'DIC';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 9,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 10000:
                return '10k';
              case 50000:
                return '50k';
              case 100000:
                return '100k';
              case 200000:
                return '200k';
            }
            return '';
          },
          margin: 5,
          reservedSize: 20,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 2,
          ),
          left: BorderSide(
            color: Colors.black,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: 1,
      maxX: 12,
      maxY: aux,
      minY: 0,
      lineBarsData: linesBarData1(),
    );
  }

  List<LineChartBarData> linesBarData1() {
    final LineChartBarData lineChartBarData1 = LineChartBarData(
      //grafica gastos
      spots: [
        FlSpot(1, gastosEnero),
        FlSpot(2, gastosFebrero),
        FlSpot(3, gastosMarzo),
        FlSpot(4, gastosAbril),
        FlSpot(5, gastosMayo),
        FlSpot(6, gastosJunio),
        FlSpot(7, gastosJulio),
        FlSpot(8, gastosAgosto),
        FlSpot(9, gastosSep),
        FlSpot(10, gastosOct),
        FlSpot(11, gastosNov),
        FlSpot(12, gastosDic),
      ],
      isCurved: true,

      colors: [
         colorGastos,
      ],
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );


    //grafica ventas
    final LineChartBarData lineChartBarData2 = LineChartBarData(
      spots: [
        FlSpot(1, ventasEnero),
        FlSpot(2, totalVentas),
        FlSpot(3, ventasMarzo),
        FlSpot(4, ventasAbril),
        FlSpot(5, ventasMayo),
        FlSpot(6, ventasJunio),
        FlSpot(7, ventasJulio),
        FlSpot(8, ventasAgosto),
        FlSpot(9, ventasSep),
        FlSpot(10, ventasOct),
        FlSpot(11, ventasNov),
        FlSpot(12, ventasDic),

        
        
      ],
      isCurved: true,
      colors: [
        colorVentas,
      ],
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
      ),
      belowBarData: BarAreaData(show: false, colors: [
        const Color(0x00aa4cfc),
      ]),
    );


    final LineChartBarData lineChartBarData3 = LineChartBarData(
      spots: [
        FlSpot(1, comprasEnero),
        FlSpot(2, comprasFebrero),
        FlSpot(3, comprasMarzo),
        FlSpot(4, comprasAbril),
        FlSpot(5, comprasMayo),
        FlSpot(6, comprasJunio),
        FlSpot(7, comprasJulio),
        FlSpot(8, comprasAgosto),
        FlSpot(9, comprasSep),
        FlSpot(10, comprasOct),
        FlSpot(11, comprasNov),
        FlSpot(12, comprasDic),
        
      ],
      isCurved: true,
      colors:  [
        colorCompras,
      ],
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    return [
      lineChartBarData1,
      lineChartBarData2,
      lineChartBarData3,
    ];
  }

  LineChartData sampleData2() {
    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: false,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'SEPT';
              case 7:
                return 'OCT';
              case 12:
                return 'DEC';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 10000:
                return '10,000';
              case 2:
                return '2m';
              case 3:
                return '3m';
              case 4:
                return '5m';
              case 5:
                return '6m';
            }
            return '';
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(
              color: Color(0xff4e4965),
              width: 4,
            ),
            left: BorderSide(
              color: Colors.transparent,
            ),
            right: BorderSide(
              color: Colors.transparent,
            ),
            top: BorderSide(
              color: Colors.transparent,
            ),
          )),
      minX: 0,
      maxX: 14,
      maxY: 6,
      minY: 0,
      lineBarsData: linesBarData2(),
    );
  }

  List<LineChartBarData> linesBarData2() {
    return [
      LineChartBarData(
        spots: [
          FlSpot(1, 1),
          FlSpot(3, 4),
          FlSpot(5, 1.8),
          FlSpot(7, 5),
          FlSpot(10, 2),
          FlSpot(12, 2.2),
          FlSpot(13, 1.8),
        ],
        isCurved: true,
        curveSmoothness: 0,
        colors: const [
          Color(0x444af699),
        ],
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: false,
        ),
      ),
      LineChartBarData(
        spots: [
          FlSpot(1, 1),
          FlSpot(3, 2.8),
          FlSpot(7, 1.2),
          FlSpot(10, 2.8),
          FlSpot(12, 2.6),
          FlSpot(13, 3.9),
        ],
        isCurved: true,
        colors: const [
          Color(0x99aa4cfc),
        ],
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(show: true, colors: [
          const Color(0x33aa4cfc),
        ]),
      ),
      LineChartBarData(
        spots: [
          FlSpot(1, 3.8),
          FlSpot(3, 1.9),
          FlSpot(6, 5),
          FlSpot(10, 3.3),
          FlSpot(13, 4.5),
        ],
        isCurved: true,
        curveSmoothness: 0,
        colors: const [
          Color(0x4427b6fc),
        ],
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(
          show: false,
        ),
      ),
    ];
  }
  
  bottonGenerar(){
    

                      
                     setState(() {
                    resetGraficas();
                  });
                
                int anoSeleccionado;

                switch(_checkboxValue)
                {
                  case 0:
                  anoSeleccionado=2021;
                  break;
                  case 1:
                  anoSeleccionado=2022;
                  break;
                  case 2:
                  anoSeleccionado=2023;
                  break;
                  case 3:
                  anoSeleccionado=2024;
                  break;
                }
                
                    //Ventas
      FirebaseFirestore.instance.collection("Ventas").where("Año", isEqualTo: anoSeleccionado).snapshots().listen((result) {
      result.docs.forEach((result) { 
        dynamic mes = result.data()['Mes'].toString();
        
        switch(mes)
        {
          case "1":
          venta1 = result.data()['Total'].toString();
          dynamic ventaActual1 = double.parse(venta1);
          ventasEnero += ventaActual1;  
          arrVent[0] = ventasEnero;
          break;
          case "2":
          venta = result.data()['Total'].toString();
          dynamic ventaActual = double.parse(venta);
          totalVentas += ventaActual;
          arrVent[1] = totalVentas;
          break;
          case "3":
          dynamic ventas = result.data()['Total'].toString();
          dynamic ventaActual = double.parse(ventas);
          ventasMarzo += ventaActual;
          arrVent[2] = ventasMarzo;
          break;
          case "4":
          dynamic ventas = result.data()['Total'].toString();
          dynamic ventaActual = double.parse(ventas);
          ventasAbril += ventaActual;
          arrVent[3] = ventasAbril;
          break;
          case "5":
          dynamic ventas = result.data()['Total'].toString();
          dynamic ventaActual = double.parse(ventas);
          ventasMayo += ventaActual;
          arrVent[4] = ventasMayo;
          break;
          case "6":
          dynamic ventas = result.data()['Total'].toString();
          dynamic ventaActual = double.parse(ventas);
          ventasJunio += ventaActual;
          arrVent[5] = ventasJunio;
          break;
          case "7":
          dynamic ventas = result.data()['Total'].toString();
          dynamic ventaActual = double.parse(ventas);
          ventasJulio += ventaActual;
          arrVent[6] = ventasJulio;
          break;
          case "8":
          dynamic ventas = result.data()['Total'].toString();
          dynamic ventaActual = double.parse(ventas);
          ventasAgosto += ventaActual;
          arrVent[7] = ventasAgosto;
          break;
          case "9":
          dynamic ventas = result.data()['Total'].toString();
          dynamic ventaActual = double.parse(ventas);
          ventasSep += ventaActual;
          arrVent[8] = ventasSep;
          break;
          case "10":
          dynamic ventas = result.data()['Total'].toString();
          dynamic ventaActual = double.parse(ventas);
          ventasOct += ventaActual;
          arrVent[9] = ventasOct;
          break;
          case "11":
          dynamic ventas = result.data()['Total'].toString();
          dynamic ventaActual = double.parse(ventas);
          ventasNov += ventaActual;
          arrVent[10] = ventasNov;
          break;
          case "12":
          dynamic ventas = result.data()['Total'].toString();
          dynamic ventaActual = double.parse(ventas);
          ventasDic += ventaActual;
          arrVent[11] = ventasDic;
          break;
        }
        
       
          
      });
      
      totalVentasAno = ventasEnero + totalVentas + ventasMarzo + ventasAbril + ventasMayo + ventasJunio + ventasJulio + ventasAgosto +
      ventasSep + ventasOct + ventasNov + ventasDic; 
      
              
               
    });
setState(() {
  
});
     //Gastos
      FirebaseFirestore.instance.collection("Gastos").where("Año", isEqualTo: anoSeleccionado).snapshots().listen((result) {
      result.docs.forEach((result) { 
        dynamic mes = result.data()['Mes'].toString();
        
        
        switch(mes)
        {
          case "1":
          dynamic gasto1 = result.data()['Cantidad'].toString();
          dynamic gastoActual1 = double.parse(gasto1);
          gastosEnero += gastoActual1;  
          arrGast[0] = gastosEnero;
          break;
          case "2":
          dynamic gasto = result.data()['Cantidad'].toString();
          dynamic gastoActual = double.parse(gasto);
          gastosFebrero += gastoActual;
          arrGast[1] = gastosFebrero;
          break;
          case "3":
          dynamic gastos = result.data()['Cantidad'].toString();
          dynamic gastoActual = double.parse(gastos);
          gastosMarzo += gastoActual;
          arrGast[2] = gastosMarzo;
          break;
          case "4":
          dynamic gastos = result.data()['Cantidad'].toString();
          dynamic gastoActual = double.parse(gastos);
          gastosAbril += gastoActual;
          arrGast[3] = gastosAbril;
          break;
          case "5":
          dynamic gastos = result.data()['Cantidad'].toString();
          dynamic gastoActual = double.parse(gastos);
          gastosMayo += gastoActual;
          arrGast[4] = gastosMayo;
          break;
          case "6":
          dynamic gastos = result.data()['Cantidad'].toString();
          dynamic gastoActual = double.parse(gastos);
          gastosJunio += gastoActual;
          arrGast[5] = gastosJunio;
          break;
          case "7":
          dynamic gastos = result.data()['Cantidad'].toString();
          dynamic gastoActual = double.parse(gastos);
          gastosJulio += gastoActual;
          arrGast[6] = ventasJulio;
          break;
          case "8":
          dynamic gastos = result.data()['Cantidad'].toString();
          dynamic gastoActual = double.parse(gastos);
          gastosAgosto += gastoActual;
          arrGast[7] = gastosAgosto;
          break;
          case "9":
          dynamic gastos = result.data()['Cantidad'].toString();
          dynamic gastoActual = double.parse(gastos);
          gastosSep += gastoActual;
          arrGast[8] = gastosSep;
          break;
          case "10":
          dynamic gastos = result.data()['Cantidad'].toString();
          dynamic gastoActual = double.parse(gastos);
          gastosOct += gastoActual;
          arrGast[9] = gastosOct;
          break;
          case "11":
          dynamic gastos = result.data()['Cantidad'].toString();
          dynamic gastoActual = double.parse(gastos);
          gastosNov += gastoActual;
          arrGast[10] = gastosNov;
          break;
          case "12":
          dynamic gastos = result.data()['Cantidad'].toString();
          dynamic gastoActual = double.parse(gastos);
          gastosDic += gastoActual;
          arrGast[11] = gastosDic;
          break;
        }
        
          
                  
        totalGastosAno = gastosEnero+gastosFebrero+gastosMarzo+gastosAbril+gastosMayo+gastosJunio+gastosJulio+gastosAgosto+gastosSep+gastosOct+gastosNov+gastosDic;
        
             
               print("Total Ventas: " + totalVentasAno.toString());
         
      });
      
    });
    //Proveedores
    FirebaseFirestore.instance.collection("Compras").where("Año", isEqualTo: anoSeleccionado).snapshots().listen((result) {
      result.docs.forEach((result) { 
        dynamic mes = result.data()['Mes'].toString();
        
        switch(mes)
        {
          case "1":
          dynamic gasto1 = result.data()['Costo'].toString();
          dynamic gastoActual1 = double.parse(gasto1);
          comprasEnero += gastoActual1;  
          gananciaMesActual = ventasEnero-gastosEnero-comprasEnero; 
          print("Enero: "+ gananciaMesActual.toString());
          break;
          case "2":
          dynamic gasto = result.data()['Costo'].toString();
          dynamic gastoActual = double.parse(gasto);
          comprasFebrero += gastoActual;
          gananciasFeb = totalVentas-gastosFebrero-comprasFebrero;
          break;
          case "3":
          dynamic gastos = result.data()['Costo'].toString();
          dynamic gastoActual = double.parse(gastos);
          comprasMarzo += gastoActual;
          gananciasMar = ventasMarzo-gastosMarzo-comprasMarzo;
          break;
          case "4":
          dynamic gastos = result.data()['Costo'].toString();
          dynamic gastoActual = double.parse(gastos);
          comprasAbril += gastoActual;
          gananciasAbr = ventasAbril-gastosAbril-comprasAbril;
          break;
          case "5":
          dynamic gastos = result.data()['Costo'].toString();
          dynamic gastoActual = double.parse(gastos);
          comprasMayo += gastoActual;
          gananciasMay = ventasMayo-gastosMayo-comprasMayo;
          break;
          case "6":
          dynamic gastos = result.data()['Costo'].toString();
          dynamic gastoActual = double.parse(gastos);
          comprasJunio += gastoActual;
          gananciasJun = ventasJunio-gastosJunio-comprasJunio;
          break;
          case "7":
          dynamic gastos = result.data()['Costo'].toString();
          dynamic gastoActual = double.parse(gastos);
          comprasJulio += gastoActual;
          gananciasJul = ventasJulio-gastosJulio-comprasJulio;
          break;
          case "8":
          dynamic gastos = result.data()['Costo'].toString();
          dynamic gastoActual = double.parse(gastos);
          comprasAgosto += gastoActual;
          gananciasAgo = ventasAgosto-gastosAgosto-comprasAgosto;
          break;
          case "9":
          dynamic gastos = result.data()['Costo'].toString();
          dynamic gastoActual = double.parse(gastos);
          comprasSep += gastoActual;
          gananciasSep = ventasSep-gastosSep-comprasSep;
          break;
          case "10":
          dynamic gastos = result.data()['Costo'].toString();
          dynamic gastoActual = double.parse(gastos);
          comprasOct += gastoActual;
          gananciasOct = ventasOct-gastosOct-comprasOct;
          break;
          case "11":
          dynamic gastos = result.data()['Costo'].toString();
          dynamic gastoActual = double.parse(gastos);
          comprasNov += gastoActual;
          gananciasNov = ventasNov-gastosNov-comprasNov;
          break;
          case "12":
          dynamic gastos = result.data()['Costo'].toString();
          dynamic gastoActual = double.parse(gastos);
          comprasDic += gastoActual;
          gananciasDic = ventasDic-gastosDic-comprasDic;
          break;
        }
        
        
          totalComprasAno = comprasEnero+comprasFebrero+comprasMarzo+comprasAbril+comprasMayo+comprasJunio+comprasJulio+comprasAgosto+comprasSep+comprasOct+comprasNov+comprasDic;
          gananciaAno=totalVentasAno-totalGastosAno-totalComprasAno;
               print("Total Ventas: " + totalVentasAno.toString());
         
      });
      
    });

   

                  //
                  
                   aux = arrVent[0];
                 for(int i=0;i==11;i++)
                 {
                   if(arrVent[i]>aux)
                   {
                     aux = arrVent[i];
                   }
                 }
                  
                
                 
               
                  
              
  }
  
  resetGraficas()
  {
    totalVentasAno=0;
    venAct=0; gasAct=0; comAct=0;
    totalVentas = 0;
          gananciaMesActual=0; gananciasFeb =0; gananciasMar =0; gananciasAbr =0; gananciasMay =0; gananciasJun =0; gananciasJul =0; gananciasAgo =0; gananciasSep =0; gananciasOct =0; gananciasNov =0; gananciasDic =0;
 gananciaAno=0;
         ventasEnero=0; ventasMarzo=0; ventasAbril=0; ventasMayo=0; ventasJunio=0; ventasJulio=0; ventasAgosto=0; ventasSep=0; ventasOct=0; ventasNov=0; ventasDic=0;
 gastosEnero=0; gastosFebrero=0; gastosMarzo=0; gastosAbril=0; gastosMayo=0; gastosJunio=0; gastosJulio=0; gastosAgosto=0; gastosSep=0; gastosOct=0; gastosNov=0; gastosDic=0;
 comprasEnero=0; comprasFebrero=0; comprasMarzo=0; comprasAbril=0; comprasMayo=0; comprasJunio=0; comprasJulio=0; comprasAgosto=0; comprasSep=0; comprasOct=0; comprasNov=0; comprasDic=0;
            totalVentasAno=0;  
            totalComprasAno=0;
            totalGastosAno=0;  
            gananciaAno=0;
  }
  _getCustomAppBar(){
  return PreferredSize(
    preferredSize: Size.fromHeight(50),
    child: Container(
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
      color: colorPrincipal,
      ),
      child: Row(
        
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
        IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.white, size: 18,), onPressed: (){
             
       Navigator.of(context).pop();

        }),
      Text('Grafica De Ganancias', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500,color: Colors.white),),
        IconButton(icon: Icon(Icons.trending_up,color: Colors.white), onPressed: (){
         
        })
      ],),
    ),
  );
}
 List<PieChartSectionData> showingSections(double ventas, double gastos, double compras) {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color:  colorVentas,
            value: ventas,
            title: 'Ven.',
            
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: colorPrincipal),
          );
        case 1:
          return PieChartSectionData(
            color: colorGastos,
            value: gastos,
            title: 'Gas.',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: colorPrincipal),
          );
        case 2:
          return PieChartSectionData(
            color: colorCompras,
            value: compras,
            title: 'Com.',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: colorPrincipal),
          );
        
        default:
          throw Error();
      }
    });
  }

}

