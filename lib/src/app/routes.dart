import 'package:flutter/material.dart';
import 'package:concretos2h/src/pedidos/presentation/pedido_page.dart';
import 'package:concretos2h/src/principal/presentation/login_page.dart';
import 'package:concretos2h/src/principal/presentation/controlador_page.dart';

Map<String, WidgetBuilder> getRoutes() {
  return <String, WidgetBuilder>{
    'controlador': (BuildContext context) => ControladorPage(),
    'login': (BuildContext context) => LoginPage(),
    'pedidos': (BuildContext context) => PedidosPage(),
  };
}
