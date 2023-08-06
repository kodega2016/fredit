import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fredit/src/community/controller/community_controller.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  CreateCommunityScreenState createState() => CreateCommunityScreenState();
}

class CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final nameController = TextEditingController();
  String get name => nameController.text.trim();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void createCommunity() {
    ref
        .read(communityControllerProvider.notifier)
        .createCommunity(context, name);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Community"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 6,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Community name",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            TextField(
              enabled: !isLoading,
              controller: nameController,
              maxLength: 40,
              decoration: const InputDecoration(
                hintText: "r/Community_name",
                filled: true,
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: createCommunity,
              label: const Text("Create community"),
              icon: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
