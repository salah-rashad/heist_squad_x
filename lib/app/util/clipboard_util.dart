import 'package:clipboard/clipboard.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClipboardUtil {
  static Future<void> copy(String text) {
    return FlutterClipboard.copy(text)
        .then((_) => Fluttertoast.showToast(msg: "Copied!"));
  }

  static Future<String> paste() {
    return FlutterClipboard.paste();
  }
}
