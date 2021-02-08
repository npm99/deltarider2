import 'dart:convert';

List<DetailFood> detailFoodFromJson(String str) =>
    List<DetailFood>.from(json.decode(str).map((x) => DetailFood.fromJson(x)));

String detailFoodToJson(List<DetailFood> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DetailFood {
  DetailFood({
    this.name,
    this.fId,
    this.price,
    this.comment,
    this.count,
    this.totalPrice,
    this.details,
    this.toppings,
  });

  String name;
  String fId;
  String price;
  String comment;
  String count;
  String totalPrice;
  List<DetailFoodDetail> details;
  List<Topping> toppings;

  factory DetailFood.fromJson(Map<String, dynamic> json) =>
      DetailFood(
        name: json["name"],
        fId: json["f_id"],
        price: json["price"],
        comment: json["comment"],
        count: json["count"],
        totalPrice: json["total_price"],
        details: List<DetailFoodDetail>.from(
            json["details"].map((x) => DetailFoodDetail.fromJson(x))),
        toppings: List<Topping>.from(
            json["toppings"].map((x) => Topping.fromJson(x))),
      );

  Map<String, dynamic> toJson() =>
      {
        "name": name,
        "f_id": fId,
        "price": price,
        "comment": comment,
        "count": count,
        "total_price": totalPrice,
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
        "toppings": List<dynamic>.from(toppings.map((x) => x.toJson())),
      };
}

class DetailFoodDetail {
  DetailFoodDetail({
    this.groupId,
    this.name,
    this.detail,
    this.numberMin,
    this.numberMax,
    this.sub,
    this.hashKey,
  });

  int groupId;
  List<NameElement> name;
  List<NameElement> detail;
  int numberMin;
  int numberMax;
  List<Sub> sub;
  String hashKey;

  factory DetailFoodDetail.fromJson(Map<String, dynamic> json) =>
      DetailFoodDetail(
        groupId: json["group_id"],
        name: List<NameElement>.from(
            json["name"].map((x) => NameElement.fromJson(x))),
        detail: List<NameElement>.from(
            json["detail"].map((x) => NameElement.fromJson(x))),
        numberMin: json["number_min"],
        numberMax: json["number_max"],
        sub: List<Sub>.from(json["sub"].map((x) => Sub.fromJson(x))),
        hashKey: json["\u0024\u0024hashKey"],
      );

  Map<String, dynamic> toJson() =>
      {
        "group_id": groupId,
        "name": List<dynamic>.from(name.map((x) => x.toJson())),
        "detail": List<dynamic>.from(detail.map((x) => x.toJson())),
        "number_min": numberMin,
        "number_max": numberMax,
        "sub": List<dynamic>.from(sub.map((x) => x.toJson())),
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

  factory NameElement.fromJson(Map<String, dynamic> json) =>
      NameElement(
        shot: shotValues.map[json["shot"]],
        title: json["title"],
        longText: longTextValues.map[json["long_text"]],
        hashKey: json["\u0024\u0024hashKey"],
      );

  Map<String, dynamic> toJson() =>
      {
        "shot": shotValues.reverse[shot],
        "title": title,
        "long_text": longTextValues.reverse[longText],
        "\u0024\u0024hashKey": hashKey,
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
    this.hashKey,
    this.selected,
  });

  int price;
  List<NameElement> name;
  int sort;
  int id;
  bool showDetail;
  List<NameElement> detail;
  List<dynamic> stock;
  bool defaultVal;
  String hashKey;
  bool selected;

  factory Sub.fromJson(Map<String, dynamic> json) =>
      Sub(
        price: json["price"],
        name: List<NameElement>.from(
            json["name"].map((x) => NameElement.fromJson(x))),
        sort: json["sort"],
        id: json["id"],
        showDetail: json["show_detail"],
        detail: List<NameElement>.from(
            json["detail"].map((x) => NameElement.fromJson(x))),
        stock: List<dynamic>.from(json["stock"].map((x) => x)),
        defaultVal: json["default_val"],
        hashKey: json["\u0024\u0024hashKey"],
        selected: json["selected"],
      );

  Map<String, dynamic> toJson() =>
      {
        "price": price,
        "name": List<dynamic>.from(name.map((x) => x.toJson())),
        "sort": sort,
        "id": id,
        "show_detail": showDetail,
        "detail": List<dynamic>.from(detail.map((x) => x.toJson())),
        "stock": List<dynamic>.from(stock.map((x) => x)),
        "default_val": defaultVal,
        "\u0024\u0024hashKey": hashKey,
        "selected": selected,
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
  String price;
  int count;
  String title;

  factory Topping.fromJson(Map<String, dynamic> json) =>
      Topping(
        tpsId: json["tps_id"],
        price: json["price"],
        count: json["count"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() =>
      {
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
