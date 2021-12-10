import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'models/nota-remision_model.dart';
import 'package:concretos2h/src/app/session.dart';
import 'package:concretos2h/src/principal/data/globales.dart' as global;

class PedidosProvider {
  final _session = new Session();

  Future<List<NotaRemisionModel>> obtenerNotasRemision() async {
    try {
      final List<NotaRemisionModel> notasRemision = [];
      final resp = await http.get(Uri.parse(
          '${global.urlWebApiPruebas}/agentes/notas-remision-auxiliar/${global.codUsuario}'));
      final Map<String, dynamic> decodedData = json.decode(resp.body);

      List<dynamic> listaNotas = decodedData['data'];

      listaNotas.forEach((nota) {
        final notatemp = NotaRemisionModel.fromJson(nota);
        notasRemision.add(notatemp);
      });

      return notasRemision;
    } on PlatformException catch (e) {
      print('ERROR ${e.code} : ${e.message}');
      return [];
    }
  }

  Future<String> obtenerPdfNotaRemision(int idNota) async {
    try {
      String _token = '';

      final result = await _session.get();
      if (result != null) {
        _token = result['accessToken'] as String;
      }

      final resp = await http.get(
        Uri.parse(
            '${global.urlWebApi}/dosificador/notaRemision-auxiliar/pdf/$idNota'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      if(resp.statusCode == 500){
         return "";
      }

      final Map<String, dynamic> decodedData = json.decode(resp.body);
      final String notaPdfBase64 = decodedData['data'];

      return notaPdfBase64;
    } on PlatformException catch (e) {
      print('ERROR ${e.code} : ${e.message}');
      return "";
    }
  }

  Future<Map<String, dynamic>> guardarFirmaDigital(
      var data, int idNotaRemision) async {
    try {
      final firmaData = {
        "idNotaRemisionFirma": "0",
        "idNotaRemisionEnc": idNotaRemision,
        "firmaImagen": data,
        "estatus": "A",
      };
      final resp = await http.post(
          Uri.parse(
              'http://172.19.4.97/C2HApiControlInterno/dosificador/nota-remision-firma/guardar'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhbnNlbG1vb3J0aXpAY29uY3JldG9zMmguY29tIiwiaWRVc3VhcmlvIjoiMyIsImNvZEVtcGxlYWRvIjoiOCIsInVzdWFyaW8iOiJhbnNlbG1vb3J0aXpAY29uY3JldG9zMmguY29tIiwibm9tYnJlIjoiQW5zZWxtbyBPcnRpeiIsImp0aSI6ImJjMGNhZjhiLTc2YTEtNDk0My1iZTYwLWZjNTUwNjE5NDU5OCIsImlhdCI6IjA4LzEyLzIwMjEgMDY6MjA6MjQgcC4gbS4iLCJuYmYiOjE2Mzg5ODc2MjQsImV4cCI6MTY3MDA5MTYyNCwiaXNzIjoiaHR0cDovL3d3dy5jb25jcmV0b3MyaC5jb20iLCJhdWQiOiJTaXN0ZW1hIEFnZW50ZXMifQ.VyaOFeR7QuVQWyzGBC2Ve4klVCgzGIHFnpXvlzKpqfs',
          },
          body: json.encode(firmaData));
      final Map<String, dynamic> decodedResp = json.decode(resp.body);
      if (resp.statusCode == 200 && decodedResp['value']) {
        return {'ok': true, 'mensaje': decodedResp['message']};
      } else {
        return {'ok': false, 'mensaje': decodedResp['message']};
      }
    } on PlatformException catch (e) {
      return {'ok': false, 'mensaje': e.toString()};
    }
  }
}
