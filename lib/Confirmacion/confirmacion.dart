import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';

class Confirmacion extends StatefulWidget {
  final usuario;
  const Confirmacion({
    Key key,
    @required this.usuario,
  }) : super(key: key);

  @override
  _ConfirmacionState createState() => _ConfirmacionState();
}

List<bool> porConfirmar = [];

class _ConfirmacionState extends State<Confirmacion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("holaaaa"),
            centerTitle: true,
            backgroundColor: colorPrincipal,
            actions: []),
        drawer: CustomAppBar(
          usuario: widget.usuario,
        ),
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Ventas")
                    .where("Pendiente", isEqualTo: false)
                    .orderBy("Cliente")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: SpinKitFadingCube(
                    color: colorPrincipal,
                    size: 50.0,
                      ),
                    );
                  }
                  int length = snapshot.data.docs.length;
                  var docs = snapshot.data.docs;
                  return ListView.builder(
                    itemCount: length,
                    itemBuilder: (BuildContext context, int index) {
                      var doc = docs[index].data();
                      if (porConfirmar.length <= index) {
                        porConfirmar.add(false);
                      }

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          confirm(context, doc, index),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {});
                },
                child: Icon(Icons.format_align_left_outlined),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(CircleBorder()),
                  padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                  backgroundColor: MaterialStateProperty.all(
                      Colors.green), // <-- Button color
                  overlayColor:
                      // ignore: missing_return
                      MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.pressed))
                      return Colors.greenAccent; // <-- Splash color
                  }),
                ),
              ),
            )
          ],
        ));
  }

  Widget confirm(BuildContext context, Map<String, dynamic> doc, int index) {
    bool isSwitched = porConfirmar[index];
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: colorPrincipal,
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .12,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Cliente: " + doc["Cliente"]["Nombre"].toString()),
              Column(
                children: [
                  Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text("¿Confirma credito?")),
                  Switch(
                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                        porConfirmar[index] = value;
                      });

                      Future.delayed(const Duration(milliseconds: 500), () {
                        setState(() {});
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                ],
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(doc["FechaVenta"].toString()),
              Text("    Total: \$" + doc["Total"].toString())
            ],
          )
        ],
      ),
    );
  }
}
