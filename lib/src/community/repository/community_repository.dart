import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fredit/src/auth/providers/firebase_providers.dart';
import 'package:fredit/src/core/constants/firebase_constants.dart';
import 'package:fredit/src/core/failure.dart';
import 'package:fredit/src/core/type_defs.dart';
import 'package:fredit/src/models/community_model.dart';

final communityRepositoryProvider = Provider(
  (ref) => CommunityRepository(
    firebaseFirestore: ref.watch(firestoreProvider),
  ),
);
final streamCommunityByNameProvider = StreamProvider.family(
    (ref, String name) =>
        ref.watch(communityRepositoryProvider).streamCommunityByName(name));

class CommunityRepository {
  final FirebaseFirestore _firestore;

  CommunityRepository({required FirebaseFirestore firebaseFirestore})
      : _firestore = firebaseFirestore;

  CollectionReference get _communities =>
      _firestore.collection(FirebaseConstants.communities);

  FutureVoid createCommunity(
    CommunityModel communityModel,
  ) async {
    try {
      final communityDoc = await _communities.doc(communityModel.docName).get();
      if (communityDoc.exists) {
        throw Exception(
            "community with the name:${communityModel.name} is already exists!.");
      }
      await _communities
          .doc(communityModel.docName)
          .set(communityModel.toMap(), SetOptions(merge: true));
      return right(unit);
    } on FirebaseException catch (e) {
      return left(Failure(message: e.message ?? e.toString()));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  Stream<List<CommunityModel>> streamUserCommunities(String uid) {
    return _communities
        .where('members', arrayContains: uid)
        .snapshots()
        .map((event) => event.docs
            .map((e) => CommunityModel.fromMap({
                  ...e.data() as Map<String, dynamic>,
                  "id": e.id,
                }))
            .toList());
  }

  Stream<CommunityModel> streamCommunityByName(String name) {
    return _communities.doc(name).snapshots().map((event) {
      return CommunityModel.fromMap({
        ...event.data() as Map<String, dynamic>,
        "id": event.id,
      });
    });
  }
}
