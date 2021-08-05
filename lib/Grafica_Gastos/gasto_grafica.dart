
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';


import 'venta_widget.dart';

// ignore: camel_case_types
class GraficaGastos extends StatefulWidget {
 
  

  @override
  _GraficaGastosState createState() => _GraficaGastosState();
}

// ignore: camel_case_types
class _GraficaGastosState extends State<GraficaGastos> {

   PageController _controller;
  int currentPage = DateTime.now().month - 1;
  int currentPage2 = DateTime.now().day;
  Stream<QuerySnapshot> _query;
  GraphType currentType = GraphType.LINES;
  

  @override
  void initState() {
    super.initState();

    // ignore: deprecated_member_use
    _query = FirebaseFirestore.instance

        .collection('Gastos')
        .where("Mes", isEqualTo: currentPage + 1)
        .snapshots();

    _controller = PageController(
      initialPage: currentPage,
      viewportFraction: 0.4,
    );
  }

  Widget _bottomAction(IconData icon, Function callback) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon, color: Colors.white,),
      ),
      onTap: callback,
    );
  }

  Widget _bottomAction1(IconData icon, Function callback) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon, color: Colors.blue,),
      ),
      onTap: callback,
    );
  }

  @override
  Widget build(BuildContext context) {
    print(currentPage2);
    return Scaffold(
    appBar: _getCustomAppBar(),
backgroundColor: Colors.white,



     
      bottomNavigationBar: BottomAppBar(
          notchMargin: 8.0,
          color: Colors.black,
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _bottomAction(FontAwesomeIcons.chartLine, () {
                setState(() {
                  
                  currentType = GraphType.LINES;
                });
              }),
              SizedBox(width: 48.0),
             _bottomAction1(FontAwesomeIcons.chartPie, () {
                setState(() {
                  currentType = GraphType.PIE;
                });
              }),
            ],
          ),
        ),
      
      body: _body(),

      
    );
  }

  Widget _body() {
    return SafeArea(
      
      child: Column(
        
     
        children: <Widget>[
       
           Form(
          
            
                      child: new Container(
              child: new Row(

                children: <Widget>[

               

            



                ],
              ),

              
            ),
                   
          ),
          _selector(),
          StreamBuilder<QuerySnapshot>(
            stream: _query,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
              if (data.hasData) {

                

                // ignore: dead_code
                return GastoWidget(

                  
                  
                  // ignore: deprecated_member_use
                  documents: data.data.docs,
                  graphType: currentType,
                  month: currentPage,
                );

              }

              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _pageItem(String name, int position) {
    var _alignment;
    final selected = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
    final unselected = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.normal,
      color: Colors.black.withOpacity(0.4),
    );

    if (position == currentPage) {
      _alignment = Alignment.center;
    } else if (position > currentPage) {
      _alignment = Alignment.centerRight;
    } else {
      _alignment = Alignment.centerLeft;
    }

    return Align(
      alignment: _alignment,
      child: Text(name,
        style: position == currentPage ? selected : unselected,
      ),
    );
  }

  Widget _selector() {
    return SizedBox.fromSize(
      size: Size.fromHeight(70.0),
      child: PageView(
        onPageChanged: (newPage) {
          setState(() {
            currentPage = newPage;
            // ignore: deprecated_member_use
            _query = FirebaseFirestore.instance
                .collection('Gastos')
                .where("Mes", isEqualTo: currentPage + 1)
                .snapshots();
          });
        },
        controller: _controller,
        children: <Widget>[
          _pageItem("Enero", 0),
          _pageItem("Febrero", 1),
          _pageItem("Marzo", 2),
          _pageItem("Abril", 3),
          _pageItem("Mayo", 4),
          _pageItem("Junio", 5),
          _pageItem("Julio", 6),
          _pageItem("Agosto", 7),
          _pageItem("Septiembre", 8),
          _pageItem("Octubre", 9),
          _pageItem("Noviembre", 10),
          _pageItem("Diciembre", 11),
        ],
      ),
    );
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
        Text('Grafica De Gastos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500,color: Colors.white),),
        IconButton(icon: Icon(Icons.trending_up,color: Colors.white), onPressed: (){
         
        }),
      ],),
    ),
  );
}
}