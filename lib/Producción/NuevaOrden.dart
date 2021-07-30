import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:paleteria_marfel/Login/Login.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:yudiz_modal_sheet/yudiz_modal_sheet.dart';

class NuevaOrden extends StatefulWidget {
  NuevaOrden({Key key}) : super(key: key);

  @override
  _NuevaOrdenState createState() => _NuevaOrdenState();
}

var selectedCurrency1;
var selectedCurrency;
final _maxiController = TextEditingController();
final _cuadController = TextEditingController();
final _hexaController = TextEditingController();
final _piezasController = TextEditingController();
final _fiveLController = TextEditingController();
final _oneLController = TextEditingController();

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
List<Map<String, dynamic>> productos = [];
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
                                      MediaQuery.of(context).size.height * 0.55,
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
                                                  "Borrar 1",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ))
                                          ],
                                        ),
                                      ),
                                      for (int i = 0; i < productos.length; i++)
                                        Container(
                                          margin: EdgeInsets.all(10),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .8,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .05,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: colorPrincipal,
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.all(10),
                                                child: Text(
                                                  productos[i]
                                                      .keys
                                                      .toString()
                                                      .replaceAll(")", "")
                                                      .replaceAll("(", ""),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Container(
                                                child: Text(mapProductos[
                                                        productos[i]
                                                            .keys
                                                            .toString()
                                                            .replaceAll(")", "")
                                                            .replaceAll(
                                                                "(", "")]
                                                    .toString()),
                                              )
                                            ],
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                        ],
                      )
                    : Column(
                        children: [
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
                              if (categoria == "Troles") {
                                subirTroll();
                                buildAlert(context);
                              }
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

  _buildTextField(
      IconData icon, String labelText, TextEditingController controllerPr) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white, border: Border.all(color: colorPrincipal)),
      child: TextField(
        controller: controllerPr,
        keyboardType: TextInputType.number,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          labelText: labelText,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          labelStyle: TextStyle(color: colorPrincipal),
          icon: Icon(icon, color: colorPrincipal),
        ),
      ),
    );
  }

  subirPaletaAgua() {
    String turno = "";
    if (_currentSliderValue == 0) {
      turno = "Dia";
    } else {
      turno = "Noche";
    }
    FirebaseFirestore.instance.collection("Produccion").add({
      "Sabor": productos,
      "Date": DateTime.now(),
      "Dia": DateTime.now().day,
      "Mes": DateTime.now().month,
      "Año": DateTime.now().year,
      "Materia": materia,
      "Categoria": categoria,
      "Tambo": double.parse(numeroTambos),
      "Maxi": double.parse(_maxiController.text),
      "Hexagonal": double.parse(_hexaController.text),
      "Cuadraleta": double.parse(_cuadController.text),
      "Turno": turno,
      "Medida": "Tambos"
    }).then((value) => {
          setState(() {
            prodPart = true;
            _maxiController.text = "";
            _hexaController.text = "";
            _cuadController.text = "";
            _fiveLController.text = "";
            _oneLController.text = "";
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

  subirPaletaLeche() {
    String turno = "";
    if (_currentSliderValue == 0) {
      turno = "Dia";
    } else {
      turno = "Noche";
    }
    FirebaseFirestore.instance.collection("Produccion").add({
      "Sabor": productos,
      "Dia": DateTime.now().day,
      "Mes": DateTime.now().month,
      "Año": DateTime.now().year,
      "Materia": materia,
      "Categoria": categoria,
      "Tambo": double.parse(numeroTambos),
      "Hexagonal": double.parse(_hexaController.text),
      "Cuadraleta": double.parse(_cuadController.text),
      "Turno": turno,
      "Medida": "Tambos"
    }).then((value) => {
          setState(() {
            prodPart = true;
            _maxiController.text = "";
            _hexaController.text = "";
            _cuadController.text = "";
            _fiveLController.text = "";
            _oneLController.text = "";
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

  subirHelado() {
    String turno = "";
    if (_currentSliderValue == 0) {
      turno = "Dia";
    } else {
      turno = "Noche";
    }
    FirebaseFirestore.instance.collection("Produccion").add({
      "Sabor": productos,
      "Dia": DateTime.now().day,
      "Mes": DateTime.now().month,
      "Año": DateTime.now().year,
      "Materia": materia,
      "Categoria": categoria,
      "Tanda": double.parse(numeroTambos),
      "5L": double.parse(_fiveLController.text),
      "1L": double.parse(_oneLController.text),
      "Turno": turno,
      "Medida": "Tandas"
    }).then((value) => {
          setState(() {
            prodPart = true;
            _maxiController.text = "";
            _hexaController.text = "";
            _cuadController.text = "";
            _fiveLController.text = "";
            _oneLController.text = "";
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

  subirSandwich() {
    String turno = "";
    if (_currentSliderValue == 0) {
      turno = "Dia";
    } else {
      turno = "Noche";
    }
    FirebaseFirestore.instance.collection("Produccion").add({
      "Sabor": productos,
      "Dia": DateTime.now().day,
      "Mes": DateTime.now().month,
      "Año": DateTime.now().year,
      "Materia": materia,
      "Categoria": categoria,
      "Tambo": double.parse(numeroTambos),
      "Piezas": double.parse(_piezasController.text),
      "Turno": turno,
      "Medida": "Tambos"
    }).then((value) => {
          setState(() {
            prodPart = true;
            _maxiController.text = "";
            _hexaController.text = "";
            _cuadController.text = "";
            _fiveLController.text = "";
            _oneLController.text = "";
            _piezasController.text = "";
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

  subirBolis() {}

  subirTroll() {
    String turno = "";
    if (_currentSliderValue == 0) {
      turno = "Dia";
    } else {
      turno = "Noche";
    }
    FirebaseFirestore.instance.collection("Produccion").add({
      "Sabor": productos,
      "Dia": DateTime.now().day,
      "Mes": DateTime.now().month,
      "Año": DateTime.now().year,
      "Materia": materia,
      "Categoria": categoria,
      "Tambo": numeroTambos,
      "Piezas": double.parse(_piezasController.text),
      "Turno": turno,
      "Medida": "Tambos"
    }).then((value) => {
          setState(() {
            prodPart = true;
            _maxiController.text = "";
            _hexaController.text = "";
            _cuadController.text = "";
            _fiveLController.text = "";
            _oneLController.text = "";
            _piezasController.text = "";
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

  Widget buildTextWithIcon() {
    return ProgressButton.icon(
      iconedButtons: {
        ButtonState.idle: IconedButton(
            text: "Aceptar",
            icon: Icon(Icons.send, color: Colors.white),
            color: colorPrincipal),
        ButtonState.loading: IconedButton(
            text: "Enviando...", color: Colors.deepPurple.shade700),
        ButtonState.fail: IconedButton(
            text: "Orden incorrecta",
            icon: Icon(Icons.cancel, color: Colors.white),
            color: Colors.red.shade300),
        ButtonState.success: IconedButton(
            text: "Enviado",
            icon: Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
            color: Colors.green.shade400)
      },
      onPressed: () {
        print("object");
      },
      state: stateTextWithIcon,
    );
  }

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
                          _maxiController.text = "";
                          _hexaController.text = "";
                          _cuadController.text = "";
                          _fiveLController.text = "";
                          _oneLController.text = "";
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
                                productos.add(_getFlavorMap());

                                print(productos);
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
                'Cuadraleta': 0,
                'Hexagonal': 0,
                'Mini': 0,
                'Maxi': 0,
                'Materia': mapProductos[selectedCurrency1],
                'tambos': 0
              }
            }
          : {
              selectedCurrency1.toString(): {
                'Cuadraleta': 0,
                'Hexagonal': 0,
                'Mini': 0,
                'Materia': mapProductos[selectedCurrency1],
                'tambos': 0
              }
            };
      ;
    } else if (categoria == 'Helado') {
      return {selectedCurrency1.toString(): {}};
    } else if (categoria == 'Sandwich') {
      return {selectedCurrency1.toString(): {}};
    } else if (categoria == 'Bolis') {
      return {selectedCurrency1.toString(): {}};
    } else if (categoria == 'Bolito') {
      return {selectedCurrency1.toString(): {}};
    } else if (categoria == 'Troles') {
      return {selectedCurrency1.toString(): {}};
    }
    return {};
  }
}
