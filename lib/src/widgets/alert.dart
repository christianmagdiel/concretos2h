import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Dialogs {
  static void alert(BuildContext context, {title = '', message: ''}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            content: Text(message,
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15)),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              )
            ],
          );
        });
  }

  static void alertWithAction(BuildContext context,
      {title = '',
      message: '',
      btnTextAccion: '',
      required VoidCallback onConfirm}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            content: Text(message,
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15)),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: onConfirm,
                child: Text(btnTextAccion),
              )
            ],
          );
        });
  }

  static void confirm(BuildContext context,
      {title: 'Concretos 2H',
      required message,
      required btnTextConfirmar,
      required btnTextCancelar,
      required VoidCallback onCancel,
      required VoidCallback onConfirm}) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 50,
                  color: Colors.blueAccent,
                ),
                SizedBox(width: 10),
                Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.blueAccent)),
              ],
            ),
            content: Text(message, style: TextStyle(fontSize: 18)),
            actions: <Widget>[
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.red,
                      ),
                  onPressed: () {
                    onCancel();
                  },
                  child: Text(btnTextCancelar)),
              TextButton(
                style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.blueAccent,
                      ),
                  onPressed: () {
                    onConfirm();
                  },
                  child: Text(btnTextConfirmar)),
            ],
          );
        });
  }
}
