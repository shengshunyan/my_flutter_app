import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_flutter_app/model/home_model.dart';

const Home_URL = 'http://www.devio.org/io/flutter_app/json/home_page.json';

// 首页大接口
class HomeDao {
  static Future<HomeModel> fetch() async {
    final response = await http.get(Home_URL);
    if (response.statusCode == 200) {
      // fix中文乱码
      Utf8Decoder utf8decoder = Utf8Decoder();
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      return HomeModel.fromJson(result);
    } else {
      throw Exception('Failed to load home_page.json');
    }
  }
}