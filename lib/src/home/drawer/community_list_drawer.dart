import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fredit/src/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.add_outlined),
              title: const Text("Create a community"),
              onTap: () {
                Routemaster.of(context).push("/create-community");
              },
            ),
            ref.watch(streamUserCommunitiesProvider).when(
                  data: (communities) {
                    return Flexible(
                      child: ListView.builder(
                        itemCount: communities.length,
                        itemBuilder: (context, index) {
                          final community = communities[index];
                          return ListTile(
                            title: Text(
                              "r/${community.name}",
                            ),
                            onTap: () {
                              Routemaster.of(context).push(
                                  "/r/${community.id}/${community.docName}");
                            },
                          );
                        },
                      ),
                    );
                  },
                  error: (e, s) => Text(e.toString()),
                  loading: () => const CircularProgressIndicator(),
                ),
          ],
        ),
      ),
    );
  }
}
