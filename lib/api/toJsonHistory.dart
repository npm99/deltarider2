import 'dart:convert';

List<HistoryDelivery> historyDeliveryFromJson(String str) => List<HistoryDelivery>.from(json.decode(str).map((x) => HistoryDelivery.fromJson(x)));

String historyDeliveryToJson(List<HistoryDelivery> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HistoryDelivery {
  HistoryDelivery({
    this.orderId,
    this.memberId,
    this.priceFood,
    this.title,
    this.address,
    this.comment,
    this.sumPrice,
    this.priceSend,
    this.orderIdRes,
    this.paymentType,
    this.status,
    this.member,
  });

  String orderId;
  String memberId;
  String priceFood;
  String title;
  Address address;
  dynamic comment;
  String sumPrice;
  String priceSend;
  String orderIdRes;
  String paymentType;
  String status;
  Member member;

  factory HistoryDelivery.fromJson(Map<String, dynamic> json) => HistoryDelivery(
    orderId: json["order_id"],
    memberId: json["member_id"],
    priceFood: json["price_food"],
    title: json["title"],
    address: Address.fromJson(json["address"]),
    comment: json["comment"],
    sumPrice: json["sum_price"],
    priceSend: json["price_send"],
    orderIdRes: json["order_id_res"],
    paymentType: json["payment_type"],
    status: json["status"],
    member: Member.fromJson(json["member"]),
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "member_id": memberId,
    "price_food": priceFood,
    "title": title,
    "address": address.toJson(),
    "comment": comment,
    "sum_price": sumPrice,
    "price_send": priceSend,
    "order_id_res": orderIdRes,
    "payment_type": paymentType,
    "status": status,
    "member": member.toJson(),
  };
}

class Address {
  Address({
    this.address,
    this.distance,
    this.duration,
  });

  String address;
  int distance;
  int duration;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    address: json["address"],
    distance: json["distance"],
    duration: json["duration"],
  );

  Map<String, dynamic> toJson() => {
    "address": address,
    "distance": distance,
    "duration": duration,
  };
}

class Member {
  Member({
    this.mmId,
    this.mmName,
    this.picUrl,
    this.userId,
    this.phoneId,
  });

  String mmId;
  String mmName;
  String picUrl;
  String userId;
  String phoneId;

  factory Member.fromJson(Map<String, dynamic> json) => Member(
    mmId: json["mm_id"],
    mmName: json["mm_name"],
    picUrl: json["pic_url"],
    userId: json["userId"],
    phoneId: json["phone_id"],
  );

  Map<String, dynamic> toJson() => {
    "mm_id": mmId,
    "mm_name": mmName,
    "pic_url": picUrl,
    "userId": userId,
    "phone_id": phoneId,
  };
}
