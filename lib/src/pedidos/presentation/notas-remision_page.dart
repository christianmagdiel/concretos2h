import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:concretos2h/src/widgets/pdfScreen.dart';
import 'package:concretos2h/src/pedidos/data/blocs/pedidos_bloc.dart';
import 'package:concretos2h/src/pedidos/data/models/nota-remision_model.dart';
import 'package:concretos2h/src/principal/data/globales.dart' as global;

class PedidosPage extends StatefulWidget {
  const PedidosPage({Key? key}) : super(key: key);

  @override
  State<PedidosPage> createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PedidosBloc notasRemision = new PedidosBloc();

  @override
  void initState() {
    notasRemision.cargarNotasRemision();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Consulta de notas de remisión'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
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
      ])),
    );
  }

  _loadData(PedidosBloc notaRemisionBloc, BuildContext context) {
    final size = MediaQuery.of(context).size;

    return StreamBuilder(
      stream: notaRemisionBloc.notasRemisionStream,
      builder: (BuildContext contextPrincipal,
          AsyncSnapshot<List<NotaRemisionModel>> snapshot) {
        if (!snapshot.hasData ||
            snapshot.connectionState == ConnectionState.waiting ||
            (notaRemisionBloc.cargandoNotasRemision)) {
          return Padding(
            padding: EdgeInsets.only(bottom: size.height * .35),
            child: Center(child: CircularProgressIndicator()),
          );
        } else {
          List<NotaRemisionModel>? notasModel = snapshot.data;
          return StreamBuilder<Object>(
              stream: notaRemisionBloc.isLoadingStream,
              initialData: false,
              builder: (BuildContext contextLoading, AsyncSnapshot snapshot) {
                if (!snapshot.data) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: notasModel!.length,
                    itemBuilder: (BuildContext contextLista, i) => _crearItem(
                        contextPrincipal, notasModel[i], notaRemisionBloc),
                  );
                } else {
                  return Container(
                    height: 30,
                    child: Column(
                      children: [
                        Text(
                          'Espere un momento por favor...',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.grey,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              });
        }
      },
    );
  }

  Widget _crearItem(BuildContext context, NotaRemisionModel nota,
      PedidosBloc notaRemisionBloc) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          children: [
            // Text('${nota.folioCarga}'),
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
            onPressed: () =>
                mostrarNotaRemision(context, notaRemisionBloc, nota),
            child: Text('Mostrar PDF'),
          )
        ],
      ),
    );
  }

  Future<void> mostrarNotaRemision(BuildContext context,
      PedidosBloc notaRemisionBloc, NotaRemisionModel nota) async {
    await notaRemisionBloc.mostrarPdf(nota.idNotaRemisionEnc);
    Uint8List bytes = base64Decode(global.data64.replaceAll('\n', ''));
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/notaRemision.pdf");
    await file.writeAsBytes(bytes.buffer.asUint8List());

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PDFScreen(bytes, nota.idNotaRemisionEnc)));
  }
}
