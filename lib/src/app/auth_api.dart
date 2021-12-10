import 'dart:convert';
import 'package:concretos2h/src/app/session.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:concretos2h/src/principal/data/globales.dart' as global;

class AuthApi {
  final _session = new Session();

  Future<String> getAccessToken() async {
    try {
      final result = await _session.get();

      if (result != null) {
        final token = result['accessToken'] as String;
        final refreshToken = result['refreshToken'] as String;
        final expiresIn = result['expiresIn'] as int;
        final createAt = DateTime.parse(result['createAt']);
        final currentDate = DateTime.now();

        global.usuario = result['nombreUsuario'] as String;
        global.correoUsuario = result['correoUsuario'] as String;
        global.puestoUsuario = result['puestoUsuario'] as String;
        global.codUsuario = result['codUsuario'] as int;

        final diff = currentDate.difference(createAt).inSeconds;

        if ((expiresIn - diff) >= 60) {
          return token;
        }

        final newData = await renovarToken(refreshToken);
        if (newData != null) {
          final newToken = newData['accessToken'];
          final newExpiresIn = newData['expiresIn'];
          final newRefreshToken = newData['refreshToken'];

          await _session.set(
              newToken,
              newRefreshToken,
              newExpiresIn,
              global.codUsuario,
              global.usuario,
              global.correoUsuario,
              global.puestoUsuario);
          return newToken;
        }
        _session.deleteSession();
        return "";
      }
      _session.deleteSession();
      return "";
    } on PlatformException catch (e) {
      print('ERROR ${e.code} : ${e.message}');
      _session.deleteSession();
      return "";
    }
  }

  Future<dynamic> renovarToken(String refreshToken) async {
    try {
      String _token = '';

      final result = await _session.get();
      if (result != null) _token = result['accessToken'] as String;

      final authData = {"refresh_token": '$refreshToken'};
      final resp = await http.post(
          Uri.parse('${global.urlWebApiPruebas}/seguridad/renovar-token/'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_token',
          },
          body: json.encode(authData));

      final decodedResp = json.decode(resp.body);

      if (resp.statusCode == 200) {
        return decodedResp;
      } else {
        return null;
      }
    } catch (e) {
      return {'ok': false, 'mensaje': e};
    }
  }
}
