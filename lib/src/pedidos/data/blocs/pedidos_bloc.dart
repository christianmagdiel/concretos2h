import 'package:concretos2h/src/pedidos/data/models/nota-remision_model.dart';
import 'package:concretos2h/src/pedidos/data/nota-remision_provider.dart';
import 'package:rxdart/rxdart.dart';

class PedidosBloc {

  //VARIABLES
  final _pedidosProvider = new PedidosProvider();
  // List<NotaRemisionModel> ? _notaRemisionController = [];
 
  //CONTROLADORES
  final _pedidosController = new BehaviorSubject<List<NotaRemisionModel>>();
  final _cargandoController = new BehaviorSubject<bool>();


  //STREAMS
  Stream<List<NotaRemisionModel>> get notasRemisionStream => _pedidosController.stream;


  //VARIABLES PUBLICAS PARA MANEJAR EL CONTROLADOR
  bool get cargandoNotasRemision => _cargandoController.value;

  //METODOS
  void cargarNotasRemision() async {
    _cargandoController.sink.add(true);
    final notas = await _pedidosProvider.obtenerNotasRemision();
    _pedidosController.sink.add(notas);
    // _notaRemisionController = notas;
    _cargandoController.sink.add(false);
  }


  dispose() {
    _pedidosController.close();
    _cargandoController.close();
  }
}
