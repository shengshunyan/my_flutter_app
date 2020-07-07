import 'package:flutter/material.dart';
import 'package:my_flutter_app/navigator/tab_navigator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'demo', home: TabNavigator());
  }
}
