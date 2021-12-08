import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// ignore: import_of_legacy_library_into_null_safe

// ignore: must_be_immutable
class PDFScreen extends StatelessWidget {
  Uint8List byte;
  PDFScreen(this.byte);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nota de Remisión'),
      ),
      body: Center(
        child: Container(
            child: SfPdfViewer.memory(this.byte, searchTextHighlightColor: Colors.yellow,pageSpacing :1),

        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        // onPressed: () => _showPopup(context),
        onPressed: () => {},
        label: Text('Firmar Documento'),
        icon: Icon(Icons.app_registration_rounded),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
