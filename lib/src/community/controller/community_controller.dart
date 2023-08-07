import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fredit/src/auth/controller/auth_controller.dart';
import 'package:fredit/src/community/repository/community_repository.dart';
import 'package:fredit/src/core/constants/app_assets.dart';
import 'package:fredit/src/core/providers/storage_repository_provider.dart';
import 'package:fredit/src/core/utils.dart';
import 'package:fredit/src/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  return CommunityController(
    repository: ref.watch(communityRepositoryProvider),
    ref: ref,
    storageRepository: ref.watch(storageRepositoryProvider),
  );
});

final streamUserCommunitiesProvider = StreamProvider((ref) {
  return ref
      .watch(communityControllerProvider.notifier)
      .streamUserCommunities();
});
final searchCommunityProvider = StreamProvider.family((ref, String query) =>
    ref.watch(communityControllerProvider.notifier).searchCommunity(query));

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  CommunityController({
    required CommunityRepository repository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _communityRepository = repository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void createCommunity(
    BuildContext context,
    String name,
  ) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? "";

    final community = CommunityModel(
      id: name,
      name: name,
      banner: AppAssets.bannerDefault,
      avatar: AppAssets.avatarDefault,
      members: [uid],
      mods: [uid],
    );
    final errorOrSuccess =
        await _communityRepository.createCommunity(community);
    state = false;
    errorOrSuccess.fold((l) {
      showSnackbar(context, l.message);
    }, (r) {
      showSnackbar(context, "community is created.");
      Routemaster.of(context).pop();
    });
  }

  Stream<List<CommunityModel>> streamUserCommunities() {
    final userID = _ref.read(userProvider)!.uid;
    return _ref.read(communityRepositoryProvider).streamUserCommunities(userID);
  }

  Future<void> editCommunity({
    required BuildContext context,
    required File? bannerFile,
    required File? avatarFile,
    required CommunityModel community,
  }) async {
    state = true;
    if (avatarFile != null) {
      final res = await _storageRepository.storeFile(
        path: "communities/profile",
        id: community.docName,
        file: avatarFile,
      );
      res.fold(
        (l) => showSnackbar(context, l.message),
        (r) => community = community.copyWith(avatar: r),
      );
    }
    if (bannerFile != null) {
      final res = await _storageRepository.storeFile(
        path: "communities/banner",
        id: community.docName,
        file: bannerFile,
      );
      res.fold(
        (l) => showSnackbar(context, l.message),
        (r) => community = community.copyWith(banner: r),
      );
    }

    final res =
        await _ref.read(communityRepositoryProvider).editCommunity(community);

    state = false;

    res.fold(
      (l) => showSnackbar(context, l.message),
      (r) => showSnackbar(context, "community is updated successfully."),
    );
  }

  Stream<List<CommunityModel>> searchCommunity(String query) {
    return _ref.read(communityRepositoryProvider).searchCommunity(query);
  }
}
