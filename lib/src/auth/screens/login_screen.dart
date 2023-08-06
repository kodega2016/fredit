import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fredit/src/auth/controller/auth_controller.dart';
import 'package:fredit/src/core/constants/app_assets.dart';
import 'package:fredit/src/core/widgets/loader.dart';
import 'package:fredit/src/core/widgets/sing_in_button.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          AppAssets.logo,
          height: 40,
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // FirebaseAuth.instance.signOut();
              ref.read(userProvider.notifier).update((state) => null);
            },
            child: const Text(
              "Skip",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: isLoading
            ? const Loader()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  Center(
                    child: Text(
                      "Dive into the world of F-Redit",
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Image.asset(
                    AppAssets.loginEmote,
                    height: 200,
                  ),
                  const SizedBox(height: 50),
                  const SignInButton(),
                ],
              ),
      ),
    );
  }
}
