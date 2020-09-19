import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_web_browser/flutter_web_browser.dart';

class NetworkHelper {
  NetworkHelper(this.url);

  final String url;

  Future getData() async {
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }

  void openBrowserTab() async {
    try {
      await FlutterWebBrowser.openWebPage(
        url: url,
      );
    } catch (e) {
      print('error form openBrowserTab: $e');
    }
  }
}
