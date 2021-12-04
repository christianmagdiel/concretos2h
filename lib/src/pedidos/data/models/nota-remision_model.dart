import 'dart:convert';

NotaRemisionModel pedidoFromJson(String str) =>
    NotaRemisionModel.fromJson(json.decode(str));

String pedidoToJson(NotaRemisionModel data) => json.encode(data.toJson());

class NotaRemisionModel {
  int idNotaRemisionEnc;
  int folioNotaRemision;
  int folioCarga;
  String cliente;
  String obra;

  NotaRemisionModel(
      {required this.idNotaRemisionEnc,
      required this.folioNotaRemision,
      required this.folioCarga,
      required this.cliente,
      required this.obra});

  factory NotaRemisionModel.fromJson(Map<String, dynamic> json) =>
      NotaRemisionModel(
        idNotaRemisionEnc: json["idNotasRemisionEnc"],
        folioNotaRemision: json["folioNotaRemision"],
        folioCarga: json["folioCarga"],
        cliente: json["cliente"],
        obra: json["obra"],
      );

  Map<String, dynamic> toJson() => {
        "idNotaRemisionEnc": idNotaRemisionEnc,
        "folioNotaRemision": folioNotaRemision,
        "folioCarga": folioCarga,
        "cliente": cliente,
        "obra": obra,
      };
}
