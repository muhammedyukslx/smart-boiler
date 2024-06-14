import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smartboiler/helpers/statics.dart';
import 'package:smartboiler/views/login_page.dart';
import 'package:smartboiler/views/profil_page.dart';
import 'package:smartboiler/views/weather_page.dart';

import '../helpers/consts.dart';
import '../helpers/functions/weather_service.dart';
import '../helpers/widgets/slider_widget.dart';
import '../models/weather_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<WeatherModel> _weathers = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const homeTitle = 'Akıllı Kombi';
    const homesubTitle = 'Kombi Sıcaklık Ayarı';
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      drawer: _menu(homeTitle, context),
      appBar: _appBarr(),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  homeTitle,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 26),
                ),
                Text(
                  homesubTitle,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            Expanded(
              child: SliderWidget(),
            ),
            StreamBuilder(
              stream: FirebaseDatabase.instance.ref("kombiYaniyor").onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (snapshot.hasData &&
                    !snapshot.hasError &&
                    snapshot.data!.snapshot.value != null) {
                  var kombiYaniyor =
                      int.parse(snapshot.data!.snapshot.value.toString());
                  return Text(
                    kombiYaniyor == 1 ? "Kombi Yanıyor..." : '',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontStyle: FontStyle.italic),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [_getWetInfo(), _getTempInfo()],
            ),
            const SizedBox(
              height: 35,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WeatherPage()),
                    );
                  },
                  child: Text(
                    'Hava Durumu',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  style: ButtonStyle(
                    elevation: WidgetStateProperty.all(0),
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                _kombiDurum(context),
                const SizedBox(
                  width: 10,
                ),
                _sistemAcKapa(context),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBarr() {
    return AppBar(
      title: Text(Statics.user?.displayName ?? ""),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(
            Icons.login,
            color: Colors.blue,
          ),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            await GoogleSignIn().signOut();
            Statics.user = null;
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        )
      ],
    );
  }

  Drawer _menu(String homeTitle, BuildContext context) {
    return Drawer(
      backgroundColor: kScaffoldBackgroundColor,
      child: ListView(
        children: [
          DrawerHeader(
            child: Center(
                child: Text(
              homeTitle,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold),
            )),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profil'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Ayarlar'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.logout_outlined),
            title: Text('Çıkış Yap'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              await GoogleSignIn().signOut();
              Statics.user = null;

              Navigator.pop(context);
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  ElevatedButton _kombiDurum(BuildContext context) {
    int kombiYaniyor = 0;
    return ElevatedButton(
      onPressed: () async {
        var manuelAteslemeAktif =
            await FirebaseDatabase.instance.ref("manuelAteslemeAktif").get();
        if (kombiYaniyor == 0) {
          var sistemAcik =
              await FirebaseDatabase.instance.ref("sistemAcik").get();

          if (sistemAcik.value == 0) {
            final snackBar = SnackBar(
              content: Text('Sistem kapalı ateşleme için açınız.'),
              action: SnackBarAction(
                label: 'Tamam',
                onPressed: () {
                  // SnackBar aksiyonuna tıklanınca yapılacak işlemler
                },
              ),
            );

            // SnackBar'ı göster
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            return;
          }
        }

        if (manuelAteslemeAktif.value == 0 && kombiYaniyor == 1) {
          final snackBar = SnackBar(
            content: Text(
                'Kombi otomatik tetiklenmiş.\nDurdurmak için sistemi kapatınız.'),
            action: SnackBarAction(
              label: 'Tamam',
              onPressed: () {
                // SnackBar aksiyonuna tıklanınca yapılacak işlemler
              },
            ),
          );

          // SnackBar'ı göster
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return;
        }
        DatabaseReference ref = FirebaseDatabase.instance.ref();
        await ref.update({"manuelAteslemeAktif": kombiYaniyor == 0 ? 1 : 0});

        await ref.update({"kombiYaniyor": kombiYaniyor == 0 ? 1 : 0});
      },
      child: StreamBuilder(
        stream: FirebaseDatabase.instance.ref("kombiYaniyor").onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasData &&
              !snapshot.hasError &&
              snapshot.data!.snapshot.value != null) {
            kombiYaniyor = int.parse(snapshot.data!.snapshot.value.toString());
            return Text(
              kombiYaniyor == 0 ? "Ateşle" : 'Durdur',
              style: TextStyle(color: Colors.black, fontSize: 16),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      style: ButtonStyle(
        elevation: WidgetStateProperty.all(0),
        backgroundColor: WidgetStateProperty.all(Colors.white),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        ),
      ),
    );
  }

  _sistemAcKapa(BuildContext context) {
    int sistemAcik = 0;
    return ElevatedButton(
      onPressed: () async {
        if (sistemAcik == 1) {
          DatabaseReference ref = FirebaseDatabase.instance.ref();
          await ref.update({"kombiYaniyor": 0});
        }
        DatabaseReference ref = FirebaseDatabase.instance.ref();
        await ref.update({"sistemAcik": sistemAcik == 0 ? 1 : 0});
      },
      child: StreamBuilder(
        stream: FirebaseDatabase.instance.ref("sistemAcik").onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasData &&
              !snapshot.hasError &&
              snapshot.data!.snapshot.value != null) {
            sistemAcik = int.parse(snapshot.data!.snapshot.value.toString());
            return Text(
              sistemAcik == 0 ? "Aç" : 'Kapat',
              style: TextStyle(color: Colors.black, fontSize: 16),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      style: ButtonStyle(
        elevation: WidgetStateProperty.all(0),
        backgroundColor: WidgetStateProperty.all(Colors.white),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        ),
      ),
    );
  }

  _getTempInfo() {
    return StreamBuilder(
      stream: FirebaseDatabase.instance.ref("odaSicaklik").onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.hasData &&
            !snapshot.hasError &&
            snapshot.data!.snapshot.value != null) {
          final double currentTemp =
              double.parse(snapshot.data!.snapshot.value.toString());
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Odanın Sıcaklığı.',
                style: TextStyle(
                  color: Colors.grey.withAlpha(150),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                currentTemp.toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  _getWetInfo() {
    return StreamBuilder(
      stream: FirebaseDatabase.instance.ref("odaNem").onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.hasData &&
            !snapshot.hasError &&
            snapshot.data!.snapshot.value != null) {
          final double currentWet =
              double.parse(snapshot.data!.snapshot.value.toString());
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Odanın Nemi',
                style: TextStyle(
                  color: Colors.grey.withAlpha(150),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                currentWet.toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
