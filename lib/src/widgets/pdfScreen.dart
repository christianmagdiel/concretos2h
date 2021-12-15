import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:concretos2h/src/pedidos/data/blocs/pedidos_bloc.dart';
import 'package:concretos2h/src/pedidos/data/models/nota-remision_model.dart';

class PDFScreen extends StatefulWidget {
  final Uint8List byte;
  final NotaRemisionModel notaRemision;
  final String filePath;
  PDFScreen(this.byte, this.notaRemision, this.filePath);

  @override
  State<PDFScreen> createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nota de Remisión'),
      ),
      body: Center(
        child: Container(
          child: SfPdfViewer.memory(
            this.widget.byte,
            key: _pdfViewerKey,
            searchTextHighlightColor: Colors.yellow,
            pageSpacing: 1,
            scrollDirection: PdfScrollDirection.vertical,
          ),
        ),
      ),
      floatingActionButton: this.widget.notaRemision.firmaElectronica
          ? FloatingActionButton.extended(
              onPressed: () => OpenFile.open(this.widget.filePath),
              label: Text('Abrir Documento'),
              icon: Icon(Icons.open_in_new),
              backgroundColor: Colors.blueAccent)
          : FloatingActionButton.extended(
              onPressed: () => _showModalFirma(context),
              label: Text('Firmar Documento'),
              icon: Icon(Icons.app_registration_rounded),
              backgroundColor: Colors.blueAccent,
            ),
    );
  }

  void _showModalFirma(BuildContext context) {
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
                  Text('Ingresa la firma',
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
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.blueAccent),
                  ),
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
    // ignore: unused_local_variable
    var data;
    PedidosBloc notasRemision = new PedidosBloc();
    final ui.Image imageData =
        await _signaturePadKey.currentState!.toImage(pixelRatio: 3.0);
    var bytes = await imageData.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (bytes != null) {
      data = bytes.buffer.asUint8List();
    }

// Use plugin [path_provider] to export image to storage
    Directory? directory = await getExternalStorageDirectory();
    String path = directory!.path;
    print(path);
    await Directory('$path/test').create(recursive: true);
    File('$path/filename.jpg').writeAsBytesSync(bytes!.buffer.asInt8List());

    var result = await notasRemision.guardarFirma(
        data, this.widget.notaRemision.idNotaRemisionEnc);

    if (result['ok']) {
      Navigator.pushReplacementNamed(context, 'pedidos');
    }

    // setState(() {
    // _signatureData = data;
    // Image.memory(_signatureData) ASI SE MUESTRA LA IMAGGEN EN UN CONTAINER
    // });
  }

  void _handleClearButtonPressed() {
    Navigator.of(context).pop();
  }
}
