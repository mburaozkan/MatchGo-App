import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //giriş yap fonksiyonu
  Future<User?> signIn(String email, String password) async {
    var user = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    await _firestore
        .collection("collection")
        .doc("users")
        .collection("signInUsers")
        .doc(user.user!.uid)
        .set({'email': email, 'password': password});
    return user.user;
  }

  //çıkış yap fonksiyonu
  signOut(User? user) async {
    await _firestore
        .collection("collection")
        .doc("users")
        .collection("signInUsers")
        .doc(user!.uid)
        .delete();
    return await _auth.signOut();
  }

  //kayıt ol fonksiyonu
  Future<User?> createPerson(
      String collection, String userName, String email, String password) async {
    var user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    await _firestore
        .collection("collection")
        .doc("users")
        .collection("signUpUsers")
        .doc(user.user!.uid)
        .set({'userName': userName, 'email': email, 'password': password});

    return user.user;
  }

  getUserName() async {
    String userName = "";
    User? user = FirebaseAuth.instance.currentUser;
    await _firestore
        .collection("collection")
        .doc("users")
        .collection("signUpUsers")
        .doc(user!.uid)
        .get()
        .then((value) {
      var map = value.data() as Map<String, dynamic>;
      return map['userName'];
    });

    return userName;
  }
}
