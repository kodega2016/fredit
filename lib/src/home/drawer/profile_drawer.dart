import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fredit/src/auth/controller/auth_controller.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("u/${user?.name ?? ""}"),
            accountEmail: null,
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(user?.profilePic ?? ""),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text("My Profile"),
            onTap: () {
              ref.read(authControllerProvider.notifier).signOut();
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: const Text("Logout"),
            onTap: () {
              ref.read(authControllerProvider.notifier).signOut();
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Switch.adaptive(
              value: true,
              onChanged: (val) {},
            ),
          ),
        ],
      ),
    );
  }
}
