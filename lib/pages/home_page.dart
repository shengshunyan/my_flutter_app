import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:my_flutter_app/dao/home_dao.dart';
import 'package:my_flutter_app/model/common_model.dart';
import 'package:my_flutter_app/model/grid_nav_model.dart';
import 'package:my_flutter_app/model/home_model.dart';
import 'package:my_flutter_app/model/sales_box_model.dart';
import 'package:my_flutter_app/pages/search_page.dart';
import 'package:my_flutter_app/pages/speak_page.dart';
import 'package:my_flutter_app/widget/grid_nav.dart';
import 'package:my_flutter_app/widget/loading_container.dart';
import 'package:my_flutter_app/widget/local_nav.dart';
import 'package:my_flutter_app/widget/sales_box.dart';
import 'package:my_flutter_app/widget/search_bar.dart';
import 'package:my_flutter_app/widget/sub_nav.dart';

const APPBAR_SCROLL_OFFSET = 100;
const SEARCH_BAR_DEFAULT_TEXT = '网红打卡地 景点 酒店 美食';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double appBarAlpha = 0;
  bool _loading = true;
  List<CommonModel> bannerList = [];
  List<CommonModel> localNavList = [];
  GridNavModel gridNavModel;
  List<CommonModel> subNavList = [];
  SalesBoxModel salesBox;

  @override
  void initState() {
    super.initState();
    // 初始加载数据
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        body: LoadingContainer(
            isLoading: _loading,
            child: Stack(
              children: <Widget>[
                // MediaQuery.removePadding用于移除ListView顶部预设的padding(刘海屏头部安全区)
                MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: RefreshIndicator(
                      onRefresh: loadData,
                      child: NotificationListener(
                        onNotification: (scrollNotification) {
                          // ScrollUpdateNotification可以筛掉页面初次加载时候的调用
                          if (scrollNotification is ScrollUpdateNotification &&
                              // depth == 0 是只监听第一层元素ListView的滚动
                              scrollNotification.depth == 0) {
                            // 滚动且是列表滚动的时候
                            _onScroll(scrollNotification.metrics.pixels);
                          }
                          return false;
                        },
                        child: _listView,
                      ),
                    )),
                _appBar,
              ],
            )));
  }

  // home页头部
  Widget get _appBar {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              //AppBar渐变遮罩背景
              colors: [Color(0x66000000), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            height: 80.0,
            decoration: BoxDecoration(
              color: Color.fromARGB((appBarAlpha * 255).toInt(), 255, 255, 255),
            ),
            child: SearchBar(
              searchBarType: appBarAlpha > 0.2
                  ? SearchBarType.homeLight
                  : SearchBarType.home,
              inputBoxClick: _jumpToSearch,
              speakClick: _jumpToSpeak,
              defaultText: SEARCH_BAR_DEFAULT_TEXT,
              leftButtonClick: () {},
            ),
          ),
        ),
        Container(
            height: appBarAlpha > 0.2 ? 0.5 : 0,
            decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 0.5)]))
      ],
    );
  }

  // home页内容列表
  Widget get _listView {
    return ListView(
      children: <Widget>[
        Container(
          height: 160,
          // 来自第三方组件Swiper：https://pub.flutter-io.cn/packages/flutter_swiper
          child: Swiper(
            itemCount: bannerList.length,
            autoplay: true,
            pagination: new SwiperPagination(),
            // control: new SwiperControl(),
            itemBuilder: (BuildContext context, int index) {
              return Image.network(
                bannerList[index].icon,
                fit: BoxFit.fill,
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: LocalNav(localNavList: localNavList),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child: GridNav(gridNavModel: gridNavModel),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child: SubNav(subNavList: subNavList),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child: SalesBox(salesBox: salesBox),
        ),
      ],
    );
  }

  // 监听页面的滚动，动态改变自定义appBar的透明度
  _onScroll(offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
  }

  // 获取数据
  Future<Null> loadData() async {
    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        bannerList = model.bannerList;
        localNavList = model.localNavList;
        gridNavModel = model.gridNav;
        subNavList = model.subNavList;
        salesBox = model.salesBox;
        _loading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _loading = false;
      });
    }

    return null;
  }

  // 跳转到搜索
  void _jumpToSearch() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SearchPage(hint: SEARCH_BAR_DEFAULT_TEXT,);
    }));
  }

  // 跳转到语音
  void _jumpToSpeak() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SpeakPage();
    }));
  }
}
