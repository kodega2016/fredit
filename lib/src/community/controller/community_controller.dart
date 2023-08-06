import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fredit/src/auth/controller/auth_controller.dart';
import 'package:fredit/src/community/repository/community_repository.dart';
import 'package:fredit/src/core/constants/app_assets.dart';
import 'package:fredit/src/core/utils.dart';
import 'package:fredit/src/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  return CommunityController(
    repository: ref.watch(communityRepositoryProvider),
    ref: ref,
  );
});

final streamUserCommunitiesProvider = StreamProvider((ref) {
  return ref
      .watch(communityControllerProvider.notifier)
      .streamUserCommunities();
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;

  CommunityController({
    required CommunityRepository repository,
    required Ref ref,
  })  : _communityRepository = repository,
        _ref = ref,
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
}
