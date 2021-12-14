import 'dart:convert';
import 'package:concretos2h/src/app/session.dart';
import 'package:http/http.dart' as http;
import 'package:concretos2h/src/principal/data/globales.dart' as global;

class UsuarioProvider {
  // final String _url = 'http://www.difarmer.com/api/web/';
  final _session = new Session();

  Future<Map<String, dynamic>> login(String user, String password) async {
    try {
      final authData = {"usuario": user, "password": password};
      final resp = await http.post(
          Uri.parse('${global.urlWebApi}/seguridad/login/'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(authData));
      Map<String, dynamic> decodedResp = json.decode(resp.body);
      if (resp.statusCode == 200 && decodedResp['value']) {
        final token =
            decodedResp['data']['accessToken']['accessToken'] as String;
        final refreshToken =
            decodedResp['data']['accessToken']['refreshToken'] as String;
        final expiresIn =
            decodedResp['data']['accessToken']['expiresIn'] as int;
        final usuario = decodedResp['data']['user']['nombre'] as String;
        final correo = decodedResp['data']['user']['usuario'] as String;
        final puesto = decodedResp['data']['user']['tipoEmpleado'] as String;
        final codUsuario = decodedResp['data']['user']['codEmpleado'] as int;

        global.usuario = usuario;
        global.correoUsuario = correo;
        global.puestoUsuario = puesto;
        global.codUsuario = codUsuario;
        
        await _session.set(token, refreshToken, expiresIn, codUsuario, usuario,
            correo, puesto);

        return {'ok': true, 'token': decodedResp['data']['accessToken']};
      } else {
        return {'ok': false, 'mensaje': decodedResp['message']};
      }
    } catch (e) {
      return {'ok': false, 'mensaje': e.toString()};
    }
  }

  Future<Map<String, dynamic>> logout(String user, String password) async {
    try {
      String _token = '';
      final result = await _session.get();
      if (result != null) _token = result['accessToken'] as String;

      final authData = {"usuario": 'a31', "password": '123'};
      final resp = await http.post(
          Uri.parse('${global.urlWebApi}/seguridad/login/'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_token',
          },
          body: json.encode(authData));

      Map<String, dynamic> decodedResp = json.decode(resp.body);

      if (resp.statusCode == 200) {
        _session.deleteSession();

        return {'ok': true, 'token': decodedResp['message']};
      } else {
        return {'ok': false, 'mensaje': decodedResp['message']};
      }
    } catch (e) {
      return {'ok': false, 'mensaje': e};
    }
  }
}
