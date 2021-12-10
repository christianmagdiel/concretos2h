import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:concretos2h/src/principal/data/providers/usuario_provider.dart';


class LoginBloc {
  final _usuarioProvider = new UsuarioProvider();
  
  final _passwordController = BehaviorSubject<String>();
  final _userController = BehaviorSubject<String>();
  final _isLoadingController = BehaviorSubject<bool>();

  //Recuperar los datos del Stream
  Stream<bool> get isLoadingStream  => _isLoadingController.stream;

  //Obtener el ultimo valor ingresado a los Streams
  String get password => _passwordController.value;
  String get user => _userController.value;

  //Insertar valores al Stream
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeUser => _userController.sink.add;
  
  //Metodos
  Future<Map<String,dynamic>> login(String user ,String password) async{
    _isLoadingController.sink.add(true);
    Map<String, dynamic> resp = await _usuarioProvider.login(user,password);
    _isLoadingController.sink.add(false);
    return resp;
  }

  Future<Map<String,dynamic>> logout(String user ,String password) async{
    Map<String, dynamic> resp = await _usuarioProvider.logout(user,password);
    return resp;
  }

  dispose(){
    _passwordController.close();
    _userController.close();
    _isLoadingController.close();
  }
}