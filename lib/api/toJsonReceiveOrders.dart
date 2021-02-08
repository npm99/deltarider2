import 'dart:convert';

List<ReceiveOrders> receiveOrdersFromJson(String str) => List<ReceiveOrders>.from(json.decode(str).map((x) => ReceiveOrders.fromJson(x)));

String receiveOrdersToJson(List<ReceiveOrders> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReceiveOrders {
  ReceiveOrders({
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

  factory ReceiveOrders.fromJson(Map<String, dynamic> json) => ReceiveOrders(
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

class Station {
  Station({
    this.address,
    this.distance,
    this.duration,
  });

  String address;
  String distance;
  String duration;

  factory Station.fromJson(Map<String, dynamic> json) => Station(
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
