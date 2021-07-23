
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

Color colorPrincipal = HexColor("#80DEEA");
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
            height: MediaQuery.of(context).size.height*0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width:MediaQuery.of(context).size.width*0.4,
                  height:MediaQuery.of(context).size.height*0.20,
                  decoration:BoxDecoration(
                    
                    image:DecorationImage(
                      image: AssetImage('assets/icono_provisional.png'), fit: BoxFit.fill
                    ),
                  
                  )
                  ),
                  Text("BIENVENIDO",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold
                  ),
                  )
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
                  Text("Usuario", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),),
                  Container(
                    height: MediaQuery.of(context).size.height*0.08,
                    color: Colors.red,
                    margin: EdgeInsets.all(15),
                    child: _buildTextField( Icons.person,"", _usuarioController),
                  ),
                  Text("Contraseña", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),),
                  Container(
                    height: MediaQuery.of(context).size.height*0.08,
                    color: Colors.red,
                    margin: EdgeInsets.all(15),
                    child: _buildTextFieldContr( Icons.lock,"", _passwordController),
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
  _buildTextField( IconData icon, String labelText, TextEditingController controllerPr)
  {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: colorPrincipal)
      ),
      child: TextField(

        controller: controllerPr,
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
  _buildTextFieldContr( IconData icon, String labelText, TextEditingController controllerPr)
  {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: colorPrincipal)
      ),
      child: TextField(
        obscureText: contraVal,
        controller: controllerPr,
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
          
          suffixIcon: IconButton(
            onPressed: (){
              setState(() {
                contraVal = !contraVal;
              });
            },
            icon: Icon(contraVal == true ?Icons.remove_red_eye: Icons.close, color: colorPrincipal,),
          )
          
        ),
      ),
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