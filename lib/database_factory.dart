import 'dart:io';
import 'package:flutter/foundation.dart';
import 'app_database.dart';
import 'database_mobile.dart' if (dart.library.io) 'database_desktop.dart';

Future<AppDatabase> getDatabase() {
  if (kIsWeb) {
    throw UnsupportedError('Web is not supported for this database setup.');
  }

  if (Platform.isAndroid || Platform.isIOS) {
    return getDatabase(); // Calls the mobile database initialization
  } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    return getDatabase(); // Calls the desktop database initialization
  } else {
    throw UnsupportedError('Unsupported platform.');
  }
}
