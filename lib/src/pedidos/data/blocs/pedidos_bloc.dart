import 'package:concretos2h/src/pedidos/data/models/nota-remision_model.dart';
import 'package:concretos2h/src/pedidos/data/nota-remision_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:concretos2h/src/principal/data/globales.dart' as global;

class PedidosBloc {
  //VARIABLES
  final _pedidosProvider = new PedidosProvider();
  // List<NotaRemisionModel> ? _notaRemisionController = [];

  //CONTROLADORES
  final _pedidosController = new BehaviorSubject<List<NotaRemisionModel>>();
  final _pdfNotaRemisionController = new BehaviorSubject<String>();
  final _cargandoController = new BehaviorSubject<bool>();

  //STREAMS
  Stream<bool> get isLoadingStream => _cargandoController.stream;
  Stream<List<NotaRemisionModel>> get notasRemisionStream =>
      _pedidosController.stream;

  Stream<String> get userStream => _pdfNotaRemisionController.stream;

  String get pdfBase64 => _pdfNotaRemisionController.value;
  //VARIABLES PUBLICAS PARA MANEJAR EL CONTROLADOR

  bool get cargandoNotasRemision => _cargandoController.value;

  //METODOS
  void cargarNotasRemision() async {
    _cargandoController.sink.add(true);
    final notas = await _pedidosProvider.obtenerNotasRemision();
    _pedidosController.sink.add(notas);
    _cargandoController.sink.add(false);
  }

  Future<Map<String,dynamic>> guardarFirma(var data, int idNotaRemision ) async {
    _cargandoController.sink.add(true);
    Map<String,dynamic> result = await _pedidosProvider.guardarFirmaDigital(data, idNotaRemision);
    _cargandoController.sink.add(false);
    return result;
  }

  Future mostrarPdf(int idNota) async {
    _cargandoController.sink.add(true);
    final nota = await _pedidosProvider.obtenerPdfNotaRemision(idNota);
    global.data64 = nota;
    _cargandoController.sink.add(false);
  }

  dispose() {
    _pedidosController.close();
    _cargandoController.close();
    _pdfNotaRemisionController.close();
  }
}
