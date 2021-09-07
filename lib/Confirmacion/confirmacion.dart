import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:paleteria_marfel/CustomWidgets/CustomAppbar.dart';

class Confirmacion extends StatelessWidget {
  final usuario;
  const Confirmacion({
    Key key,
    @required this.usuario,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("holaaaa"),
            centerTitle: true,
            backgroundColor: colorPrincipal,
            actions: []),
        drawer: CustomAppBar(
          usuario: usuario,
        ),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .75,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Ventas")
                    .where("Pendiente", isEqualTo: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Image.asset("assets/marfelLoad.gif"),
                    );
                  }
                  int length = snapshot.data.docs.length;
                  var docs = snapshot.data.docs;
                  return ListView.builder(
                    itemCount: length,
                    itemBuilder: (BuildContext context, int index) {
                      var doc = docs[index].data();

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              height: MediaQuery.of(context).size.height * .05,
                              child: Text(doc["Pendiente"].toString())),
                          Divider()
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {},
                child: Icon(Icons.align_horizontal_left),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(CircleBorder()),
                  padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                  backgroundColor: MaterialStateProperty.all(
                      Colors.green), // <-- Button color
                  overlayColor:
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
}
