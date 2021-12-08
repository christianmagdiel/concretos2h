import 'dart:convert';
// import 'package:concretos2h/src/app/auth_api.dart';
// import 'package:concretos2h/src/app/session.dart';
// import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'models/nota-remision_model.dart';

class PedidosProvider {
  final String _url = 'http://172.19.4.97/C2HApiControlInterno';

  Future<List<NotaRemisionModel>> obtenerNotasRemision() async {
    try {
      final List<NotaRemisionModel> notasRemision = [];
      final resp =
          await http.get(Uri.parse('$_url/agentes/notas-remision-auxiliar/20'));
      final Map<String, dynamic> decodedData = json.decode(resp.body);

      List<dynamic> listaNotas = decodedData['data'];

      listaNotas.forEach((nota) {
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

  Future<String> obtenerPdfNotaRemision() async {
    try {
      final resp = await http.get(
        Uri.parse(
            'http://hector14-001-site5.etempurl.com/dosificador/notaRemision-auxiliar/pdf/4'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhbnNlbG1vb3J0aXpAY29uY3JldG9zMmguY29tIiwiaWRVc3VhcmlvIjoiMyIsImNvZEVtcGxlYWRvIjoiOCIsInVzdWFyaW8iOiJhbnNlbG1vb3J0aXpAY29uY3JldG9zMmguY29tIiwibm9tYnJlIjoiQW5zZWxtbyBPcnRpeiIsImp0aSI6ImQwNGZjOGQxLTIxNjEtNGE1Ny1hYjU0LTE4YzFmZTUzZTgzZiIsImlhdCI6IjA4LzEyLzIwMjEgMTI6MzU6MjEgYS4gbS4iLCJuYmYiOjE2Mzg5MjM3MjEsImV4cCI6MTY3MDAyNzcyMSwiaXNzIjoiaHR0cDovL3d3dy5jb25jcmV0b3MyaC5jb20iLCJhdWQiOiJTaXN0ZW1hIEFnZW50ZXMifQ.8BQN-gkik4sby-E31ldAyB0ltblxBUDfHzZchZkpvFY',
        },
      );
      final Map<String, dynamic> decodedData = json.decode(resp.body);
      final String notaPdfBase64 = decodedData['data'];

      return notaPdfBase64;
    } on PlatformException catch (e) {
      print('ERROR ${e.code} : ${e.message}');
      return "";
    }
  }
}
