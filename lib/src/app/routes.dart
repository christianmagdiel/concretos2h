
import 'package:concretos2h/src/widgets/signature.dart';
import 'package:flutter/material.dart';
import 'package:concretos2h/src/pedidos/presentation/notas-remision_page.dart';
import 'package:concretos2h/src/principal/presentation/login_page.dart';
import 'package:concretos2h/src/principal/presentation/controlador_page.dart';

Map<String, WidgetBuilder> getRoutes() {
  return <String, WidgetBuilder>{
    'controlador': (BuildContext context) => ControladorPage(),
    'login': (BuildContext context) => LoginPage(),
    'pedidos': (BuildContext context) => PedidosPage(),
    'firma' : (BuildContext context) => Signature(),
  };
}
