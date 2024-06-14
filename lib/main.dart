import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smartboiler/helpers/statics.dart';
import 'package:smartboiler/views/login_page.dart';

import 'views/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AppWidget());
}

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const title = 'Akıllı Ev';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      home: Statics.user == null ? LoginPage() : HomePage(),
    );
  }
}
