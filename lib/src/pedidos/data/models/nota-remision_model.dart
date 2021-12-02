import 'dart:convert';

NotaRemisionModel pedidoFromJson(String str) =>
    NotaRemisionModel.fromJson(json.decode(str));

String pedidoToJson(NotaRemisionModel data) => json.encode(data.toJson());

class NotaRemisionModel {
  int idNotaRemisionEnc;

  NotaRemisionModel({required this.idNotaRemisionEnc});

  factory NotaRemisionModel.fromJson(Map<String, dynamic> json) =>
      NotaRemisionModel(
        idNotaRemisionEnc: json["idNotaRemisionEnc"],
      );

  Map<String, dynamic> toJson() => {"idNotaRemisionEnc": idNotaRemisionEnc};
}
