import 'package:flutter/material.dart';
import 'package:smartboiler/helpers/statics.dart';

import '../helpers/consts.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 100,
              backgroundImage: NetworkImage(Statics.user?.photoURL ?? ""),
              onBackgroundImageError: (error, stackTrace) {
                // Hata durumunda bir yedek resim gösterebilirsiniz
                print('Resim yükleme hatası: $error');
              },
            ),
            SizedBox(height: 20),
            Text(
              Statics.user?.displayName ?? "-",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            SizedBox(height: 5),
            Text(Statics.user?.email ?? "-"),
          ],
        ),
      ),
    );
  }
}
