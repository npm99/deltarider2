import 'dart:convert';

List<ChatUser> chatUserFromJson(String str) => List<ChatUser>.from(json.decode(str).map((x) => ChatUser.fromJson(x)));

String chatUserToJson(List<ChatUser> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChatUser {
  ChatUser({
    this.idLineChat,
    this.idResAuto,
    this.mmId,
    this.chatText,
    this.byUser,
    this.readChat,
    this.createDate,
  });

  int idLineChat;
  String idResAuto;
  String mmId;
  ChatText chatText;
  String byUser;
  String readChat;
  DateTime createDate;

  factory ChatUser.fromJson(Map<String, dynamic> json) => ChatUser(
    idLineChat: json["id_line_chat"],
    idResAuto: json["id_res_auto"],
    mmId: json["mm_id"],
    chatText: ChatText.fromJson(json["chat_text"]),
    byUser: json["by_user"],
    readChat: json["read_chat"],
    createDate: DateTime.parse(json["create_date"]),
  );

  Map<String, dynamic> toJson() => {
    "id_line_chat": idLineChat,
    "id_res_auto": idResAuto,
    "mm_id": mmId,
    "chat_text": chatText.toJson(),
    "by_user": byUser,
    "read_chat": readChat,
    "create_date": createDate.toIso8601String(),
  };
}

class ChatText {
  ChatText({
    this.type,
    this.id,
    this.text,
    this.message,
    this.address,
    this.latitude,
    this.longitude,
    this.stickerId,
    this.packageId,
    this.stickerResourceType,
    this.keywords,
    this.contentProvider,
    this.url,
  });

  String type;
  String id;
  String text;
  Message message;
  String address;
  double latitude;
  double longitude;
  String stickerId;
  String packageId;
  String stickerResourceType;
  List<String> keywords;
  ContentProvider contentProvider;
  String url;

  factory ChatText.fromJson(Map<String, dynamic> json) => ChatText(
    type: json["type"] == null ? null : json["type"],
    id: json["id"] == null ? null : json["id"],
    text: json["text"] == null ? null : json["text"],
    message: json["message"] == null ? null : Message.fromJson(json["message"]),
    address: json["address"] == null ? null : json["address"],
    latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
    longitude: json["longitude"] == null ? null : json["longitude"].toDouble(),
    stickerId: json["stickerId"] == null ? null : json["stickerId"],
    packageId: json["packageId"] == null ? null : json["packageId"],
    stickerResourceType: json["stickerResourceType"] == null ? null : json["stickerResourceType"],
    keywords: json["keywords"] == null ? null : List<String>.from(json["keywords"].map((x) => x)),
    contentProvider: json["contentProvider"] == null ? null : ContentProvider.fromJson(json["contentProvider"]),
    url: json["url"] == null ? null : json["url"],
  );

  Map<String, dynamic> toJson() => {
    "type": type == null ? null : type,
    "id": id == null ? null : id,
    "text": text == null ? null : text,
    "message": message == null ? null : message.toJson(),
    "address": address == null ? null : address,
    "latitude": latitude == null ? null : latitude,
    "longitude": longitude == null ? null : longitude,
    "stickerId": stickerId == null ? null : stickerId,
    "packageId": packageId == null ? null : packageId,
    "stickerResourceType": stickerResourceType == null ? null : stickerResourceType,
    "keywords": keywords == null ? null : List<dynamic>.from(keywords.map((x) => x)),
    "contentProvider": contentProvider == null ? null : contentProvider.toJson(),
    "url": url == null ? null : url,
  };
}

class ContentProvider {
  ContentProvider({
    this.type,
  });

  String type;

  factory ContentProvider.fromJson(Map<String, dynamic> json) => ContentProvider(
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
  };
}

class Message {
  Message({
    this.type,
    this.id,
    this.text,
  });

  String type;
  String id;
  String text;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    type: json["type"],
    id: json["id"],
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "id": id,
    "text": text,
  };
}
