import 'package:flutter/material.dart';
import 'package:concretos2h/src/widgets/drawer.dart';
import 'package:concretos2h/src/principal/data/globales.dart' as global;

class PerfilPage extends StatelessWidget {
  const PerfilPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    TextStyle _style = TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.white);

    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil de Usuario'),
      ),
      drawer: Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.white),
          child: CustomDrawer.getDrawer(context)),
      body: SafeArea(
        child: Card(
          elevation: 20,
          color: Color(0xffffffff),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff0066AC),
                border: Border.all(
                  color: Colors.black54,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              width: size.width * .90,
              height: size.width * .80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      backgroundImage:
                          AssetImage("assets/images/user_default.png"),
                    ),
                  ),
                  SizedBox(height: 50),
                  Text('Usuario: ${global.usuario}', style: _style),
                  Text('Correo: ${global.correoUsuario}', style: _style),
                  Text('Puesto: ${global.puestoUsuario}', style: _style),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
