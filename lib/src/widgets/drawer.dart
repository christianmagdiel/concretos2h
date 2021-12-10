import 'package:concretos2h/src/widgets/drawerOption.dart';
import 'package:flutter/material.dart';
import 'package:concretos2h/src/principal/data/globales.dart' as global;

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class CustomDrawer {
  static int selectedDrawerIndex = 1;

  static final _drawerItems = [
    DrawerItem("Perfil", Icons.person),
    DrawerItem("Notas Remision", Icons.drive_file_move),
    DrawerItem("Aviso legal", Icons.info),
    DrawerItem("Cerrar Sesión", Icons.logout)
  ];

  static _onTapDrawer(int itemPos, BuildContext context) {
    selectedDrawerIndex = itemPos;
    switch (itemPos) {
      case 3:
        DrawerOption().cerrarSesion(context);
        break;
      default:
    }
    // Navigator.pop(context);
  }

  static Widget getDrawer(BuildContext context) {
    List<Widget> drawerOptions = [];
    for (var i = 0; i < _drawerItems.length; i++) {
      var d = _drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(d.title),
        selected: i == selectedDrawerIndex,
        onTap: () => _onTapDrawer(i, context),
      ));
    }

    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 150,
            child: UserAccountsDrawerHeader(
                accountEmail: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(global.correoUsuario),
                ),
                accountName: Row(children: <Widget>[
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.red),
                    child: CircleAvatar(
                      backgroundImage:
                          AssetImage("assets/images/concreto2h.png"),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(global.usuario,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(height: 5),
                      Text(
                        global.puestoUsuario,
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ])),
          ),
          Column(children: drawerOptions)
        ],
      ),
    );
  }
}
