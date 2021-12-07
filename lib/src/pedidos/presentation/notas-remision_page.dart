import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:concretos2h/src/pedidos/data/blocs/pedidos_bloc.dart';
import 'package:concretos2h/src/pedidos/data/models/nota-remision_model.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:convert';
import 'package:convert/convert.dart';

class PedidosPage extends StatefulWidget {
  const PedidosPage({Key? key}) : super(key: key);

  @override
  State<PedidosPage> createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  late Uint8List _signatureData;
  bool _isSigned = false;
  @override
  Widget build(BuildContext context) {
    PedidosBloc notasRemision = new PedidosBloc();

    return Scaffold(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPopup(context),
        backgroundColor: Colors.black87,
        child: Icon(Icons.app_registration_rounded),
      ),
    );
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
          List<NotaRemisionModel>? notasModel = snapshot.data;

          return ListView.builder(
            shrinkWrap: true,
            itemCount: notasModel!.length,
            itemBuilder: (context, i) => _crearItem(context, notasModel[i]),
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
            onPressed: () => mostrarNotaRemision,
            child: Text('Mostrar PDF'),
          ),
        ],
      ),
    );
  }

  mostrarNotaRemision() {
    final args = [];
    String pdfBase64 = "";
  }

  void _showPopup(BuildContext context) {
    // _isSigned = false;

    // if (_isWebOrDesktop) {
    //   _backgroundColor = _isDark ? model.webBackgroundColor : Colors.white;
    // }

    showDialog<Widget>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            final Color? backgroundColor = Colors.white;
            final Color textColor = Colors.black;

            return AlertDialog(
              insetPadding: const EdgeInsets.all(12.0),
              backgroundColor: backgroundColor,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Ingresa tu firma',
                      style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto-Medium')),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child:
                        Icon(Icons.clear, color: Colors.grey[400], size: 24.0),
                  )
                ],
              ),
              titlePadding: const EdgeInsets.all(16.0),
              content: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300)),
                  width: MediaQuery.of(context).size.width < 306
                      ? MediaQuery.of(context).size.width
                      : 306,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width < 306
                              ? MediaQuery.of(context).size.width
                              : 306,
                          height: 172,
                          child: SfSignaturePad(key: _signaturePadKey))
                    ],
                  ),
                ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
              actionsPadding: const EdgeInsets.all(8.0),
              buttonPadding: EdgeInsets.zero,
              actions: <Widget>[
                TextButton(
                  onPressed: _handleClearButtonPressed,
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                  ),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto-Medium'),
                  ),
                ),
                const SizedBox(width: 8.0),
                TextButton(
                  onPressed: () {
                    _handleSaveButtonPressed();
                    Navigator.of(context).pop();
                  },
                  // style: ButtonStyle(
                  //   foregroundColor: MaterialStateProperty.all<Color>(
                  //       model.currentPaletteColor),
                  // ),
                  child: const Text('Guardar',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto-Medium')),
                )
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _handleSaveButtonPressed() async {
    late Uint8List data;

    final ui.Image imageData =
        await _signaturePadKey.currentState!.toImage(pixelRatio: 3.0);
    final ByteData? bytes =
        await imageData.toByteData(format: ui.ImageByteFormat.png);
    if (bytes != null) {
      data = bytes.buffer.asUint8List();
    }

    setState(() {
      _signatureData = data;
      // Image.memory(_signatureData) ASI SE MUESTRA LA IMAGGEN EN UN CONTAINER
    });
  }

  void _handleClearButtonPressed() {
    Navigator.of(context).pop();
    _signaturePadKey.currentState!.clear();
    _isSigned = false;
  }
}
