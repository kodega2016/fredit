import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ModToolsScreen extends StatelessWidget {
  const ModToolsScreen({super.key, required this.name});

  final String name;

  void navigateToEditCommunity(BuildContext context) {
    Routemaster.of(context).push("/edit-community/$name");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mod Tools"),
      ),
      body: Column(
        children: [
          const ListTile(
            leading: Icon(Icons.add_moderator_outlined),
            title: Text("Add Moderators"),
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
