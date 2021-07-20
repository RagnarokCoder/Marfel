import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';
import 'package:paleteria_marfel/Ventas/NuevaVenta.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yudiz_modal_sheet/yudiz_modal_sheet.dart';

class VistaVentas extends StatefulWidget {
  @override
  _VistaVentasState createState() => _VistaVentasState();
}

bool icono = false;
List inventario = [];
List productos = [];
List filteredInventario = [];
List filteredProductos = [];
int _currentValue = 0;
int cantidadlimite = 10;
String molde = "Selecciona...";
String sabor = "Selecciona...";
String preciosabor = "";
dynamic total = 0;
dynamic totalfinal = 0;
int cantidad;
int nuevaCantidadInventario = 0;
List<Map<String, dynamic>> carrito = [];

getProductos() async {
  var url = 'https://api-paleteria-marfel.herokuapp.com/api/v1/product';
  final response = await http.get(url, headers: {
    'content-type': 'application/json',
    'Accept': 'application/json',
  });

  return json.decode(response.body)['data']['productos'];
}

class _VistaVentasState extends State<VistaVentas> {
  getInventario() async {
    var url = 'https://api-paleteria-marfel.herokuapp.com/api/v1/molde';
    final response = await http.get(url, headers: {
      'content-type': 'application/json',
      'Accept': 'application/json',
    });

    print(json.decode(response.body)['data']['moldes']);

    return json.decode(response.body)['data']['moldes'];
  }

  @override
  void initState() {
    getInventario().then((body) {
      inventario = filteredInventario = body;

      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrincipal,
        elevation: 0,
        title: Text("Ventas"),
        centerTitle: true,
        actions: [
          Stack(
            children: <Widget>[
              new IconButton(
                  icon: new Icon(
                    Icons.shopping_cart,
                    size: 40,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    print(carrito);
                    totalfinal = 0;

                    for (int i = 0; i < carrito.length; i++) {
                      totalfinal += carrito[i]["Total"];
                    }
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState1) {
                          return Container(
                              height: MediaQuery.of(context)
                                      .copyWith()
                                      .size
                                      .height *
                                  (5 / 6),
                              child: Column(
                                children: [
                                  Container(
                                    height:
                                        MediaQuery.of(context).size.height * .7,
                                    color: Colors.white,
                                    child: ListView(
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.7,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.all(5),
                                          child: carrito.length > 0
                                              ? ListView.builder(
                                                  itemCount: carrito.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Padding(
                                                        padding:
                                                            EdgeInsets.all(7.0),
                                                        child: Dismissible(
                                                            background:
                                                                Container(
                                                              color: Colors.red,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(15),
                                                                child: Row(
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .delete,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    Text(
                                                                        "Borrar Item",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white))
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            secondaryBackground:
                                                                Container(
                                                              color: Colors.red,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(15),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Icon(
                                                                        Icons
                                                                            .delete,
                                                                        color: Colors
                                                                            .white),
                                                                    Text(
                                                                        'Borrar Item',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white)),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            key: ValueKey<
                                                                    dynamic>(
                                                                carrito[index]),
                                                            onDismissed:
                                                                (DismissDirection
                                                                    direction) {
                                                              setState1(() {
                                                                totalfinal =
                                                                    totalfinal -
                                                                        carrito[index]
                                                                            [
                                                                            "Total"];
                                                                carrito.remove(
                                                                    carrito[
                                                                        index]);

                                                                setState(() {});
                                                              });
                                                            },
                                                            child: ListTile(
                                                              leading: new Icon(
                                                                  Icons
                                                                      .icecream),
                                                              title: new Text(
                                                                  carrito[index]
                                                                      [
                                                                      'Sabor']),
                                                              subtitle: Text(carrito[
                                                                          index]
                                                                      [
                                                                      "Molde"] +
                                                                  "" +
                                                                  "X" +
                                                                  carrito[index]
                                                                          [
                                                                          "Cantitad"]
                                                                      .toString()),
                                                              trailing: Text("\$" +
                                                                  carrito[index]
                                                                          [
                                                                          "Total"]
                                                                      .toString()),
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            )));
                                                  })
                                              : Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                      child: Row(
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            return showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text("Confirm"),
                                                  content: Text(
                                                      "¿Estás seguro de borrar el carrito?"),
                                                  actions: <Widget>[
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(true);
                                                          carrito.clear();
                                                          setState(() {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          VistaVentas()),
                                                            );
                                                          });
                                                        },
                                                        child: Text("Aceptar")),
                                                    OutlinedButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(false),
                                                      child: Text("Cancelar"),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    right: BorderSide(
                                                        width: 1.0))),
                                            width: 60,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .09,
                                            child: Center(
                                                child: Icon(
                                              Icons.delete_forever_rounded,
                                              size: 40,
                                              color: Colors.red,
                                            )),
                                          )),
                                      Container(
                                        color: Colors.white,
                                        width: 150,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .09,
                                        child: Column(
                                          children: [
                                            Container(
                                                padding:
                                                    EdgeInsets.only(right: 60),
                                                child: Text(
                                                  "Total:",
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                            Container(
                                                padding:
                                                    EdgeInsets.only(right: 40),
                                                child: Text(
                                                  totalfinal.toString(),
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                )),
                                          ],
                                        ),
                                      ),
                                      Container(
                                          color: Colors.white,
                                          width: 140,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .09,
                                          child: RaisedButton.icon(
                                            color: colorPrincipal,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                side: BorderSide(
                                                    color: Colors.transparent)),
                                            onPressed: () {
                                              return showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text("Confirmar"),
                                                    content: Text(
                                                        "¿Es correcta la compra?"),
                                                    actions: <Widget>[
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            for (int i = 0;
                                                                i <
                                                                    carrito
                                                                        .length;
                                                                i++) {
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "Inventario")
                                                                  .doc(carrito[
                                                                          i]
                                                                      ["Sabor"])
                                                                  .update({
                                                                "Cantidad":
                                                                    carrito[i][
                                                                        "NuevaCantidadInventario"]
                                                              });
                                                            }

                                                            Navigator.of(
                                                                    context)
                                                                .pop(true);
                                                            carrito.clear();
                                                            setState(() {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            VistaVentas()),
                                                              );
                                                            });
                                                          },
                                                          child:
                                                              Text("Aceptar")),
                                                      OutlinedButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(false),
                                                        child: Text("Cancelar"),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            label: Text(
                                              "Comprar",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 23),
                                            ),
                                            icon: Icon(
                                              Icons.add,
                                              size: 0,
                                              color: Colors.transparent,
                                            ),
                                          )),
                                    ],
                                  ))
                                ],
                              ));
                        });
                      },
                    );
                  }),
              carrito.length == 0
                  ? new Container()
                  : new Positioned(
                      child: new Stack(
                      children: <Widget>[
                        new Icon(Icons.brightness_1,
                            size: 25.0, color: Colors.grey[800]),
                        new Positioned(
                            top: 3.0,
                            right: 8.0,
                            child: new Center(
                              child: new Text(
                                carrito.length.toString(),
                                style: new TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            )),
                      ],
                    )),
            ],
          ),
        ],
      ),
      floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: FloatingActionButton(
            onPressed: () {
              nuevaCantidadInventario = cantidad - _currentValue;
              carrito.add({
                'Molde': molde,
                'Sabor': sabor,
                'Cantitad': _currentValue,
                'Total': total,
                'NuevaCantidadInventario': nuevaCantidadInventario
              });

              cantidadlimite = 100;
              molde = "Selecciona...";
              sabor = "Selecciona...";

              setState(() {});
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 29,
            ),
            backgroundColor: colorPrincipal,
            tooltip: 'Agregar',
            elevation: 9,
            splashColor: Colors.grey,
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      drawer: CustomAppbar(),
      body: ListView(
        children: [
          Container(
              padding: EdgeInsets.only(right: 20),
              child: Align(
                  alignment: Alignment.centerRight,
                  // ignore: deprecated_member_use
                  child: RaisedButton.icon(
                    color: colorPrincipal,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.transparent)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NuevaVenta()),
                      );
                    },
                    label: Text(
                      "Siguiente",
                      style: TextStyle(color: Colors.white, fontSize: 23),
                    ),
                    icon: Icon(
                      Icons.add,
                      size: 0,
                      color: Colors.transparent,
                    ),
                  ))),
          SizedBox(
            height: 10.0,
          ),
          Container(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                "Molde",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
              )),
          Container(
              margin: EdgeInsets.only(left: 20, right: 30, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      decoration: BoxDecoration(
                        color: colorPrincipal,
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
                      child: RaisedButton.icon(
                        color: colorPrincipal,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.transparent)),
                        onPressed: () {
                          buildAlert2(context);
                        },
                        label: Text(
                          "Seleccionar",
                          style: TextStyle(color: Colors.white, fontSize: 23),
                        ),
                        icon: Icon(
                          Icons.add,
                          size: 0,
                          color: Colors.transparent,
                        ),
                      )),
                  Text(
                    molde,
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey[600]),
                  )
                ],
              )),
          Container(
              padding: EdgeInsets.only(left: 30, top: 30),
              child: Text(
                "Sabor",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
              )),
          Container(
              margin: EdgeInsets.only(left: 20, right: 30, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      decoration: BoxDecoration(
                        color: colorPrincipal,
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
                      child: RaisedButton.icon(
                        color: colorPrincipal,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.transparent)),
                        onPressed: () {
                          buildAlert1(context);
                        },
                        label: Text(
                          "Seleccionar",
                          style: TextStyle(color: Colors.white, fontSize: 23),
                        ),
                        icon: Icon(
                          Icons.add,
                          size: 0,
                          color: Colors.transparent,
                        ),
                      )),
                  Text(
                    sabor,
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey[600]),
                  )
                ],
              )),
          Container(
              padding: EdgeInsets.only(left: 30, top: 30),
              child: Text(
                "Cantidad",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
              )),
          SizedBox(
            height: 10.0,
          ),
          Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
              ),
              child: Column(
                children: <Widget>[
                  NumberPicker.integer(
                    selectedTextStyle:
                        TextStyle(color: Colors.black, fontSize: 35),
                    initialValue: _currentValue,
                    minValue: 0,
                    maxValue: cantidadlimite,
                    onChanged: (value) => setState(() {
                      _currentValue = value;

                      total = int.parse(preciosabor) * value;
                    }),
                  ),
                ],
              )),
          Container(
              margin: EdgeInsets.only(left: 30, right: 50, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total:",
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
                  ),
                  Container(
                      width: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: colorPrincipal),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                      child: Text(
                        total.toString(),
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.w700),
                      )),
                ],
              )),
        ],
      ),
    );
  }
}

buildAlert2(BuildContext context) async {
  YudizModalSheet.show(
      context: context,
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50))),
          height: MediaQuery.of(context).size.height - 150,
          child: Center(
              child: ListView(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(15),
                  child: Text(
                    "Moldes",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Container(
                height: 1000,
                width: 1000,
                child: GridView.builder(
                  itemCount: filteredInventario.length,
                  padding: const EdgeInsets.all(20),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    return Cardproduct(
                      nombre: filteredInventario[index]['nombre'],
                      foto:
                          "https://cdn2.cocinadelirante.com/sites/default/files/styles/gallerie/public/images/2019/06/como-hacer-bolisde-distintos-sabores.jpg",
                      id: filteredInventario[index]['nombre'],
                      tipo: "Molde",
                      precio: filteredInventario[index]['menudeo'].toString(),
                    );
                  },
                ))
          ])),
        );
      }),
      direction: YudizModalSheetDirection.BOTTOM);
}

buildAlert1(BuildContext context) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter mystate) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50))),
            height: MediaQuery.of(context).size.height - 150,
            child: Center(
                child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.all(15),
                      child: Text(
                        "Sabores",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 15, right: 12),
                        child: SearchWidget())
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Listainventario()
              ],
            )),
          );
        });
      });
}

class Listainventario extends StatefulWidget {
  const Listainventario({
    Key key,
  }) : super(key: key);

  @override
  _ListainventarioState createState() => _ListainventarioState();
}

class _ListainventarioState extends State<Listainventario> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 1000,
        width: 1000,
        child: GridView.builder(
          itemCount: filteredProductos.length,
          padding: const EdgeInsets.all(20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return Cardproduct(
              nombre: filteredProductos[index]['NombreProducto'],
              foto:
                  "https://cdn2.cocinadelirante.com/sites/default/files/styles/gallerie/public/images/2019/06/como-hacer-bolisde-distintos-sabores.jpg",
              id: filteredProductos[index]['NombreProducto'],
              tipo: "Sabor",
              cantidad: filteredProductos[index]['Cantidad'],
            );
          },
        ));
  }
}

class SearchWidget extends StatefulWidget {
  const SearchWidget({
    Key key,
  }) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController animController;
  bool isForward = false;

  @override
  void initState() {
    super.initState();
    animController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);

    final curvedAnimatio =
        CurvedAnimation(parent: animController, curve: Curves.easeOutExpo);

    animation = Tween<double>(begin: 0, end: 150).animate(curvedAnimatio)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: animation.value,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                )),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 5),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    filteredProductos = productos
                        .where((country) => country['Molde']
                            .toString()
                            .toLowerCase()
                            .contains(molde))
                        .where((country) => country['NombreProducto']
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                        .toList();

                    print(filteredProductos);
                  });
                },
                cursorColor: Colors.white12,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: animation.value > 1
                    ? BorderRadius.only(
                        topLeft: Radius.circular(0),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(50),
                        topRight: Radius.circular(50))
                    : BorderRadius.circular(50)),
            child: IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                if (!isForward) {
                  animController.forward();
                  isForward = true;
                } else {
                  animController.reverse();
                  isForward = false;
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

class Cardproduct extends StatefulWidget {
  final String id, foto, nombre, tipo, precio;
  final int cantidad;
  const Cardproduct({
    Key key,
    this.id,
    this.cantidad,
    this.precio,
    this.foto,
    this.tipo,
    this.nombre,
  }) : super(key: key);

  @override
  _CardproductState createState() => _CardproductState();
}

class _CardproductState extends State<Cardproduct> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: InkWell(
      onTap: () {
        if (widget.tipo == "Molde") {
          molde = widget.id;
          preciosabor = widget.precio;

          getProductos().then((body) {
            productos = filteredProductos = body;
            filteredProductos = productos
                .where((country) => country['Molde'].toString().contains(molde))
                .toList();
          });

          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VistaVentas()),
          );
        } else {
          cantidad = 0;
          nuevaCantidadInventario = 0;
          sabor = widget.id;

          cantidad = widget.cantidad;
          cantidadlimite = widget.cantidad;
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VistaVentas()),
          );
        }
        setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(widget.foto),
            fit: BoxFit.cover,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
                child: Text(
              widget.nombre,
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 30,
                  color: Colors.white),
            )),
          ],
        ),
      ),
    ));
  }
}
