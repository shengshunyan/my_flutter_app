import 'package:flutter/material.dart';

// 加载进度组件
class LoadingContainer extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final bool cover;

  const LoadingContainer(
      {Key key,
      @required this.isLoading,
      this.cover = false,
      @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (cover) {
      return Stack(
        children: <Widget>[
          child,
          isLoading ? _loadingView : null
        ],
      );
    }

    if (isLoading) {
      return _loadingView;
    }

    return child;
  }

  Widget get _loadingView {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
