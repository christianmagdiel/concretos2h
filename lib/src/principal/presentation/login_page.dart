import 'dart:ui';
import 'package:concretos2h/src/widgets/fondoPantalla.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usuarioTxt = TextEditingController();
  final _passwordTxt = TextEditingController();
  var focusNode = FocusNode();
  String idAndroid = "";
  String dispositivo = "";
  // bool _validateUser = false;
  // bool _validatePassword = false;
  @override
  void dispose() {
    _usuarioTxt.dispose();
    _passwordTxt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // GlobalKey<FormState> keyForm = new GlobalKey();
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(
            elevation: 5,
          ),
        ),
        body: Center(
          child: new SingleChildScrollView(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  width: double.infinity,
                  height: size.height,
                  // color: Colors.red,
                  child: FondoPantalla(),
                ),
                Container(
                  margin: new EdgeInsets.all(20.0),
                  child: new Form(
                    // key: keyForm,
                    child: formulario(), //Este metodo lo crearemos mas adelante
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget formulario() {
    final ButtonStyle style = ElevatedButton.styleFrom(
        elevation: 10,
        shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(3))),
        shadowColor: Colors.black);

    return Column(
      children: <Widget>[
        Image.asset('assets/images/concreto2h.png', fit: BoxFit.fill),
        Text(
          'Bienvenido',
          style: TextStyle(fontSize: 30),
        ),
        SizedBox(height: 25),
        Container(
            child: TextField(
                style: TextStyle(color: Colors.black, fontSize: 18),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Usuario",
                  helperText: "example@concretos2h.com",
                  border: const OutlineInputBorder(),
                ))),
        SizedBox(height: 10),
        Container(
            child: TextField(
                obscureText: true,
                style: TextStyle(color: Colors.black, fontSize: 18),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Contraseña",
                  border: const OutlineInputBorder(),
                ))),
        SizedBox(height: 10),
        Container(
          width: 200,
          height: 50,
          child: ElevatedButton(
            style: style,
            child: Text(
              'Iniciar Sesión',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            onPressed: () => Navigator.pushNamed(context, 'pedidos'),
          ),
        ),
      ],
    );
  }
}
