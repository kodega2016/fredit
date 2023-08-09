import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ModToolsScreen extends StatelessWidget {
  const ModToolsScreen({super.key, required this.name});

  final String name;

  void navigateToEditCommunity(BuildContext context) {
    Routemaster.of(context).push("/edit-community/$name");
  }

  void navigateToAddMod(BuildContext context) {
    Routemaster.of(context).push("/add-mod/$name");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mod Tools"),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.add_moderator_outlined),
            title: const Text("Add Moderators"),
            onTap: () => navigateToAddMod(context),
          ),
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: const Text("Edit Community"),
            onTap: () => navigateToEditCommunity(context),
          ),
        ],
      ),
    );
  }
}
