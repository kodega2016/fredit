import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fredit/src/auth/controller/auth_controller.dart';
import 'package:fredit/src/community/repository/community_repository.dart';

import '../../core/widgets/loader.dart';

class AddModScreen extends ConsumerStatefulWidget {
  const AddModScreen({super.key, required this.name});

  final String name;

  @override
  AddModScreenState createState() => AddModScreenState();
}

class AddModScreenState extends ConsumerState<AddModScreen> {
  Set<String> selectedMods = {};

  void addUid(String uid) {
    selectedMods.add(uid);
  }

  void removeUid(String uid) {
    setState(() {
      selectedMods.remove(uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final communityStream =
        ref.watch(streamCommunityByNameProvider(widget.name));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: communityStream.when(
        data: (community) {
          return ListView.builder(
            itemCount: community.members.length,
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemBuilder: (context, index) {
              final userID = community.members[index];
              final memberStream = ref.watch(getUserDataProvider(userID));
              final isMod = community.mods.contains(userID);

              return memberStream.when(
                data: (member) {
                  if (community.mods.contains(member.uid)) {
                    if (mounted) {
                      addUid(member.uid);
                    }
                  }

                  return CheckboxListTile.adaptive(
                    title: Text(member.name),
                    value: isMod,
                    onChanged: (val) {
                      if (val == true) {
                        addUid(userID);
                      } else {
                        removeUid(userID);
                      }
                    },
                    secondary: CircleAvatar(
                      backgroundImage: NetworkImage(member.profilePic),
                    ),
                  );
                },
                loading: () => const Loader(),
                error: (err, st) {
                  return Text(err.toString());
                },
              );
            },
          );
        },
        error: (err, st) {
          return Text(err.toString());
        },
        loading: () => const CircularProgressIndicator(),
      ),
    );
  }
}
