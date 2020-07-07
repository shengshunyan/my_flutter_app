import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_flutter_app/model/search_model.dart';

// 搜索接口
class SearchDao {
  static Future<SearchModel> fetch(String url, String text) async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      // fix中文乱码
      Utf8Decoder utf8decoder = Utf8Decoder();
      var result = json.decode(utf8decoder.convert(response.bodyBytes));

      // 只有当当前输入的keyword和服务端返回的keyword一致时才渲染
      SearchModel model = SearchModel.fromJson(result);
      model.keyword = text;

      return model;
    } else {
      throw Exception('Failed to load search.json');
    }
  }
}