import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fredit/src/core/constants/app_assets.dart';
import 'package:fredit/src/auth/controller/auth_controller.dart';
import 'package:fredit/src/themes/pallete.dart';

class SignInButton extends ConsumerWidget {
  const SignInButton({super.key});

  void signInWithGoogle(WidgetRef ref, BuildContext context) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () => signInWithGoogle(ref, context),
      icon: Image.asset(AppAssets.google, height: 30, width: 30),
      label: const Text("Login with Google"),
      style: ElevatedButton.styleFrom(
        foregroundColor: Pallete.whiteColor,
        backgroundColor: Pallete.greyColor,
        minimumSize: const Size(double.infinity, 40),
      ),
    );
  }
}
