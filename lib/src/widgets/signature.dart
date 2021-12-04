import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

///Renders the SignaturePad widget.
class Signature extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text('Firma Electronica'),
      ),

      body: _MyHomePage(),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  _MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  void _handleClearButtonPressed() {
    signatureGlobalKey.currentState!.clear();
  }

  void _handleSaveButtonPressed() async {
    final data =
        await signatureGlobalKey.currentState!.toImage(pixelRatio: 3.0);
    final bytes = await data.toByteData(format: ui.ImageByteFormat.png);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Container(
                color: Colors.grey[300],
                child: Image.memory(bytes!.buffer.asUint8List()),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            children: [
          Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                  child: SfSignaturePad(
                      key: signatureGlobalKey,
                      backgroundColor: Colors.white,
                      strokeColor: Colors.black,
                      minimumStrokeWidth: 1.0,
                      maximumStrokeWidth: 4.0),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)))),
          SizedBox(height: 10),
          Row(children: <Widget>[
            TextButton(
              child: Text('Aceptar'),
              onPressed: _handleSaveButtonPressed,
            ),
            TextButton(
              child: Text('Borrar'),
              onPressed: _handleClearButtonPressed,
            ),
            TextButton(
              child: Text('OPEN'),
              onPressed: _showPopup,
            ),
          ], mainAxisAlignment: MainAxisAlignment.spaceEvenly)
        ],
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center));
  }


    void _showPopup() {
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
            final Color textColor = Colors.white ;

            return AlertDialog(
              insetPadding: const EdgeInsets.all(12.0),
              backgroundColor: backgroundColor,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Draw your signature',
                      style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto-Medium')),
                  InkWell(
                    //ignore: sdk_version_set_literal
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.clear,
                        color: Colors.grey[400],
                        size: 24.0),
                  )
                ],
              ),
              titlePadding: const EdgeInsets.all(16.0),
              content: SingleChildScrollView(
                child: Container(
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
                        decoration: BoxDecoration(
                          // border:
                              // Border.all(color: _getBorderColor()!, width: 1),
                        ),
                        child: SfSignaturePad(
                            // minimumStrokeWidth: _minWidth,
                            // maximumStrokeWidth: _maxWidth,
                            // strokeColor: _strokeColor,
                            // backgroundColor: _backgroundColor,
                            // onDrawStart: _handleOnDrawStart,
                            // key: _signaturePadKey),
                      )),
                      // const SizedBox(height: 24),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: <Widget>[
                      //     Text(
                      //       'Pen Color',
                      //       style: TextStyle(
                      //           color: textColor,
                      //           fontWeight: FontWeight.w400,
                      //           fontFamily: 'Roboto-Regular'),
                      //     ),
                      //     Container(
                      //       width: 124,
                      //       // child: Row(
                      //       //   crossAxisAlignment: CrossAxisAlignment.center,
                      //       //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       //   children: _addStrokeColorPalettes(setState),
                      //       // ),
                      //     )
                      //   ],
                      // ),
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
                  // style: ButtonStyle(
                  //   foregroundColor: MaterialStateProperty.all<Color>(
                  //       model.currentPaletteColor),
                  // ),
                  child: const Text(
                    'CLEAR',
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
                  child: const Text('SAVE',
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
}
