import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nextkick_admin/data/dependencies/dependencies_injector.dart';
import 'package:nextkick_admin/main/next_kick_admin.dart';

void main() async {
  // await GetStorage.init();
  // final box = GetStorage();

  // await box.erase();
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(NextKickAdmin());

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
}
