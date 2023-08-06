import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fredit/src/core/failure.dart';
import 'package:fredit/src/core/providers/firebase_providers.dart';
import 'package:fredit/src/core/type_defs.dart';

final storageRepositoryProvider = Provider(
    (ref) => StorageRepository(storage: ref.watch(firebaseStorageProvider)));

class StorageRepository {
  final FirebaseStorage _storage;
  StorageRepository({required FirebaseStorage storage}) : _storage = storage;

  FutureEither<String> storeFile({
    required String path,
    required String id,
    required File file,
  }) async {
    try {
      final uploadTask = _storage.ref().child(path).child(id).putFile(file);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return right(downloadUrl);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}
