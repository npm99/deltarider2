import 'dart:convert';

List<Banking> bankingFromJson(String str) => List<Banking>.from(json.decode(str).map((x) => Banking.fromJson(x)));

String bankingToJson(List<Banking> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Banking {
  Banking({
    this.idPayType,
    this.bank,
    this.type,
    this.idResAuto,
    this.status,
    this.del,
    this.type1Options,
    this.type2Options,
    this.sort,
    this.upDate,
    this.acountName,
    this.acountNumber,
  });

  String idPayType;
  String bank;
  String type;
  String idResAuto;
  String status;
  String del;
  Type1Options type1Options;
  String type2Options;
  String sort;
  String upDate;
  String acountName;
  String acountNumber;

  factory Banking.fromJson(Map<String, dynamic> json) => Banking(
    idPayType: json["id_pay_type"],
    bank: json["bank"],
    type: json["type"],
    idResAuto: json["id_res_auto"],
    status: json["status"],
    del: json["del"],
    type1Options: Type1Options.fromJson(json["type1_options"]),
    type2Options: json["type2_options"],
    sort: json["sort"],
    upDate: json["up_date"],
    acountName: json["acount_name"],
    acountNumber: json["acount_number"],
  );

  Map<String, dynamic> toJson() => {
    "id_pay_type": idPayType,
    "bank": bank,
    "type": type,
    "id_res_auto": idResAuto,
    "status": status,
    "del": del,
    "type1_options": type1Options.toJson(),
    "type2_options": type2Options,
    "sort": sort,
    "up_date": upDate,
    "acount_name": acountName,
    "acount_number": acountNumber,
  };
}

class Type1Options {
  Type1Options({
    this.number,
    this.bank,
    this.name,
  });

  String number;
  String bank;
  String name;

  factory Type1Options.fromJson(Map<String, dynamic> json) => Type1Options(
    number: json["number"],
    bank: json["bank"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "number": number,
    "bank": bank,
    "name": name,
  };
}
