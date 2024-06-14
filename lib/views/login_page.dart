import 'package:flutter/material.dart';
import 'package:smartboiler/helpers/statics.dart';
import 'package:smartboiler/views/home_page.dart';

import '../helpers/functions/firebase_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                    "Lütfen sisteme giriş yapmak için google hesabınızı doğrulayın"),
              ),
              SizedBox(
                height: 20,
              ),
              Divider(),
              SizedBox(
                height: 20,
              ),
              InkWell(
                  onTap: () async {
                    final value = await FirebaseService.signInWithGoogle();
                    if (value == null) {
                      final snackBar = SnackBar(
                        content: Text('Giriş yapılamadı.'),
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

                    Statics.user = value;

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Image.asset("assets/ic_google.png",
                                    width: 40)),
                            Text("Google ile Giriş Yap",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white))
                          ]))),
            ],
          ),
        ),
      ),
    );
  }
}
