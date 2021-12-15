import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:concretos2h/src/widgets/pdfScreen.dart';
import 'package:concretos2h/src/pedidos/data/blocs/pedidos_bloc.dart';
import 'package:concretos2h/src/pedidos/data/models/nota-remision_model.dart';
import 'package:concretos2h/src/widgets/drawer.dart';
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
      ),
      drawer: Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.white),
          child: CustomDrawer.getDrawer(context)),
      body: SafeArea(
          child: Column(children: <Widget>[
        Align(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'NOTAS DE REMISIÓN',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
        ),
        Flexible(
          child: _loadData(notasRemision, context),
        )
      ])),
    );
  }

  Future _refreshData() async {
    notasRemision.cargarNotasRemision();
  }

  _loadData(PedidosBloc notaRemisionBloc, BuildContext context) {
    final size = MediaQuery.of(context).size;

    return StreamBuilder(
      stream: notaRemisionBloc.notasRemisionStream,
      builder: (BuildContext contextPrincipal,
          AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (!snapshot.hasData ||
            snapshot.connectionState == ConnectionState.waiting ||
            (notaRemisionBloc.cargandoNotasRemision)) {
          return Padding(
            padding: EdgeInsets.only(bottom: size.height * .35),
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (!snapshot.data!["value"]) {
          return Container(
            color: Colors.red,
            child: Text(snapshot.data!["data"]),
          );
        } else {
          List<NotaRemisionModel>? notasModel = snapshot.data!["data"];
          return StreamBuilder<Object>(
              stream: notaRemisionBloc.isLoadingStream,
              initialData: false,
              builder: (BuildContext contextLoading, AsyncSnapshot snapshot) {
                if (!snapshot.data) {
                  return RefreshIndicator(
                    onRefresh: _refreshData,
                    strokeWidth: 3,
                    backgroundColor: Colors.blueAccent,
                    color: Colors.white,
                    displacement: 200,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: notasModel!.length,
                      itemBuilder: (BuildContext contextLista, i) => _crearItem(
                          contextPrincipal, notasModel[i], notaRemisionBloc),
                    ),
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
                              fontStyle: FontStyle.italic,
                              color: Colors.blue,
                              fontSize: 18),
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
    return Card(
      elevation: 5,
      child: ListTile(
        leading: Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
                color: Color(0xff838383),
                borderRadius: BorderRadius.circular(12)),
            child: Center(
                child: Text(
              '${nota.idNotaRemisionEnc}',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ))),
        title: Text('${nota.cliente}'),
        subtitle: Text('${nota.obra}'),
        trailing: Wrap(
          spacing: 15,
          children: <Widget>[
            GestureDetector(
              child: Icon(Icons.picture_as_pdf,
                  color: Colors.blueAccent, size: 30),
              onTap: () => mostrarNotaRemision(context, notaRemisionBloc, nota),
            ),

            nota.firmaElectronica
                ? Icon(Icons.edit_location_sharp, color: Colors.green, size: 30)
                : Icon(
                    Icons.edit_off,
                    size: 30,
                  )

            // SizedBox(width: 1,),
          ],
        ),
      ),
    );
  }

  Future<void> mostrarNotaRemision(BuildContext context,
      PedidosBloc notaRemisionBloc, NotaRemisionModel nota) async {
    await notaRemisionBloc.mostrarPdf(nota.idNotaRemisionEnc);
    Uint8List bytes = base64Decode(global.pdfDataBase64.replaceAll('\n', ''));
    final output = await getTemporaryDirectory();
    final file =
        File("${output.path}/notaRemision-${nota.idNotaRemisionEnc}.pdf");
    await file.writeAsBytes(bytes.buffer.asUint8List());
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PDFScreen(bytes, nota, file.path)));
  }
}
