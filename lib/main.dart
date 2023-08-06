import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fredit/firebase_options.dart';
import 'package:fredit/router.dart';
import 'package:fredit/src/auth/controller/auth_controller.dart';
import 'package:fredit/src/auth/repository/auth_repository.dart';
import 'package:fredit/src/themes/pallete.dart';
import 'package:routemaster/routemaster.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  void getData(WidgetRef ref, String uid) async {
    final userModel =
        await ref.read(authControllerProvider.notifier).getUserData(uid).first;
    ref.read(userProvider.notifier).update((state) => userModel);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangeProvider);
    final isLoggedIn = user.maybeWhen(
      data: (data) {
        return data != null;
      },
      orElse: () => false,
    );

    return MaterialApp.router(
      title: 'F-Redit',
      theme: Pallete.darkModeAppTheme,
      routerDelegate: RoutemasterDelegate(routesBuilder: (_) {
        if (isLoggedIn) {
          getData(ref, user.value!.uid);
          return loggedInRoutes;
        } else {
          return loggedOutRoutes;
        }
      }),
      routeInformationParser: const RoutemasterParser(),
    );
  }
}
