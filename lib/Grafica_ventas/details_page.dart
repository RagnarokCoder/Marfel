import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailsPage1{
  final String categoryName;
  final int month;

  DetailsPage1(this.categoryName, this.month);
}

class DetailsParams extends StatefulWidget {
  final DetailsPage1 params;

  const DetailsParams({Key key, this.params}) : super(key: key);
  @override
  _DetailsParamsState createState() => _DetailsParamsState();
}

class _DetailsParamsState extends State<DetailsParams> {
  @override
  Widget build(BuildContext context) {

     // ignore: deprecated_member_use
     var _query = FirebaseFirestore.instance
                .collection('Gastos')
                .where("Mes", isEqualTo: widget.params.month + 1)
                .where("Nombre", isEqualTo: widget.params.categoryName)
                .snapshots();

    return Scaffold(

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          centerTitle: true,
           title: Text(widget.params.categoryName),
        backgroundColor: Colors.blue[700]
        ),
        
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _query,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data){
          if(data.hasData)
          {
            return ListView.builder(
              itemBuilder: (BuildContext context,int index){
                // ignore: deprecated_member_use
                var document = data.data.docs[index];
                

                return Dismissible(
                  // ignore: deprecated_member_use
                  key: Key(document.id),
                  onDismissed: (direction){
                    // ignore: deprecated_member_use
                    FirebaseFirestore.instance
                      .collection('Gastos')
                      // ignore: deprecated_member_use
                      .doc(document.id)
                      .delete();

                  },
                    child: ListTile(
                   leading: Stack(
               
                     children: <Widget>[
                       
                       Icon(Icons.calendar_today,size: 40,),
                       Positioned(
                         left: 0,
                         right: 0,
                         bottom: 8,
                         child: Text(document.data()["Dia"].toString(), textAlign: TextAlign.center,), 
                         ),
                   ],),
                   title:Container(
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("${"Nombre: "+document.data()["Nombre"]+" "}",
                                    style: TextStyle(
                                      color:Colors.blueAccent,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18.0,
                              ),
                           ),
                       )
        
                     ),
      

                  ),
                );
            },
              // ignore: deprecated_member_use
              itemCount: data.data.docs.length,
            );
          }

          return Center(child: CircularProgressIndicator()
          );
        },

        )
       
    );
  }

  
}


