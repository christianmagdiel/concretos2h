
import 'package:concretos2h/src/app/session.dart';
import 'package:flutter/services.dart';


class AuthApi {
  final _session = new Session();
  final String url = 'http://www.difarmer.com/api/web/';

  Future<String> getAccessToken() async {
    try {
      final result = await _session.get();

      if (result != null) {
        final token = result['accessToken'] as String;
        final refreshToken = result['refreshToken'] as String;
        final expiresIn = result['expiresIn'] as int;
        final createAt = DateTime.parse(result['createAt']);
        final currentDate = DateTime.now();

        final diff = currentDate.difference(createAt).inSeconds;

        if ((expiresIn - diff) >= 60) {
          return token;
        }

        final newData = await renovarToken(refreshToken);
        if (newData != null) {
          final newToken = newData['accessToken'];
          final newExpiresIn = newData['expiresIn'];
          final newRefreshToken = newData['refreshToken'];

          await _session.set(newToken, newRefreshToken, newExpiresIn);
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
    // try {
    //   String _token = '';

    //   final result = await _session.get();
    //   if (result != null) _token = result['accessToken'] as String;

    //   final authData = {"refresh_token": '$refreshToken'};
    //   final resp = await http.post('$url/seguridad/renovar-token/',
    //       headers: {
    //         'Content-Type': 'application/json',
    //         'Authorization': 'Bearer $_token',
    //       },
    //       body: json.encode(authData));

    //   final decodedResp = json.decode(resp.body);

    //   if (resp.statusCode == 200) {
    //     return decodedResp;
    //   } else {
    //     return null;
    //   }
    // } catch (e) {
    //   return {'ok': false, 'mensaje': e};
    // }
  }
}
