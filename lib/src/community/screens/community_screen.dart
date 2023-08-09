import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fredit/src/auth/controller/auth_controller.dart';
import 'package:fredit/src/community/controller/community_controller.dart';
import 'package:fredit/src/community/repository/community_repository.dart';
import 'package:fredit/src/core/widgets/loader.dart';
import 'package:fredit/src/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({
    super.key,
    required this.name,
    required this.docName,
  });

  final String name;
  final String docName;

  void navigateToModTools(BuildContext context) {
    Routemaster.of(context).push("/mod-tools/$name");
  }

  void joinCommunity(
    BuildContext context,
    WidgetRef ref,
    CommunityModel community,
  ) {
    ref
        .read(communityControllerProvider.notifier)
        .joinCommunity(context, community);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final communityStream = ref.watch(streamCommunityByNameProvider(name));
    final user = ref.watch(userProvider);

    return Scaffold(
      body: communityStream.when(
        data: (community) {
          final isMod = community.mods.contains(user?.uid);
          final isMember = community.members.contains(user?.uid);

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 150,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(community.banner),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Align(
                          alignment: Alignment.topLeft,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(community.avatar!),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "r/${community.name}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            Flexible(
                              child: Column(
                                children: [
                                  Text(
                                    "${community.members.length} members",
                                  ),
                                  const SizedBox(height: 10),
                                  isMod
                                      ? OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: Colors.blue,
                                          ),
                                          onPressed: () =>
                                              navigateToModTools(context),
                                          child: const Text("Mod Tools"),
                                        )
                                      : OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: Colors.blue,
                                          ),
                                          onPressed: () {
                                            joinCommunity(
                                              context,
                                              ref,
                                              community,
                                            );
                                          },
                                          child: Text(
                                              isMember ? "Joined" : "Join"),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ];
            },
            body: const Text("Displaying posts"),
          );
        },
        error: (e, s) {
          return Text(e.toString());
        },
        loading: () => const Loader(),
      ),
    );
  }
}
