import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fredit/src/community/controller/community_controller.dart';
import 'package:fredit/src/core/widgets/loader.dart';
import 'package:fredit/src/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

class SearchCommunityDelegate extends SearchDelegate {
  final WidgetRef _ref;
  SearchCommunityDelegate({required WidgetRef ref}) : _ref = ref;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  void navigateToCommunity(BuildContext context, CommunityModel community) {
    Routemaster.of(context).push("/r/${community.id}/${community.docName}");
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text("Search for a community"),
      );
    }
    return Consumer(
      builder: (context, ref, child) {
        final queryStream = ref.watch(searchCommunityProvider(query));
        return queryStream.when(
          data: (communities) {
            if (communities.isEmpty) {
              return const Center(
                child: Text("No results found"),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: communities.length,
              itemBuilder: (context, index) {
                final community = communities[index];
                return ListTile(
                  title: Text("r/${community.name}"),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(community.avatar!),
                  ),
                  onTap: () {
                    navigateToCommunity(context, community);
                  },
                );
              },
            );
          },
          error: (e, s) => Text(e.toString()),
          loading: () => const Loader(),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _ref.read(searchCommunityProvider(query));
    return Container();
  }
}
