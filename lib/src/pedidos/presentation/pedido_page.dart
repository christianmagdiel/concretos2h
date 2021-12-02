import 'package:flutter/material.dart';

class PedidosPage extends StatelessWidget {
  const PedidosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return Scaffold(
        appBar: AppBar(
          title: Text('Consulta de notas de remisión'),
          actions: <Widget>[
            // IconButton(
            //   icon: Icon(Icons.search),
            //   onPressed: () {
            //     showSearch(context: context, delegate: DataSearch());
            //   },
            // ),
            //  PerfilWidget(),
          ],
        ),
        body: SafeArea(
            child: Column(
          children: <Widget>[
            Align(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'NOTAS DE REMISIÓN',
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Flexible(
              child: Text('Hola mundo'),
            )
          ],
        )));
  }
}
