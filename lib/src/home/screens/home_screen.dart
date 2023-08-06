import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fredit/src/auth/controller/auth_controller.dart';
import 'package:fredit/src/home/drawer/community_list_drawer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Scaffold(
      drawer: const CommunityListDrawer(),
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Ionicons.menu_outline),
          );
        }),
        title: const Text("Home"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(AntDesign.search1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 12,
            ),
            child: CircleAvatar(
              backgroundImage:
                  user != null ? NetworkImage(user.profilePic) : null,
            ),
          ),
        ],
      ),
    );
  }
}
