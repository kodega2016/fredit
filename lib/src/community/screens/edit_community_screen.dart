import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fredit/src/community/controller/community_controller.dart';
import 'package:fredit/src/community/repository/community_repository.dart';
import 'package:fredit/src/core/utils.dart';
import 'package:fredit/src/core/widgets/loader.dart';
import 'package:fredit/src/models/community_model.dart';
import 'package:fredit/src/themes/pallete.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  const EditCommunityScreen({super.key, required this.name});
  final String name;

  @override
  EditCommunityScreenState createState() => EditCommunityScreenState();
}

class EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerFile;

  void selectBannerImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.image,
      );

      if (result != null) {
        bannerFile = File(result.files.single.path!);
        setState(() {});
      }
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  void save(CommunityModel community) async {
    await ref.read(communityControllerProvider.notifier).editCommunity(
          context: context,
          bannerFile: bannerFile,
          avatarFile: null,
          community: community,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);

    return ref.watch(streamCommunityByNameProvider(widget.name)).when(
          data: (community) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Edit Community"),
                actions: [
                  TextButton(
                    onPressed: () => save(community),
                    child: const Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: isLoading
                    ? const Loader()
                    : Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () async => selectBannerImage(),
                                  child: DottedBorder(
                                    radius: const Radius.circular(8),
                                    borderType: BorderType.RRect,
                                    color: Pallete.whiteColor,
                                    child: Container(
                                      height: 150,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: bannerFile != null
                                          ? Image.file(
                                              bannerFile!,
                                              fit: BoxFit.cover,
                                            )
                                          : (community.banner.isEmpty
                                              ? const Icon(
                                                  Ionicons.image_outline,
                                                  size: 40,
                                                )
                                              : Image.network(
                                                  community.banner,
                                                  fit: BoxFit.cover,
                                                )),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 28,
                                  left: 28,
                                  child: CircleAvatar(
                                    radius: 32,
                                    backgroundImage: NetworkImage(
                                      community.avatar!,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            );
          },
          error: (e, s) => Text(e.toString()),
          loading: () => const CircularProgressIndicator(),
        );
  }
}
