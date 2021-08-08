import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:paleteria_marfel/Login/Login.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:yudiz_modal_sheet/yudiz_modal_sheet.dart';
import 'package:expansion_card/expansion_card.dart';

class NuevaOrden extends StatefulWidget {
  NuevaOrden({Key key}) : super(key: key);

  @override
  _NuevaOrdenState createState() => _NuevaOrdenState();
}

var selectedCurrency1;
var selectedCurrency;
int _pzController = 0;
int _moldeController = 0;
int _miniController = 0;
int _maxiController = 0;
int _cuadController = 0;
int _hexaController = 0;
int _fiveLController = 0;
int _oneLController = 0;

int diaSel, mesSel, yearSel;
int selector = 0;
dynamic cantidadAct = 0;
dynamic aux = 0;
int moldeCat = 0;
double _currentSliderValue = 0;
int drop1, drop2, drop3;
bool icono = false;
String categoria;
String materia;
bool prodPart = false;
Map<String, dynamic> productos = {};
String numeroTambos;
Map<String, dynamic> mapProductos = {};

class _NuevaOrdenState extends State<NuevaOrden> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: colorPrincipal,
          elevation: 5,
          title: Text("Nueva Orden"),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: prodPart == false
                    ? Column(
                        mainAxisAlignment: selectedCurrency1 == null
                            ? MainAxisAlignment.spaceAround
                            : MainAxisAlignment.start,
                        children: [
                          selectedCurrency1 == null
                              ? Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: _pickTurn())
                              : SizedBox(),
                          Container(
                            height: selectedCurrency1 == null
                                ? MediaQuery.of(context).size.height * 0.45
                                : MediaQuery.of(context).size.height * 0.25,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    _pickCategory(),
                                  ],
                                ),
                                categoria == null ? SizedBox() : _pickFlavor(),
                              ],
                            ),
                          ),
                          selectedCurrency1 == null
                              ? SizedBox()
                              : Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.53,
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  child: ListView(
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Productos",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            FlatButton.icon(
                                                onPressed: () {
                                                  setState(() {
                                                    productos.clear();
                                                  });
                                                },
                                                icon: Icon(Icons.delete,
                                                    color: Colors.red.shade700),
                                                label: Text(
                                                  "Borrar",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ))
                                          ],
                                        ),
                                      ),
                                      for (var i in productos.keys)
                                        _moldesCard(context, i),
                                    ],
                                  ),
                                ),
                        ],
                      )
                    : Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * .7,
                            child: ListView(
                              children: [
                                for (var i in productos.keys)
                                  _moldesCard(context, i),
                              ],
                            ),
                          ),
                          FlatButton.icon(
                            icon: Icon(Icons.check),
                            label: Text(
                              "Generar Orden",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              subirProduccion();
                            },
                          )
                        ],
                      )),
            Positioned(
              bottom: 15,
              left: 15,
              child: FloatingActionButton.extended(
                heroTag: "btnReset",
                onPressed: () {
                  buildConfirmReset(context);
                },
                label: const Text('Reiniciar'),
                icon: const Icon(Icons.restore),
                backgroundColor: colorPrincipal,
              ),
            )
          ],
        ),
        floatingActionButton: prodPart == false
            ? FloatingActionButton.extended(
                onPressed: () {
                  setState(() {
                    prodPart = true;
                  });
                },
                label: const Text('Siguiente'),
                icon: const Icon(Icons.navigate_next_sharp),
                backgroundColor: colorPrincipal,
              )
            : FloatingActionButton.extended(
                onPressed: () {
                  setState(() {
                    prodPart = false;
                  });
                },
                label: const Text('Regresar'),
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  size: 15,
                ),
                backgroundColor: colorPrincipal,
              ));
  }

  _moldesCard(BuildContext context, String key) {
    String nombre = key;
    String tipo = mapProductos[nombre];
    return Container(
        width: MediaQuery.of(context).size.width * .8,
        height: MediaQuery.of(context).size.height * .13,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: colorPrincipal,
        ),
        child: categoria == 'Paleta'
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _cardInfo(
                    'Tambos',
                    nombre,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .2,
                    child: Text(
                      nombre,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  _cardInfo(
                    'Mini',
                    nombre,
                  ),
                  _cardInfo(
                    'Cuadraleta',
                    nombre,
                  ),
                  _cardInfo(
                    'Hexagonal',
                    nombre,
                  ),
                  tipo == 'Agua'
                      ? _cardInfo(
                          'Maxi',
                          nombre,
                        )
                      : Container()
                ],
              )
            : categoria == 'Helado'
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _cardInfo(
                        'Tandas',
                        nombre,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .2,
                        child: Text(
                          nombre,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      tipo == 'Agua'
                          ? _cardInfo(
                              'Helado 5L Agua',
                              nombre,
                            )
                          : _cardInfo(
                              'Helado 5L Leche',
                              nombre,
                            ),
                      tipo == 'Agua'
                          ? _cardInfo(
                              'Helado 1L Agua',
                              nombre,
                            )
                          : _cardInfo(
                              'Helado 1L Leche',
                              nombre,
                            )
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _cardInfo(
                        'Tambos',
                        nombre,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .2,
                        child: Text(
                          nombre,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .25,
                      ),
                      _cardInfo(
                        'Piezas',
                        nombre,
                      )
                    ],
                  ));
  }

  subirProduccion() {
    _calcularTotales();
    String medida = '';
    if (categoria == 'Helado') {
      medida = 'Tandas';
    } else {
      medida = 'Tambos';
    }
    String turno = "";
    if (_currentSliderValue == 0) {
      turno = "Dia";
    } else {
      turno = "Noche";
    }
    categoria == 'Paleta'
        ? FirebaseFirestore.instance.collection("Produccion").add({
            "Sabores": productos,
            "Dia": DateTime.now().day,
            "Mes": DateTime.now().month,
            "Año": DateTime.now().year,
            "Categoria": categoria,
            "Tambos": _moldeController,
            "Turno": turno,
            "Medida": medida,
            "Cuadraleta": _cuadController,
            "Hexagonal": _hexaController,
            "Mini": _miniController,
            "Hexa": _hexaController
          }).then((value) => {
              setState(() {
                prodPart = true;
                _maxiController = 0;
                _hexaController = 0;
                _cuadController = 0;
                _fiveLController = 0;
                _oneLController = 0;
                productos.clear();
                selectedCurrency1 = null;
                prodPart = false;
                icono = null;
                materia = null;
                categoria = null;
                drop2 = null;
                drop1 = null;
              })
            })
        : categoria == 'Helado'
            ? FirebaseFirestore.instance.collection("Produccion").add({
                "Sabores": productos,
                "Dia": DateTime.now().day,
                "Mes": DateTime.now().month,
                "Año": DateTime.now().year,
                "Tandas": _moldeController,
                "5 Litros": _fiveLController,
                "1 Litro": _oneLController,
                "Categoria": categoria,
                "Turno": turno,
                "Medida": medida,
              }).then((value) => {
                  setState(() {
                    prodPart = true;
                    _maxiController = 0;
                    _hexaController = 0;
                    _cuadController = 0;
                    _fiveLController = 0;
                    _oneLController = 0;
                    productos.clear();
                    selectedCurrency1 = null;
                    prodPart = false;
                    icono = null;
                    materia = null;
                    categoria = null;
                    drop2 = null;
                    drop1 = null;
                  })
                })
            : FirebaseFirestore.instance.collection("Produccion").add({
                "Sabores": productos,
                "Dia": DateTime.now().day,
                "Mes": DateTime.now().month,
                "Año": DateTime.now().year,
                "Tambos": _moldeController,
                "Categoria": categoria,
                "Turno": turno,
                "Medida": medida,
                "Piezas": _pzController
              }).then((value) => {
                  setState(() {
                    prodPart = true;
                    _maxiController = 0;
                    _hexaController = 0;
                    _cuadController = 0;
                    _fiveLController = 0;
                    _oneLController = 0;
                    productos.clear();
                    selectedCurrency1 = null;
                    prodPart = false;
                    icono = null;
                    materia = null;
                    categoria = null;
                    drop2 = null;
                    drop1 = null;
                  })
                });
  }

  ButtonState stateTextWithIcon = ButtonState.idle;

  buildAlert(BuildContext context) {
    YudizModalSheet.show(
        context: context,
        child: Container(
          decoration: BoxDecoration(
              color: colorPrincipal,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50))),
          height: MediaQuery.of(context).size.height * 0.15,
          child: Center(
              child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Text(
                "Orden De Producción Creada",
                style: (TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton.icon(
                      color: Colors.transparent,
                      elevation: 0,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.check_circle,
                        color: Color(0xff00cf8d),
                      ),
                      label: Text(
                        "Confirmar",
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              )
            ],
          )),
        ),
        direction: YudizModalSheetDirection.TOP);
  }

  buildConfirmReset(BuildContext context) {
    YudizModalSheet.show(
        context: context,
        child: Container(
          decoration: BoxDecoration(
              color: colorPrincipal,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50))),
          height: MediaQuery.of(context).size.height * 0.15,
          child: Center(
              child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Text(
                "¿Desea Reiniciar La Orden De Producción",
                style: (TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton.icon(
                      color: Colors.transparent,
                      elevation: 0,
                      onPressed: () {
                        setState(() {
                          prodPart = true;
                          _maxiController = 0;
                          _hexaController = 0;
                          _cuadController = 0;
                          _fiveLController = 0;
                          _oneLController = 0;
                          productos.clear();
                          selectedCurrency1 = null;
                          prodPart = false;
                          icono = null;
                          materia = null;
                          categoria = null;
                          drop2 = null;
                          drop1 = null;
                        });
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.check,
                        color: Color(0xff00cf8d),
                      ),
                      label: Text(
                        "Confirmar",
                        style: TextStyle(color: Colors.white),
                      )),
                  RaisedButton.icon(
                      color: Colors.transparent,
                      elevation: 0,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.red.shade700,
                      ),
                      label: Text(
                        "Cancelar",
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              )
            ],
          )),
        ),
        direction: YudizModalSheetDirection.BOTTOM);
  }

  _pickTurn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Center(
          child: Text(
            "Turno",
            style: TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.1,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.25,
                child: _currentSliderValue == 0
                    ? Image.asset("assets/sun.png")
                    : Image.asset("assets/moon.png"),
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.height * 0.5,
          child: Slider(
            value: _currentSliderValue,
            min: 0,
            max: 1,
            divisions: 1,
            label: _currentSliderValue == 0 ? "Dia" : "Noche",
            activeColor: colorPrincipal,
            onChanged: (double value) {
              setState(() {
                _currentSliderValue = value;
              });
            },
          ),
        )
      ],
    );
  }

  _pickCategory() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      width: MediaQuery.of(context).size.width * 0.35,
      child: CustomDropdown(
        enabledColor: colorPrincipal,
        disabledIconColor: Colors.white,
        enabledIconColor: Colors.white,
        enableTextColor: Colors.white,
        elementTextColor: Colors.white,
        openColor: colorPrincipal,
        valueIndex: drop1,
        hint: "Categoria",
        items: [
          CustomDropdownItem(text: "Paleta"),
          CustomDropdownItem(text: "Helado"),
          CustomDropdownItem(text: "Sandwich"),
          CustomDropdownItem(text: "Bolis"),
          CustomDropdownItem(text: "Bolito"),
          CustomDropdownItem(text: "Troles"),
        ],
        onChanged: (newValue) {
          setState(() => drop1 = newValue);

          switch (drop1) {
            case 0:
              categoria = "Paleta";
              break;
            case 1:
              categoria = "Helado";
              break;
            case 2:
              categoria = "Sandwich";
              break;
            case 3:
              categoria = "Bolis";
              break;
            case 4:
              categoria = "Bolito";
              break;
            case 5:
              categoria = "Troles";
              break;
          }
        },
      ),
    );
  }

  _pickFlavor() {
    return Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: colorPrincipal,
            borderRadius: BorderRadius.all(Radius.circular(25))),
        height: MediaQuery.of(context).size.height * 0.09,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 10,
            ),
            Text(
              "Sabor: ",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Sabores')
                      .where('Categorias',
                          arrayContainsAny: [categoria]).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      const Text("Loading.....");
                    else {
                      List<DropdownMenuItem> currencyItems = [];
                      mapProductos.clear();
                      for (int i = 0; i < snapshot.data.docs.length; i++) {
                        DocumentSnapshot snap = snapshot.data.docs[i];
                        mapProductos.addAll({snap.id: snap['Materia']});

                        currencyItems.add(
                          DropdownMenuItem(
                            child: Text(
                              "${snap.id}",
                              style: TextStyle(color: Colors.white),
                            ),
                            value: "${snap.id}",
                          ),
                        );
                      }

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          DropdownButton(
                            items: currencyItems,
                            onChanged: (currencyValue) {
                              final snackBar = SnackBar(
                                backgroundColor: colorPrincipal,
                                content: Text(
                                  'Producto: $currencyValue',
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                              // ignore: deprecated_member_use
                              Scaffold.of(context)
                                  // ignore: deprecated_member_use
                                  .showSnackBar(snackBar);

                              setState(() {
                                selectedCurrency1 = currencyValue;
                                if (!productos.containsKey(selectedCurrency1))
                                  productos.addAll(_getFlavorMap());
                              });
                            },
                            value: selectedCurrency1,
                            isExpanded: false,
                            hint: new Text(
                              "Nombre: ",
                              style: TextStyle(color: Colors.white),
                            ),
                            dropdownColor: colorPrincipal,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                              size: 22.0,
                            ),
                          ),
                        ],
                      );
                    }
                    return LinearProgressIndicator();
                  }),
            )
          ],
        ));
  }

  Map<String, dynamic> _getFlavorMap() {
    if (categoria == 'Paleta') {
      return mapProductos[selectedCurrency1] == 'Agua'
          ? {
              selectedCurrency1.toString(): {
                'Materia': mapProductos[selectedCurrency1],
                'Cuadraleta': 0,
                'Hexagonal': 0,
                'Mini': 0,
                'Maxi': 0,
                'Tambos': 0
              }
            }
          : {
              selectedCurrency1.toString(): {
                'Materia': mapProductos[selectedCurrency1],
                'Cuadraleta': 0,
                'Hexagonal': 0,
                'Mini': 0,
                'Tambos': 0
              }
            };
    } else if (categoria == 'Helado') {
      return mapProductos[selectedCurrency1] == 'Agua'
          ? {
              selectedCurrency1.toString(): {
                'Materia': mapProductos[selectedCurrency1],
                'Helado 5L Agua': 0,
                'Helado 1L Agua': 0,
                'Tandas': 0
              }
            }
          : {
              selectedCurrency1.toString(): {
                'Materia': mapProductos[selectedCurrency1],
                'Helado 5L Leche': 0,
                'Helado 1L Leche': 0,
                'Tandas': 0
              }
            };
    } else {
      return {
        selectedCurrency1.toString(): {
          'Materia': mapProductos[selectedCurrency1],
          'Piezas': 0,
          'Tambos': 0
        }
      };
    }
  }

  Widget _cardInfo(String medida, String nombre) {
    return InkWell(
      onTap: () {
        productos.forEach((key, value) {
          print(key);
        });
        setState(() {
          productos[nombre][medida]++;
        });
      },
      child: Container(
        margin: EdgeInsets.only(left: 5, bottom: 10, top: 10, right: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              medida == 'Piezas'
                  ? medida
                  : medida.length > 10
                      ? medida.substring(6, 9)
                      : medida.length >= 4
                          ? medida.substring(0, 4)
                          : medida,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
            Container(
              color: Colors.deepPurple,
              alignment: Alignment.center,
              child: Text(productos[nombre][medida].toString()),
              width: MediaQuery.of(context).size.width * .05,
              height: MediaQuery.of(context).size.width * .05,
            ),
          ],
        ),
      ),
    );
  }

  void _calcularTotales() {
    _pzController = 0;
    _moldeController = 0;
    _miniController = 0;
    _maxiController = 0;
    _cuadController = 0;
    _hexaController = 0;
    _fiveLController = 0;
    _oneLController = 0;
    _miniController = 0;
    productos.forEach((key, value) {
      if (value['Cuadraleta'] != null) _cuadController += value['Cuadraleta'];
      if (value['Mini'] != null) _miniController += value['Mini'];
      if (value['Hexagonal'] != null) _hexaController += value['Hexagonal'];
      if (value['Maxi'] != null) _miniController += value['Maxi'];

      if (value['Helado 5L Agua'] != null) {
        _fiveLController += value['Helado 5L Agua'];
      }
      if (value['Helado 5L Leche'] != null) {
        _fiveLController += value['Helado 5L Leche'];
      }
      if (value['Helado 1L Agua'] != null) {
        _oneLController += value['Helado 1L Agua'];
      }
      if (value['Helado 1L Leche'] != null) {
        _oneLController += value['Helado 1L Leche'];
      }
      if (value['Piezas'] != null) {
        _pzController += value['Piezas'];
      }
      if (value['Tambos'] != null) {
        _moldeController += value['Tambos'];
      }
      if (value['Tandas'] != null) {
        _moldeController += value['Tandas'];
      }
    });
  }
}
