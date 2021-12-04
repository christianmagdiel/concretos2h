import 'package:concretos2h/src/pedidos/data/blocs/pedidos_bloc.dart';
import 'package:concretos2h/src/pedidos/data/models/nota-remision_model.dart';
// import 'package:concretos2h/src/pedidos/data/nota-remision_provider.dart';
import 'package:flutter/material.dart';

class PedidosPage extends StatelessWidget {
  const PedidosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PedidosBloc notasRemision = new PedidosBloc();

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
            child: Column(children: <Widget>[
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
            child: _loadData(notasRemision, context),
          )
        ])));
  }

  _loadData(PedidosBloc notaRemision, BuildContext context) {
    final size = MediaQuery.of(context).size;
    notaRemision.cargarNotasRemision();
    return StreamBuilder(
      stream: notaRemision.notasRemisionStream,
      builder: (BuildContext context,
          AsyncSnapshot<List<NotaRemisionModel>> snapshot) {
        if (!snapshot.hasData ||
            snapshot.connectionState == ConnectionState.waiting ||
            (notaRemision.cargandoNotasRemision)) {
          return Padding(
            padding: EdgeInsets.only(bottom: size.height * .35),
            child: Center(child: CircularProgressIndicator()),
          );
        } else {
          List<NotaRemisionModel>? pedidosModel = snapshot.data;

          return ListView.builder(
            shrinkWrap: true,
            itemCount: 10,
            itemBuilder: (context, i) => _crearItem(context, pedidosModel![i]),
          );
        }
      },
    );
  }

  Widget _crearItem(BuildContext context, NotaRemisionModel nota) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          children: [
             Text('${nota.folioCarga}'),
            Text('${nota.folioNotaRemision}'),
          ],
        ),
      ),
      title: Text('${nota.cliente}'),
      subtitle: Text('${nota.obra}'),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: ()=>{},
            child: Text('Mostrar PDF'),
          ),
        ],
      ),
    );
  }
}
