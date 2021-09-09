import 'dart:io';
import 'package:Unio/src/models/route_argument.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final RouteArgument routeArgument;
  String url;

  WebViewScreen({Key key, this.routeArgument}) {
    url = this.routeArgument.argumentsList[0];
  }

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Feedback Form'),

        ),
        body: WebView(
          initialUrl:
              'https://docs.google.com/forms/d/e/1FAIpQLSejt1gKNjmIkKZ1L296BScUVDXokw1X6BPgQzcqUnFY2MN5AQ/viewform',
          javascriptMode: JavascriptMode.unrestricted,
        ),
      )
    );
  }
}
