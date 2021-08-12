import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';

class DetallesProduccion extends StatefulWidget {
  final String categoria;
  DetallesProduccion({Key key, this.categoria}) : super(key: key);

  @override
  _DetallesProduccionState createState() => _DetallesProduccionState();
}

int dia = DateTime.now().day;
int mes = DateTime.now().month;
int year = DateTime.now().year;
dynamic totalAgua = 0;
dynamic totalLeche = 0;
dynamic totalTambos = 0;
dynamic totalTandas = 0;
dynamic totalmini = 0;
dynamic totalmaxi = 0;
dynamic totalhexa = 0;
dynamic totalcuad = 0;
dynamic totalminiL = 0;
dynamic totalhexaL = 0;
dynamic totalcuadL = 0;
dynamic total5L = 0;
dynamic total1L = 0;
dynamic total5Leche = 0;
dynamic total1Leche = 0;
dynamic totalSa = 0;
dynamic totalTro = 0;
NumberFormat f = new NumberFormat("#,##0.00", "es_US");

class _DetallesProduccionState extends State<DetallesProduccion> {
  @override
  void initState() {
    totalTro = 0;
    totalSa = 0;
    totalLeche = 0;
    totalTambos = 0;
    totalAgua = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: colorPrincipal,
          elevation: 5,
          title: Text("Vista ${widget.categoria}"),
          centerTitle: true,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height * 0.14,
                  child: Column(
                    children: [
                      Center(
                        child: IconButton(
                          icon: Icon(Icons.date_range),
                          onPressed: () {
                            showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    helpText: "Seleccione una fecha",
                                    cancelText: "Cancelar",
                                    confirmText: "Seleccionar",
                                    builder:
                                        (BuildContext context, Widget child) {
                                      return Theme(
                                        data: ThemeData.dark().copyWith(
                                          colorScheme: ColorScheme.dark(
                                            primary:
                                                Colors.white, //color botones
                                            onPrimary: Colors.black,
                                            surface: colorPrincipal,
                                            onSurface: Colors.white,
                                          ),
                                          dialogBackgroundColor: colorPrincipal,
                                          buttonColor: Colors.white,
                                        ),
                                        child: child,
                                      );
                                    },
                                    firstDate: DateTime(2001),
                                    lastDate: DateTime(2222))
                                .then((date) {
                              dia = int.parse(DateFormat('dd').format(date));
                              mes = int.parse(DateFormat('MM').format(date));
                              year = int.parse(DateFormat('yyyy').format(date));
                              print(dia);
                              print(mes);
                              print(year);
                              FirebaseFirestore.instance
                                  .collection('Produccion')
                                  .where("Materia", isEqualTo: "Agua")
                                  .where("Categoria",
                                      isEqualTo: widget.categoria)
                                  .where("Dia", isEqualTo: dia)
                                  .where("Mes", isEqualTo: mes)
                                  .where("Año", isEqualTo: year)
                                  .snapshots()
                                  .listen((result) {
                                totalAgua = 0;
                                totalmaxi = 0;
                                totalcuad = 0;
                                totalhexa = 0;
                                totalmini = 0;
                                total5L = 0;
                                total1L = 0;

                                result.docs.forEach((result) {
                                  setState(() {
                                    //Maxi
                                    result.data()['Maxi'] != null
                                        ? totalmaxi += result.data()['Maxi']
                                        : totalmaxi = 0;
                                    //Cuadraleta
                                    result.data()['Cuadraleta'] != null
                                        ? totalcuad +=
                                            result.data()['Cuadraleta']
                                        : totalcuad = 0;
                                    //Hexagonal
                                    result.data()['Hexagonal'] != null
                                        ? totalhexa +=
                                            result.data()['Hexagonal']
                                        : totalhexa = 0;
                                    //1L
                                    result.data()['1L'] != null
                                        ? total1L += result.data()['1L']
                                        : total1L = 0;
                                    //5L
                                    result.data()['5L'] != null
                                        ? total5L += result.data()['5L']
                                        : total5L = 0;
                                    //Mini
                                    result.data()['Mini'] != null
                                        ? totalmini += result.data()['Mini']
                                        : totalmini = 0;

                                    //Totales
                                    dynamic docTotal = widget.categoria ==
                                            "Paleta"
                                        ? result.data()['Hexagonal'] +
                                            result.data()['Cuadraleta'] +
                                            result.data()['Maxi']
                                        : widget.categoria == "Helado"
                                            ? result.data()['1L'] +
                                                result.data()['5L']
                                            : widget.categoria == "Sandwich" ||
                                                    widget.categoria == "Troles"
                                                ? result.data()['Piezas']
                                                : 0;
                                    totalAgua += docTotal;
                                  });
                                });
                              });
                              FirebaseFirestore.instance
                                  .collection('Produccion')
                                  .where("Materia", isEqualTo: "Leche")
                                  .where("Categoria",
                                      isEqualTo: widget.categoria)
                                  .where("Dia", isEqualTo: dia)
                                  .where("Mes", isEqualTo: mes)
                                  .where("Año", isEqualTo: year)
                                  .snapshots()
                                  .listen((result) {
                                totalLeche = 0;
                                totalcuadL = 0;
                                totalhexaL = 0;
                                totalminiL = 0;
                                total5Leche = 0;
                                total1Leche = 0;
                                totalTro = 0;
                                result.docs.forEach((result) {
                                  setState(() {
                                    //Troles
                                    result.data()['Piezas'] != null
                                        ? totalTro += result.data()['Piezas']
                                        : totalTro = 0;
                                    //Cuadraleta
                                    result.data()['Cuadraleta'] != null
                                        ? totalcuadL +=
                                            result.data()['Cuadraleta']
                                        : totalcuadL = 0;
                                    //Hexagonal
                                    result.data()['Hexagonal'] != null
                                        ? totalhexaL +=
                                            result.data()['Hexagonal']
                                        : totalhexaL = 0;
                                    //1L
                                    result.data()['1L'] != null
                                        ? total1Leche += result.data()['1L']
                                        : total1Leche = 0;
                                    //5L
                                    result.data()['5L'] != null
                                        ? total5Leche += result.data()['5L']
                                        : total5Leche = 0;
                                    //Mini
                                    result.data()['Mini'] != null
                                        ? totalminiL += result.data()['Mini']
                                        : totalminiL = 0;
                                    //Totales
                                    dynamic docTotal = widget.categoria ==
                                            "Paleta"
                                        ? result.data()['Hexagonal'] +
                                            result.data()['Cuadraleta']
                                        : widget.categoria == "Helado"
                                            ? result.data()['1L'] +
                                                result.data()['5L']
                                            : widget.categoria == "Sandwich" ||
                                                    widget.categoria == "Troles"
                                                ? result.data()['Piezas']
                                                : 0;
                                    totalLeche += docTotal;
                                  });
                                });
                              });
                              FirebaseFirestore.instance
                                  .collection('Produccion')
                                  .where("Categoria",
                                      isEqualTo: widget.categoria)
                                  .where("Dia", isEqualTo: dia)
                                  .where("Mes", isEqualTo: mes)
                                  .where("Año", isEqualTo: year)
                                  .snapshots()
                                  .listen((result) {
                                totalTambos = 0;

                                result.docs.forEach((result) {
                                  setState(() {
                                    widget.categoria == "Paleta" ||
                                            widget.categoria == "Sandwich" ||
                                            widget.categoria == "Troles"
                                        ? totalTambos += double.parse(
                                            result.data()['Tambo'].toString())
                                        : widget.categoria == "Helado"
                                            ? totalTambos += double.parse(result
                                                .data()['Tanda']
                                                .toString())
                                            : totalTambos = 0;
                                    //Sandwich
                                    result.data()['Piezas'] != null
                                        ? totalSa += result.data()['Piezas']
                                        : totalSa = 0;
                                  });
                                });
                              });
                              Future.delayed(const Duration(milliseconds: 1000),
                                  () {
                                setState(() {});
                              });
                            });
                          },
                        ),
                      ),
                      widget.categoria == "Paleta"
                          ? Container(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "\n\nAgua\nLeche",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Mini\n${f.format(totalmini)}\n${f.format(totalminiL)}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Maxi\n${f.format(totalmaxi)}\n0.00",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Hexa\n${f.format(totalhexa)}\n${f.format(totalhexaL)}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Cuad\n${f.format(totalcuad)}\n${f.format(totalcuadL)}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            )
                          : widget.categoria == "Helado"
                              ? Container(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "\n\nAgua\nLeche",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "1L\n${f.format(total1L)}\n${f.format(total1Leche)}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "5L\n${f.format(total5L)}\n${f.format(total5Leche)}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                )
                              : widget.categoria == "Sandwich" ||
                                      widget.categoria == "Troles"
                                  ? Container(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Piezas: ${f.format(totalSa)}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox()
                    ],
                  )),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.13,
                child: Divider(height: 12, color: Colors.black),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.15,
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(5),
                    child: ListView(
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Produccion')
                              .where("Categoria", isEqualTo: widget.categoria)
                              .where("Dia", isEqualTo: dia)
                              .where("Mes", isEqualTo: mes)
                              .where("Año", isEqualTo: year)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Text("Cargando");
                            }
                            return widget.categoria == "Paleta"
                                ? Column(
                                    children: snapshot.data.docs
                                        .map<Widget>(
                                            (doc) => _buildPaletas(doc))
                                        .toList())
                                : widget.categoria == "Helado"
                                    ? Column(
                                        children: snapshot.data.docs
                                            .map<Widget>(
                                                (doc) => _buildHelados(doc))
                                            .toList())
                                    : Column(
                                        children: snapshot.data.docs
                                            .map<Widget>(
                                                (doc) => _buildElse(doc))
                                            .toList());
                          },
                        ),
                      ],
                    )),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width,
                  child: totalAgua == 0 && totalLeche == 0 && totalTambos == 0
                      ? Center(
                          child: Text(
                            "Seleccione Una Fecha...",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.categoria == "Paleta" ||
                                      widget.categoria == "Sandwich" ||
                                      widget.categoria == "Troles"
                                  ? "Tambos\n${f.format(totalTambos)}"
                                  : widget.categoria == "Helado"
                                      ? "Tandas\n${f.format(totalTambos)}"
                                      : "",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Leche\n${f.format(totalLeche)}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Agua\n${f.format(totalAgua)}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                ),
              )
            ],
          ),
        ));
  }

  _buildPaletas(DocumentSnapshot doc) {
    Map<String, dynamic> sabores = doc.data()["Sabores"];
    return Container(
      margin: EdgeInsets.all(15),
      height: (MediaQuery.of(context).size.height * 0.11) +
          (MediaQuery.of(context).size.height * 0.05) * sabores.length,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(10.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text("Sabores:",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
          ),
          for (var i in sabores.keys)
            Container(
                height: MediaQuery.of(context).size.height * 0.05,
                child: Center(
                  child: doc.data()["Sabores"][i]["Materia"] == "Agua"
                      ? Text(
                          i +
                              "\n" +
                              doc.data()["Sabores"][i]["Materia"].toString() +
                              "   " +
                              doc.data()["Medida"] +
                              ":" +
                              doc
                                  .data()["Sabores"][i][doc.data()["Medida"]]
                                  .toString() +
                              "   Mini: " +
                              doc.data()["Sabores"][i]["Mini"].toString() +
                              "  Hexa: " +
                              doc.data()["Sabores"][i]["Hexagonal"].toString() +
                              "  Cuad: " +
                              doc
                                  .data()["Sabores"][i]["Cuadraleta"]
                                  .toString() +
                              "  Maxi: " +
                              doc.data()["Sabores"][i]["Maxi"].toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        )
                      : Text(
                          i +
                              "\n" +
                              doc.data()["Sabores"][i]["Materia"].toString() +
                              "   " +
                              doc.data()["Medida"] +
                              ":" +
                              doc
                                  .data()["Sabores"][i][doc.data()["Medida"]]
                                  .toString() +
                              "   Mini: " +
                              doc.data()["Sabores"][i]["Mini"].toString() +
                              "  Hexa: " +
                              doc.data()["Sabores"][i]["Hexagonal"].toString() +
                              "  Cuad: " +
                              doc.data()["Sabores"][i]["Cuadraleta"].toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                )),
          Divider(
            height: 12,
            color: Colors.black,
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            height: MediaQuery.of(context).size.height * 0.06,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tambos: " + doc.data()['Tambos'].toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: Column(
                      children: [
                        Text(
                          "Mini: " + f.format(doc.data()['Mini']).toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Hexa: " +
                              f.format(doc.data()['Hexagonal']).toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Turno: " + doc.data()['Turno'],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: Column(
                      children: [
                        Text(
                          "Cuad: " +
                              f.format(doc.data()['Cuadraleta']).toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                        doc.data()["Maxi"] != null
                            ? Text(
                                "Maxi: " +
                                    f.format(doc.data()['Maxi']).toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              )
                            : SizedBox(),
                      ],
                    )),
                Text(
                  doc.data()['Dia'].toString() +
                      "/" +
                      doc.data()['Mes'].toString() +
                      "/" +
                      doc.data()['Año'].toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildHelados(DocumentSnapshot doc) {
    Map<String, dynamic> sabores = doc.data()["Sabores"];
    return Container(
      margin: EdgeInsets.all(15),
      height: (MediaQuery.of(context).size.height * 0.11) +
          (MediaQuery.of(context).size.height * 0.05) * sabores.length,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(10.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text("Sabores:",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
          ),
          for (var i in sabores.keys)
            Container(
                height: MediaQuery.of(context).size.height * 0.05,
                child: Center(
                  child: doc.data()["Sabores"][i]["Materia"] == "Leche"
                      ? Text(
                          i +
                              "\n" +
                              doc.data()["Sabores"][i]["Materia"].toString() +
                              "   " +
                              doc.data()["Medida"] +
                              ":" +
                              doc
                                  .data()["Sabores"][i][doc.data()["Medida"]]
                                  .toString() +
                              "   5L: " +
                              doc
                                  .data()["Sabores"][i]["Helado 5L Leche"]
                                  .toString() +
                              "  1L: " +
                              doc
                                  .data()["Sabores"][i]["Helado 1L Leche"]
                                  .toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        )
                      : Text(
                          i +
                              "\n" +
                              doc.data()["Sabores"][i]["Materia"].toString() +
                              "   " +
                              doc.data()["Medida"] +
                              ":" +
                              doc
                                  .data()["Sabores"][i][doc.data()["Medida"]]
                                  .toString() +
                              "  5L: " +
                              doc
                                  .data()["Sabores"][i]["Helado 5L Agua"]
                                  .toString() +
                              "  1L: " +
                              doc
                                  .data()["Sabores"][i]["Helado 1L Agua"]
                                  .toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                )),
          Divider(
            height: 12,
            color: Colors.black,
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            height: MediaQuery.of(context).size.height * 0.06,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tandas: " + doc.data()['Tandas'].toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: Column(
                      children: [
                        Text(
                          "1L: " + f.format(doc.data()['1 Litro']).toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "5L: " + f.format(doc.data()['5 Litros']).toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Turno: " + doc.data()['Turno'],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                Text(
                  doc.data()['Dia'].toString() +
                      "/" +
                      doc.data()['Mes'].toString() +
                      "/" +
                      doc.data()['Año'].toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildElse(DocumentSnapshot doc) {
    Map<String, dynamic> sabores = doc.data()["Sabores"];
    return Container(
      margin: EdgeInsets.all(15),
      height: (MediaQuery.of(context).size.height * 0.11) +
          (MediaQuery.of(context).size.height * 0.05) * sabores.length,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(10.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text("Sabores:",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
          ),
          for (var i in sabores.keys)
            Container(
                height: MediaQuery.of(context).size.height * 0.05,
                child: Center(
                    child: Text(
                  i +
                      "\n" +
                      doc.data()["Sabores"][i]["Materia"].toString() +
                      "   " +
                      doc.data()["Medida"] +
                      ": " +
                      doc
                          .data()["Sabores"][i][doc.data()["Medida"]]
                          .toString() +
                      "   Piezas: " +
                      doc.data()["Sabores"][i]["Piezas"].toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ))),
          Divider(
            height: 12,
            color: Colors.black,
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            height: MediaQuery.of(context).size.height * 0.06,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tambos: " + doc.data()['Tambos'].toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: Column(
                      children: [
                        Text(
                          "Piezas: " +
                              f.format(doc.data()['Piezas']).toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Turno: " + doc.data()['Turno'],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                Text(
                  doc.data()['Dia'].toString() +
                      "/" +
                      doc.data()['Mes'].toString() +
                      "/" +
                      doc.data()['Año'].toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
