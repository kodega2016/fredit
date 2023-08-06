import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fredit/src/auth/repository/auth_repository.dart';
import 'package:fredit/src/core/utils.dart';
import 'package:fredit/src/models/user_model.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.read(authRepositoryProvider),
    ref: ref,
  ),
);

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({
    required AuthRepository authRepository,
    required Ref ref,
  })  : _authRepository = authRepository,
        _ref = ref,
        super(false);

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogle();
    state = false;
    user.fold((l) {
      showSnackbar(context, l.toString());
    }, (userModel) {
      _ref.read(userProvider.notifier).update(
            (state) => userModel,
          );
    });
  }

  Stream<UserModel> getUserData(String id) {
    return _authRepository.getUserData(id);
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }
}
