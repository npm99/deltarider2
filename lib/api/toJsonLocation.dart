import 'dart:convert';

List<Locations> locationsFromJson(String str) => List<Locations>.from(json.decode(str).map((x) => Locations.fromJson(x)));

String locationsToJson(List<Locations> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Locations {
  Locations({
    this.memberId,
    this.memberLatLong,
    this.orderId,
    this.orderIdRes,
    this.sumPrice,
    this.paymentType,
    this.timeStart,
    this.location,
    this.member,
  });

  String memberId;
  String memberLatLong;
  String orderId;
  String orderIdRes;
  String sumPrice;
  String paymentType;
  String timeStart;
  Location location;
  Member member;

  factory Locations.fromJson(Map<String, dynamic> json) => Locations(
    memberId: json["member_id"],
    memberLatLong: json["member_lat_long"],
    orderId: json["order_id"],
    orderIdRes: json["order_id_res"],
    sumPrice: json["sum_price"],
    paymentType: json["payment_type"],
    timeStart: json["time_start"],
    location: Location.fromJson(json["location"]),
    member: Member.fromJson(json["member"]),
  );

  Map<String, dynamic> toJson() => {
    "member_id": memberId,
    "member_lat_long": memberLatLong,
    "order_id": orderId,
    "order_id_res": orderIdRes,
    "sum_price": sumPrice,
    "payment_type": paymentType,
    "time_start": timeStart,
    "location": location.toJson(),
    "member": member.toJson(),
  };
}

class Location {
  Location({
    this.lat,
    this.lng,
  });

  double lat;
  double lng;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    lat: json["lat"].toDouble(),
    lng: json["lng"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lng": lng,
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
