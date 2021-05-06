import 'package:deltarider2/api/toJsonHistory.dart';
import 'package:deltarider2/api/toJsonHistoryDetail.dart';
import 'package:deltarider2/api/toJsonMessage.dart';
import 'package:deltarider2/config.dart';
import 'package:deltarider2/recieve/send.dart';
import 'package:http/http.dart' as http;

import '../main_order.dart';
import 'toJsonBanking.dart';
import 'order_api.dart';




Future<List<ChatUser>> fetchChat(String memberId) async {
  final res = await http.get('${Config.API_URL}/getUserChatById/$memberId');
  if(res.statusCode != 200){
    print(res.statusCode);
  }
  // print('${Config.API_URL}/getUserChatById/$memberId');
  return chatUserFromJson(res.body);
}

Stream<List<ChatUser>> getChet(String memId) async*{
  // Future.delayed(Duration());
  print('get Message');
  yield await fetchChat(memId);
}

Future<void> loadLocation() async {
  listLocation = await fetchLocation();
  print('load Location');
}

Future<List<Banking>> loadBanking() async{
  String idRes = token['data']['id_res_auto'];
  final res = await http.get('${Config.API_URL}/payment/$idRes');
  if(res.statusCode != 200){
    print(res.statusCode);
  }
  // print('${Config.API_URL}/getUserChatById/$memberId');
  return bankingFromJson(res.body);

}

Future<List<HistoryDelivery>> fetchHistory(String date) async{
  String idRes = token['data']['id_res_auto'];
  String idAmin = token['data']['admin_id'];
  final res = await http.get('${Config.API_URL}/get_history/$idRes/$date/$idAmin');
  if(res.statusCode != 200){
    print(res.statusCode);
  }
  // print('${Config.API_URL}/getUserChatById/$memberId');
  return historyDeliveryFromJson(res.body);

}

Future<HistoryDetail> fetchHistoryDetail(String orderID) async{
  String idRes = token['data']['id_res_auto'];
  final res = await http.get('${Config.API_URL}/get_history_detail/$idRes/$orderID');
  if(res.statusCode != 200){
    print(res.statusCode);
  }
  // print('${Config.API_URL}/getUserChatById/$memberId');
  return historyDetailFromJson(res.body);

}