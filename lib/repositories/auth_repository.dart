import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<UserCredential> signUp(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    
    if (credential.user != null) {
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    
    return credential;
  }

  Future<void> updateDisplayName(String name) async {
    await _auth.currentUser?.updateDisplayName(name);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
