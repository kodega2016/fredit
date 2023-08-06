import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fredit/src/core/providers/firebase_providers.dart';
import 'package:fredit/src/core/constants/app_assets.dart';
import 'package:fredit/src/core/constants/firebase_constants.dart';
import 'package:fredit/src/core/failure.dart';
import 'package:fredit/src/core/type_defs.dart';
import 'package:fredit/src/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  AuthRepository({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
    required FirebaseFirestore firestore,
  })  : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn,
        _firestore = firestore;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.users);
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final userCredentials = await _firebaseAuth.signInWithCredential(
        credential,
      );

      late UserModel user;

      if (userCredentials.additionalUserInfo!.isNewUser) {
        final firebaseUser = userCredentials.user;
        if (firebaseUser == null) throw Exception("Firebase User is null");
        user = UserModel(
          uid: firebaseUser.uid,
          name: firebaseUser.displayName ?? "Guest",
          profilePic: firebaseUser.photoURL ?? AppAssets.avatarDefault,
          banner: AppAssets.bannerDefault,
          isAuthenticated: false,
          karms: 0,
          awards: [],
        );
        await _users.doc(firebaseUser.uid).set(user.toMap());
      } else {
        final firebaseUser = userCredentials.user;
        if (firebaseUser == null) throw Exception("Firebase User is null");
        final userDoc = await _users.doc(firebaseUser.uid).get();
        final doc = {
          ...userDoc.data()! as Map<String, dynamic>,
          "id": userDoc.id
        };
        user = UserModel.fromMap(doc);
      }
      return right(user);
    } on FirebaseAuthException catch (e) {
      return left(Failure(message: e.toString()));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  Stream<UserModel> getUserData(String id) {
    return _users.doc(id).snapshots().map((event) {
      final doc = {
        ...event.data()! as Map<String, dynamic>,
        "id": event.id,
      };
      return UserModel.fromMap(doc);
    });
  }

  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }
}

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firebaseAuth: ref.read(firebaseAuthProvider),
    googleSignIn: ref.read(googleSignInProvider),
    firestore: ref.read(firestoreProvider),
  ),
);

final authStateChangeProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});
