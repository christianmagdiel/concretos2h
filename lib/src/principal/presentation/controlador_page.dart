import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';



class ControladorPage extends StatefulWidget {
  @override
  _ControladorPageState createState() => _ControladorPageState();
}

class _ControladorPageState extends State<ControladorPage> {

  @override
  void initState() {
    super.initState();
    this._check();
  }

  _check() async {
    
    // final token = await _authApi.getAccessToken();
    // if (token != null) {
    //   Navigator.pushReplacementNamed(context, 'consultaPedidos');
    // } else {
      print('ENTRO AL PROCESO');
      Navigator.pushReplacementNamed(context, 'login');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xff335198),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(height: 35),
              Text('Bienvenido . . .',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25))
            ],
          ),
        ),
      ),
    );
  }
}
