import 'package:deltarider2/api/toJsonMessage.dart';
import 'package:deltarider2/config.dart';
import 'package:http/http.dart' as http;

import '../main_order.dart';


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

