import 'dart:ui';

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
    GlobalKey<FormState> keyForm = new GlobalKey();

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(25),
          child: AppBar(
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Concretos 2H',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w300),
                ),
                Text(
                  'INICIAR SESÍON',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
        body: Center(
          child: new SingleChildScrollView(
            child: new Container(
              margin: new EdgeInsets.all(20.0),
              child: new Form(
                key: keyForm,
                child: formulario(), //Este metodo lo crearemos mas adelante
              ),
            ),
          ),
        ));
  }

  Widget formulario() {
    final ButtonStyle style = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
        elevation: 5,
        
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
        shadowColor: Colors.blue);

    return Column(
      children: <Widget>[
        Text('Bienvenido'),
        SizedBox(height: 10),
        Container(
            child: TextField(
                decoration: InputDecoration(
          hintText: "Usuario",
          helperText: "example@concretos2h.com",
          border: const OutlineInputBorder(),
        ))),
        SizedBox(height: 10),
        Container(
            child: TextField(
                decoration: InputDecoration(
          hintText: "Contraseña",
          border: const OutlineInputBorder(),
        ))),
        SizedBox(height: 10),
        Container(
          width: 200,
          height: 50,
          child: ElevatedButton(
            style: style,
            onPressed: () =>   Navigator.pushReplacementNamed(context, 'pedidos'),
            child: Text('Iniciar Sesión'),
          ),
        ),
      ],
    );
  }
}
