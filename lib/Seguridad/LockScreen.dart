

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paleteria_marfel/HexaColors/HexColor.dart';
import 'package:paleteria_marfel/Menu/PantallaInicio.dart';


class LockScreen extends StatefulWidget {
  final String usuario;
  LockScreen({Key key, this.usuario}) : super(key: key);

  @override
  _LockScreenState createState() => _LockScreenState();
}
 int value = 0;
 Color colorPrincipal = HexColor("#3C9CA8");
 bool badPassword = false;
 int intentos = 0;

 Timer _timer;
int _start = 60;

class _LockScreenState extends State<LockScreen> {

  void startTimer() {
  const oneSec = const Duration(seconds: 1);
  _timer = new Timer.periodic(
    oneSec,
    (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
          intentos = 0;
          _start = 60 * 2;
        });
      } else {
        setState(() {
          _start--;
        });
      }
    },
  );
}

@override
void dispose() {
  _timer.cancel();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
       backgroundColor: colorPrincipal,
       body: Container(
         child: Column(
           children: [
             Container(
               height: size.height*0.3,
               child: Image.asset("assets/marfelLogoProtbl.png"),
             ),
             badPassword == false ?
             _currentValue():_errorContra(),
             intentos == 3?
             timer():
             _numpad()
           ],
         ),
       ),
    );
  }


  Widget _numpad() {
    return Expanded(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        var height = constraints.biggest.height / 4;
        return Table(
          border: TableBorder.all(
            color: colorPrincipal,
            width: 1.0,
          ),
          children: [
            TableRow(children: [
              _num("1", height),
              _num("2", height),
              _num("3", height),
            ]),
            TableRow(children: [
              _num("4", height),
              _num("5", height),
              _num("6", height),
            ]),
            TableRow(children: [
              _num("7", height),
              _num("8", height),
              _num("9", height),
            ]),
            TableRow(children: [
              GestureDetector(
                child: Container(
                  height: height,
                  child: Center(
                    child: Icon(
                      Icons.refresh_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                onTap: (){
                  setState(() {
                    value = 0;
                  });
                },
              ),
              _num("0", height),
              GestureDetector(
                  child: Container(
                  height: height,
                  child: Center(
                    child: Icon(
                      Icons.login,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                onTap: (){
                  if(value == 5361)
                    {
                      Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.leftToRight,
                                child: PantallaInicio(
                                  usuario: widget.usuario,
                                )));
                    }
                    else
                    {
                      setState(() {
                        badPassword = true;
                        value = 0;
                        intentos += 1;
                        if(intentos == 3)
                        {
                          startTimer();
                          
                        }
                      });
                      Future.delayed(const Duration(milliseconds: 2000), () {
                setState(() {
                  badPassword = false;
                });
                });
                    }
                },
                ),
            ]),
          ],
        );
      }),
    );
  }
  Widget _num(String text, double height) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if(badPassword==true)
        {
          setState(() {
            value = 0;
          });
        }
        else
        {
          setState(() {
          if (text == ",") {
            value = value * 100;
          } else {
            value = value * 10 + int.parse(text);
          }
          print(value);
        });
        }
        
      },
      child: Container(
        height: height,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 40,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _currentValue() {
    return Text(
        value == 0 ? "":
        "${value.toString().replaceAll(RegExp(r"."), " * ")}",
        style: TextStyle(
          
          fontSize: 15,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      );
  }

  Widget _errorContra()
  {
    return Opacity(
      opacity: .9,
      child:
      Container(
      height: MediaQuery.of(context).size.height*0.08,
      width: MediaQuery.of(context).size.width*0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.red.shade700,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.error, color: Colors.white,),
          Text("Contraseña Incorrecta!",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold
          ),
          )
        ],
      ),
    )
    );
  }

  Widget timer(){
    return Expanded(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.error, color: Colors.white,),
                  Text("Numero De Intentos Excedido!\nVuelva A Intentar En: ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                  )
                ],
              ),
              Text("$_start",
              style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold
                  ),)
            ],
          ),
        );
      }),
    );
  }

}