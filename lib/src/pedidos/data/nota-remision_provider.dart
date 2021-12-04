import 'dart:convert';
// import 'package:concretos2h/src/app/auth_api.dart';
// import 'package:concretos2h/src/app/session.dart';
// import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'models/nota-remision_model.dart';

class PedidosProvider {
  final String _url = 'http://172.19.4.97/C2HApiControlInterno';

  Future<List<NotaRemisionModel>>  obtenerNotasRemision() async {
    try {
        final List<NotaRemisionModel> notasRemision = [];
       final resp = await http.get(Uri.parse('$_url/agentes/notas-remision-auxiliar/20'));
       final Map<String, dynamic> decodedData = json.decode(resp.body);

      List<dynamic> listaNotas = decodedData['data'];

      
      listaNotas.forEach((nota){
        
        // int idNotaRemisionEnc = nota["idNotasRemisionEnc"];

        final notatemp = NotaRemisionModel.fromJson(nota);
        notasRemision.add(notatemp);
      });

    return notasRemision;

    } on PlatformException catch (e) {
      print('ERROR ${e.code} : ${e.message}');
      return [];
    }
  }

}
