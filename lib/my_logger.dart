import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class MyLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) => kDebugMode;
}

final logger = Logger(filter: MyLogFilter(), printer: PrettyPrinter());
