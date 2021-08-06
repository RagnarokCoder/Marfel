
import 'package:flutter/material.dart';
import 'package:paleteria_marfel/HexaColors/HexColor.dart';
import 'package:provider/provider.dart';
import 'package:yudiz_modal_sheet/yudiz_modal_sheet.dart';
import 'package:paleteria_marfel/FirebaseAuth/Authentication_Service.dart';


class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

Color colorPrincipal = HexColor("#3C9CA8");
final _usuarioController = TextEditingController();
final _passwordController = TextEditingController();
bool contraVal=true;

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      
      backgroundColor: Colors.white,
       body: ListView(
         children: [
          Container(
            color: colorPrincipal,
            height: MediaQuery.of(context).size.height*0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width:MediaQuery.of(context).size.width*0.8,
                  height:MediaQuery.of(context).size.height*0.35,
                  decoration:BoxDecoration(
                    
                    image:DecorationImage(
                      image: AssetImage('assets/marfelLogoProtbl.png'), fit: BoxFit.fill
                    ),
                  
                  )
                  ),
                  
                  
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height*0.08,
            color: colorPrincipal,
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width*0.65,
                  height: MediaQuery.of(context).size.height*0.12,
                  child: CustomPaint(
                    painter: CurvePainter1(),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width*0.35,
                  height: MediaQuery.of(context).size.height*0.12,
                  child: CustomPaint(
                    painter: CurvePainter(),
                  ),
                ),
              ],
            )
          ),
          Container(
            height: MediaQuery.of(context).size.height*0.4,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  Container(
                    height: MediaQuery.of(context).size.height*0.08,
                    width: MediaQuery.of(context).size.width*0.8,                    
                    color: Colors.white,
                    margin: EdgeInsets.all(15),
                    child: TextField(
                      controller: _usuarioController,
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.white,
            ),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
                prefixIcon: Container(
            decoration: BoxDecoration(
              color: colorPrincipal,
              shape: BoxShape.circle,
              border: Border.all(color: colorPrincipal)
            ),
            child: Icon(Icons.person, color: Colors.white,),
          ),
                hintText: "    Usuario",
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.normal
                ),
                 enabledBorder:  OutlineInputBorder(
      borderSide:  BorderSide(color: colorPrincipal, width: 1.0, ),
      borderRadius: BorderRadius.circular(25.0),
    ),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: colorPrincipal, width: 32.0),
                    borderRadius: BorderRadius.circular(25.0)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colorPrincipal, width: 32.0),
                    borderRadius: BorderRadius.circular(25.0)))),
      ),
                  //Contraseña
                  Container(
                    height: MediaQuery.of(context).size.height*0.08,
                    width: MediaQuery.of(context).size.width*0.8,                    
                    color: Colors.white,
                    margin: EdgeInsets.all(15),
                    child: TextField(
                      obscureText: contraVal,
                      controller: _passwordController,
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
            onPressed: (){
              setState(() {
                contraVal = !contraVal;
              });
            },
            icon: Icon(contraVal == true ?Icons.remove_red_eye: Icons.close, color: Colors.white,),
          ),
                contentPadding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
                prefixIcon: Container(
            decoration: BoxDecoration(
              color: colorPrincipal,
              shape: BoxShape.circle,
              border: Border.all(color: colorPrincipal)
            ),
            child: Icon(Icons.lock, color: Colors.white,),
          ),
                hintText: "    Contraseña",
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.normal
                ),
                 enabledBorder:  OutlineInputBorder(
      borderSide:  BorderSide(color: colorPrincipal, width: 1.0, ),
      borderRadius: BorderRadius.circular(25.0),
    ),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: colorPrincipal, width: 32.0),
                    borderRadius: BorderRadius.circular(25.0)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colorPrincipal, width: 32.0),
                    borderRadius: BorderRadius.circular(25.0)))),
      ),
                ],
              ),
            ),
          )
         ],
         
       ),
       bottomNavigationBar: GestureDetector(
         onTap:  () {
           if(_usuarioController.text.isEmpty || _passwordController.text.isEmpty)
                                {
                                  buildAlert(context);
                                }
                                else
                                {
                                  validarLogin();
                                }
         },
         child: Container(
         height: MediaQuery.of(context).size.height*0.1,
         color: colorPrincipal,
         child: Row(
           mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Text("Iniciar Sesión", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
               SizedBox(width: 20,),
               Icon(Icons.login, color: Colors.white),
             ],
           ),
       ),
       )
    );
  }
  
  
  void validarLogin()
  {

    context.read<AuthenticationService>().signIn(
                  email: _usuarioController.text.trim(),
                  password: _passwordController.text.trim(),
                
                );   
                                                               
  }
  
  

  buildAlert(BuildContext context)
  {
    YudizModalSheet.show(
    context: context,
    child: Container(
      decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50))
               ),
      height: 100,
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 15,),
            Text("No deje Campos Vacios", style: (
                                      TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: colorPrincipal
                                      )
                                    ),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton.icon(
                color: Colors.transparent,
                elevation: 0,
                onPressed: (){
                  
                 
                  Navigator.pop(context);
                }, 
                icon: Icon(Icons.check_circle, color: Color(0xff00cf8d),), 
                label: Text("Confirmar", style: TextStyle(color: colorPrincipal),)),
                
              ],
            )
          ],
        )
      ),
    ),
    direction: YudizModalSheetDirection.TOP);
  }
}


class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = colorPrincipal;
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height *1);
    
    path.quadraticBezierTo(size.width * 0.5, size.height * 1.8,
        size.width * 1.0, size.height * 1);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CurvePainter1 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height *1);
    
    path.quadraticBezierTo(size.width * 0.50, size.height * -0.5,
        size.width * 1, size.height *1);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }


  

}