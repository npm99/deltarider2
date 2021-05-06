import 'dart:convert';

List<Slip> slipFromJson(String str) => List<Slip>.from(json.decode(str).map((x) => Slip.fromJson(x)));

String slipToJson(List<Slip> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Slip {
  Slip({
    this.idSlip,
    this.imgUrl,
    this.amount,
  });

  String idSlip;
  String imgUrl;
  String amount;

  factory Slip.fromJson(Map<String, dynamic> json) => Slip(
    idSlip: json["id_slip"],
    imgUrl: json["img_url"],
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "id_slip": idSlip,
    "img_url": imgUrl,
    "amount": amount,
  };
}
