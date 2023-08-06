import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ),
  );
}

Future<FilePickerResult?> pickImage() async {
  final image = await FilePicker.platform.pickFiles(
    allowMultiple: false,
    type: FileType.image,
  );
  return image;
}
