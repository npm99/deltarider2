import 'dart:convert';

List<Orders> ordersFromJson(String str) => List<Orders>.from(json.decode(str).map((x) => Orders.fromJson(x)));

String ordersToJson(List<Orders> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Orders {
  Orders({
    this.orderId,
    this.memberId,
    this.title,
    this.sumPrice,
    this.status,
    this.timeStart,
    this.paymentType,
    this.address,
    this.comment,
    this.orderIdRes,
    this.memberGiveaway,
    this.priceFood,
    this.priceSend,
    this.rider,
    this.slip,
    this.member,
    this.station,
  });

  String orderId;
  String memberId;
  String title;
  String sumPrice;
  String status;
  String timeStart;
  String paymentType;
  Address address;
  String comment;
  String orderIdRes;
  String memberGiveaway;
  String priceFood;
  String priceSend;
  String rider;
  String slip;
  Member member;
  Station station;

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
    orderId: json["order_id"],
    memberId: json["member_id"],
    title: json["title"],
    sumPrice: json["sum_price"],
    status: json["status"],
    timeStart: json["time_start"],
    paymentType: json["payment_type"],
    address: Address.fromJson(json["address"]),
    comment: json["comment"],
    orderIdRes: json["order_id_res"],
    memberGiveaway: json["member_giveaway"],
    priceFood: json["price_food"],
    priceSend: json["price_send"],
    rider: json["rider"],
    slip: json["slip"],
    member: Member.fromJson(json["member"]),
    station: Station.fromJson(json["station"]),
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "member_id": memberId,
    "title": title,
    "sum_price": sumPrice,
    "status": status,
    "time_start": timeStart,
    "payment_type": paymentType,
    "address": address.toJson(),
    "comment": comment,
    "order_id_res": orderIdRes,
    "member_giveaway": memberGiveaway,
    "price_food": priceFood,
    "price_send": priceSend,
    "rider": rider,
    "slip": slip,
    "member": member.toJson(),
    "station": station.toJson(),
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
    this.userId,
    this.phoneId,
    this.picUrl,
  });

  String mmId;
  String mmName;
  String userId;
  String phoneId;
  String picUrl;

  factory Member.fromJson(Map<String, dynamic> json) => Member(
    mmId: json["mm_id"],
    mmName: json["mm_name"],
    userId: json["userId"],
    phoneId: json["phone_id"],
    picUrl: json["pic_url"],
  );

  Map<String, dynamic> toJson() => {
    "mm_id": mmId,
    "mm_name": mmName,
    "userId": userId,
    "phone_id": phoneId,
    "pic_url": picUrl,
  };
}

class Station {
  Station({
    this.address,
    this.distance,
  });

  String address;
  String distance;

  factory Station.fromJson(Map<String, dynamic> json) => Station(
    address: json["address"],
    distance: json["distance"],
  );

  Map<String, dynamic> toJson() => {
    "address": address,
    "distance": distance,
  };
}
