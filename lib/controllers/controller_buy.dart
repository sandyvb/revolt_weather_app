import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:get/get.dart';
import 'controller_revolt.dart';

class ControllerBuy extends GetxController {
  final ControllerRevolt cr = Get.put(ControllerRevolt());
  final _webView = FlutterWebviewPlugin();

  @override
  void onClose() {
    _webView.dispose();
    super.onClose();
  }
}
