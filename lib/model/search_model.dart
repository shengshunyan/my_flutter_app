// 搜索model

class SearchModel {
  String keyword;
  final List<SearchItemModel> data;

  SearchModel({this.data});

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    var dataJson = json['data'] as List;
    List<SearchItemModel> data = dataJson.map((i) => SearchItemModel.fromJson((i))).toList();
    return SearchModel(data: data);
  }
}

class SearchItemModel {
  final String word; //xx酒店
  final String type; //hotel
  final String price; //实时计价
  final String star; //豪华型
  final String zonename; //虹桥
  final String districtname; //上海
  final String url;

  SearchItemModel(
      {this.word,
      this.type,
      this.price,
      this.star,
      this.zonename,
      this.districtname,
      this.url});

  factory SearchItemModel.fromJson(Map<String, dynamic> json) {
    return SearchItemModel(
        word: json['word'],
        type: json['type'],
        price: json['price'],
        star: json['star'],
        zonename: json['zonename'],
        districtname: json['districtname'],
        url: json['url'],
    );
  }
}
