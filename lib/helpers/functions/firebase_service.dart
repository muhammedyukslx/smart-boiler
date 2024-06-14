import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
  static init() async {
    await Firebase.initializeApp();
  }

  static Future<User?> signInWithGoogle() async {
    User? user;
    final fireBaseAuth = FirebaseAuth.instance;
    //Oturum açma işlemi başlatlır.
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    if (gUser == null) {
      return user;
    }

    ///Başlattığın süreç içerisinden bilgileri alınır.
    final GoogleSignInAuthentication gAuth = await gUser.authentication;

    /// Kullanıcı nesnesini oluşturulur.
    final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken, idToken: gAuth.idToken);
    await fireBaseAuth.signInWithCredential(credential).then((value) {
      user = value.user;
    });
    return user;
  }
}
