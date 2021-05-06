import 'dart:convert';

HistoryDetail historyDetailFromJson(String str) => HistoryDetail.fromJson(json.decode(str));

String historyDetailToJson(HistoryDetail data) => json.encode(data.toJson());

class HistoryDetail {
  HistoryDetail({
    this.date,
    this.orderIdRes,
    this.orderId,
    this.data,
    this.sumPrice,
  });

  String date;
  String orderIdRes;
  String orderId;
  List<Datum> data;
  String sumPrice;

  factory HistoryDetail.fromJson(Map<String, dynamic> json) => HistoryDetail(
    date: json["date"],
    orderIdRes: json["order_id_res"],
    orderId: json["order_id"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    sumPrice: json["sum_price"],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "order_id_res": orderIdRes,
    "order_id": orderId,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "sum_price": sumPrice,
  };
}

class Datum {
  Datum({
    this.text,
    this.number,
    this.details,
    this.status,
    this.sum,
    this.toppings,
    this.comment,
  });

  String text;
  String number;
  List<DatumDetail> details;
  String status;
  String sum;
  List<Topping> toppings;
  String comment;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    text: json["text"],
    number: json["number"],
    details: List<DatumDetail>.from(json["details"].map((x) => DatumDetail.fromJson(x))),
    status: json["status"],
    sum: json["sum"],
    toppings: List<Topping>.from(json["toppings"].map((x) => Topping.fromJson(x))),
    comment: json["comment"],
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "number": number,
    "details": List<dynamic>.from(details.map((x) => x.toJson())),
    "status": status,
    "sum": sum,
    "toppings": List<dynamic>.from(toppings.map((x) => x.toJson())),
    "comment": comment,
  };
}

class DatumDetail {
  DatumDetail({
    this.groupId,
    this.name,
    this.detail,
    this.numberMin,
    this.numberMax,
    this.sub,
    this.selectedArray,
    this.hashKey,
  });

  int groupId;
  List<NameElement> name;
  List<NameElement> detail;
  int numberMin;
  int numberMax;
  List<Sub> sub;
  List<int> selectedArray;
  String hashKey;

  factory DatumDetail.fromJson(Map<String, dynamic> json) => DatumDetail(
    groupId: json["group_id"],
    name: List<NameElement>.from(json["name"].map((x) => NameElement.fromJson(x))),
    detail: List<NameElement>.from(json["detail"].map((x) => NameElement.fromJson(x))),
    numberMin: json["number_min"],
    numberMax: json["number_max"],
    sub: List<Sub>.from(json["sub"].map((x) => Sub.fromJson(x))),
    selectedArray: json["selected_array"] == null ? null : List<int>.from(json["selected_array"].map((x) => x)),
    hashKey: json["\u0024\u0024hashKey"],
  );

  Map<String, dynamic> toJson() => {
    "group_id": groupId,
    "name": List<dynamic>.from(name.map((x) => x.toJson())),
    "detail": List<dynamic>.from(detail.map((x) => x.toJson())),
    "number_min": numberMin,
    "number_max": numberMax,
    "sub": List<dynamic>.from(sub.map((x) => x.toJson())),
    "selected_array": selectedArray == null ? null : List<dynamic>.from(selectedArray.map((x) => x)),
    "\u0024\u0024hashKey": hashKey,
  };
}

class NameElement {
  NameElement({
    this.shot,
    this.title,
    this.longText,
    this.hashKey,
  });

  Shot shot;
  String title;
  LongText longText;
  String hashKey;

  factory NameElement.fromJson(Map<String, dynamic> json) => NameElement(
    shot: shotValues.map[json["shot"]],
    title: json["title"],
    longText: longTextValues.map[json["long_text"]],
    hashKey: json["\u0024\u0024hashKey"] == null ? null : json["\u0024\u0024hashKey"],
  );

  Map<String, dynamic> toJson() => {
    "shot": shotValues.reverse[shot],
    "title": title,
    "long_text": longTextValues.reverse[longText],
    "\u0024\u0024hashKey": hashKey == null ? null : hashKey,
  };
}

enum LongText { EMPTY, ENGLISH, LONG_TEXT }

final longTextValues = EnumValues({
  "ภาษาไทย": LongText.EMPTY,
  "English": LongText.ENGLISH,
  "ພາສາລາວ": LongText.LONG_TEXT
});

enum Shot { TH, EN, LA }

final shotValues = EnumValues({
  "en": Shot.EN,
  "la": Shot.LA,
  "th": Shot.TH
});

class Sub {
  Sub({
    this.price,
    this.name,
    this.sort,
    this.id,
    this.showDetail,
    this.detail,
    this.stock,
    this.defaultVal,
    this.selected,
    this.hashKey,
  });

  int price;
  List<NameElement> name;
  int sort;
  int id;
  bool showDetail;
  List<NameElement> detail;
  List<Stock> stock;
  bool defaultVal;
  bool selected;
  String hashKey;

  factory Sub.fromJson(Map<String, dynamic> json) => Sub(
    price: json["price"],
    name: List<NameElement>.from(json["name"].map((x) => NameElement.fromJson(x))),
    sort: json["sort"],
    id: json["id"],
    showDetail: json["show_detail"],
    detail: List<NameElement>.from(json["detail"].map((x) => NameElement.fromJson(x))),
    stock: List<Stock>.from(json["stock"].map((x) => Stock.fromJson(x))),
    defaultVal: json["default_val"],
    selected: json["selected"],
    hashKey: json["\u0024\u0024hashKey"] == null ? null : json["\u0024\u0024hashKey"],
  );

  Map<String, dynamic> toJson() => {
    "price": price,
    "name": List<dynamic>.from(name.map((x) => x.toJson())),
    "sort": sort,
    "id": id,
    "show_detail": showDetail,
    "detail": List<dynamic>.from(detail.map((x) => x.toJson())),
    "stock": List<dynamic>.from(stock.map((x) => x.toJson())),
    "default_val": defaultVal,
    "selected": selected,
    "\u0024\u0024hashKey": hashKey == null ? null : hashKey,
  };
}

class Stock {
  Stock({
    this.fId,
    this.number,
    this.name,
    this.unitSaleText,
  });

  String fId;
  int number;
  String name;
  String unitSaleText;

  factory Stock.fromJson(Map<String, dynamic> json) => Stock(
    fId: json["f_id"],
    number: json["number"],
    name: json["name"],
    unitSaleText: json["unit_sale_text"],
  );

  Map<String, dynamic> toJson() => {
    "f_id": fId,
    "number": number,
    "name": name,
    "unit_sale_text": unitSaleText,
  };
}

class Topping {
  Topping({
    this.tpsId,
    this.price,
    this.count,
    this.title,
  });

  String tpsId;
  dynamic price;
  int count;
  String title;

  factory Topping.fromJson(Map<String, dynamic> json) => Topping(
    tpsId: json["tps_id"],
    price: json["price"],
    count: json["count"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "tps_id": tpsId,
    "price": price,
    "count": count,
    "title": title,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
