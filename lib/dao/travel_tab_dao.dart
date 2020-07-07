import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_flutter_app/model/search_model.dart';
import 'package:my_flutter_app/model/travel_tab_model.dart';

// 旅拍类别接口
class TravelTabDao {
  static Future<TravelTabModel> fetch() async {
    final response = await http.get('http://www.devio.org/io/flutter_app/json/travel_page.json');
    if (response.statusCode == 200) {
      // fix中文乱码
      Utf8Decoder utf8decoder = Utf8Decoder();
      var result = json.decode(utf8decoder.convert(response.bodyBytes));

      return TravelTabModel.fromJson(result);
    } else {
      throw Exception('Failed to load travel_page.json');
    }
  }
}