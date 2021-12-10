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

      if (resp.statusCode == 200) {
        final Map<String, dynamic> decodedData = json.decode(resp.body);
        if (decodedData['value']) {
          List<dynamic> listaNotas = decodedData['data'];
          listaNotas.forEach((nota) {
            final notatemp = NotaRemisionModel.fromJson(nota);
            notasRemision.add(notatemp);
          });
          return notasRemision;
        } else {
          return [];
        }
      } else {
        return [];
      }
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

      if (resp.statusCode == 200) {
        final Map<String, dynamic> decodedData = json.decode(resp.body);

        if (decodedData['value']) {
          final String notaPdfBase64 = decodedData['data'];

          return notaPdfBase64;
        } else {
          return "";
        }
      } else {
        return "";
      }
    } on PlatformException catch (e) {
      print('ERROR ${e.code} : ${e.message}');
      return "";
    }
  }

  Future<Map<String, dynamic>> guardarFirmaDigital(
      var data, int idNotaRemision) async {
    try {
      String _token = '';

      final result = await _session.get();
      if (result != null) {
        _token = result['accessToken'] as String;
      }
      final firmaData = {
        "idNotaRemisionFirma": "0",
        "idNotaRemisionEnc": idNotaRemision,
        "firmaImagen": data,
        "estatus": "A",
      };
      final resp = await http.post(
          Uri.parse(
              '${global.urlWebApiPruebas}/dosificador/nota-remision-firma/guardar'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_token',
          },
          body: json.encode(firmaData));
      if (resp.statusCode == 200) {
        final Map<String, dynamic> decodedResp = json.decode(resp.body);
        if (decodedResp['value']) {
          return {'ok': true, 'mensaje': decodedResp['message']};
        } else {
          return {'ok': false, 'mensaje': decodedResp['message']};
        }
      } else {
        return {'ok': false, 'mensaje': 'Ocurrio problemas de conexión'};
      }
    } on PlatformException catch (e) {
      return {'ok': false, 'mensaje': e.toString()};
    }
  }
}
