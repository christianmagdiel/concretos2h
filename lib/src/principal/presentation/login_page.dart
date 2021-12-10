import 'dart:ui';
import 'package:concretos2h/src/principal/data/blocs/login_bloc.dart';
import 'package:concretos2h/src/widgets/fondoPantalla.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _usuarioTxt = "";
  String _passwordTxt = "";

  @override
  void initState() {
    this._usuarioTxt = "";
    this._passwordTxt = "";
    super.initState();
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
    final blocLogin = new LoginBloc();
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
          autofocus: true,
          style: TextStyle(color: Colors.black, fontSize: 18),
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: "Usuario",
            helperText: "example@concretos2h.com",
            border: const OutlineInputBorder(),
          ),
          onChanged: (value) => setState(() {
            _usuarioTxt = value;
          }),
        )),
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
          ),
          onChanged: (value) => setState(() {
            _passwordTxt = value;
          }),
        )),
        SizedBox(height: 10),
        Container(
          width: 200,
          height: 50,
          child: StreamBuilder<Object>(
              stream: blocLogin.isLoadingStream,
              initialData: false,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.data) {
                  return ElevatedButton(
                    style: style,
                    child: Text(
                      'Iniciar Sesión',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => iniciarSesion(blocLogin),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  iniciarSesion(LoginBloc bloc) async {
    if (_usuarioTxt.length > 0 && _passwordTxt.length > 0) {
      final result = await bloc.login(_usuarioTxt, _passwordTxt);

      if (result["ok"]) {
        inicializarDatos();
        Navigator.pushNamed(context, 'pedidos');
      }
    } else {
      print('Ingrese sus credenciales correspondientes para iniciar sesión');
    }
  }

  void inicializarDatos() {}
}
