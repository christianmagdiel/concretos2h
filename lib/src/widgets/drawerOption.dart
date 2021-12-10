import 'package:concretos2h/src/app/session.dart';
import 'package:concretos2h/src/widgets/alert.dart';
import 'package:flutter/material.dart';

class DrawerOption {
  Session _sesion = new Session();


  perfilUsuario(BuildContext context) {
    Navigator.pushReplacementNamed(context, 'perfil');
  }

  notasRemision(BuildContext context) {
    Navigator.pushReplacementNamed(context, 'pedidos');
  }

  cerrarSesion(BuildContext context) {
    Dialogs.confirm(context,
        btnTextCancelar: "Cancelar",
        btnTextConfirmar: "Aceptar",
        message: '¿Deseas cerrar la sesión?',
        onConfirm: () {
          Navigator.pushReplacementNamed(context, 'login');
          _sesion.deleteSession();
        },
        onCancel: () => Navigator.pop(context));
  }
}
