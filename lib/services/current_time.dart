import 'package:intl/intl.dart';

class CurrentTime {
  String getTime() {
    final String formattedDateTime = DateFormat.jm().format(DateTime.now()).toUpperCase();
    return formattedDateTime;
  }
}
