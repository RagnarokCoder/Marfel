import 'package:flutter/material.dart';
import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';

class NuevaVenta extends StatefulWidget {
  @override
  _NuevaVentaState createState() => _NuevaVentaState();
}

String _chosenValue;
int selectedRadio;

class _NuevaVentaState extends State<NuevaVenta> {
  @override
  // ignore: must_call_super
  void initState() {
    // ignore: todo
    selectedRadio = 0;
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: colorPrincipal,
              size: 30,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.white,
          elevation: 5,
          title: Text(
            "TIPO DE VENTA",
            style: TextStyle(color: colorPrincipal, fontSize: 30),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: 10,
            ),
            Align(
                alignment: const Alignment(-.8, 0),
                child: Text(
                  "Cliente:",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                )),
            SizedBox(
              height: 15,
            ),
            Container(
                width: 330,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  focusColor: Colors.white,

                  value: _chosenValue,
                  //elevation: 5,
                  style: TextStyle(color: Colors.white),
                  iconEnabledColor: Colors.black,
                  items: <String>[
                    'Android',
                    'IOS',
                    'Flutter',
                    'Node',
                    'Java',
                    'Python',
                    'PHP',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  hint: Text(
                    "Selecciona un cliente...",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _chosenValue = value;
                    });
                  },
                )),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Spacer(),
                Radio(
                  value: 1,
                  groupValue: selectedRadio,
                  activeColor: colorPrincipal,
                  onChanged: (val) {
                    print("Radio $val");
                    setSelectedRadio(val);
                  },
                ),
                Text(
                  "Cortesia",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
                Spacer(),
                Radio(
                  value: 2,
                  groupValue: selectedRadio,
                  activeColor: colorPrincipal,
                  onChanged: (val) {
                    print("Radio $val");
                    setSelectedRadio(val);
                  },
                ),
                Text("Credito",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                Spacer(),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Spacer(),
                Text("Desplazar a:",
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
                Spacer(),
                Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: TextField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "3"),
                    )),
                Spacer(),
                Spacer(),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Radio(
                  value: 1,
                  groupValue: selectedRadio,
                  activeColor: colorPrincipal,
                  onChanged: (val) {
                    print("Radio $val");
                    setSelectedRadio(val);
                  },
                ),
                Text(
                  "Años",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                ),
                Radio(
                  value: 1,
                  groupValue: selectedRadio,
                  activeColor: colorPrincipal,
                  onChanged: (val) {
                    print("Radio $val");
                    setSelectedRadio(val);
                  },
                ),
                Text(
                  "Meses",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                ),
                Radio(
                  value: 1,
                  groupValue: selectedRadio,
                  activeColor: colorPrincipal,
                  onChanged: (val) {
                    print("Radio $val");
                    setSelectedRadio(val);
                  },
                ),
                Text(
                  "Semanas",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                ),
                Radio(
                  value: 2,
                  groupValue: selectedRadio,
                  activeColor: colorPrincipal,
                  onChanged: (val) {
                    print("Radio $val");
                    setSelectedRadio(val);
                  },
                ),
                Text("Días",
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Spacer(),
                Text("Interes:     ",
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
                Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: TextField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "%"),
                    )),
                Spacer(),
                Spacer(),
                Spacer(),
              ],
            ),
            Container(
                padding: EdgeInsets.only(top: 30),
                height: 200,
                width: 300,
                child: Text("(Nombre del cliente) cuenta con 20% de descuento",
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w700))),
            Row(
              children: [
                Spacer(),
                Text("TOTAL: ",
                    style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87)),
                Text("300.00",
                    style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.w800,
                        color: colorPrincipal)),
                Spacer(),
                Spacer(),
                Spacer(),
                Spacer(),
                Spacer(),
                Spacer(),
                Spacer(),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                padding: EdgeInsets.only(right: 170),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Desplazado a 3 meses ",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Colors.grey[600])),
                    Text("2% de interes",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Colors.grey[600])),
                  ],
                ))
          ]),
        ));
  }
}
