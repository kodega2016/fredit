import 'package:flutter/material.dart';
import 'package:fredit/src/auth/screens/login_screen.dart';
import 'package:fredit/src/community/screens/community_screen.dart';
import 'package:fredit/src/community/screens/create_community_screen.dart';
import 'package:fredit/src/community/screens/edit_community_screen.dart';
import 'package:fredit/src/community/screens/mode_tools_screen.dart';
import 'package:fredit/src/home/screens/home_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoutes = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoutes = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  '/create-community': (_) =>
      const MaterialPage(child: CreateCommunityScreen()),
  '/r/:name/:docName': (_) => MaterialPage(
        child: CommunityScreen(
          name: _.pathParameters['name']!,
          docName: _.pathParameters['docName']!,
        ),
      ),
  '/mod-tools/:name': (_) => MaterialPage(
          child: ModToolsScreen(
        name: _.pathParameters['name']!,
      )),
  '/edit-community/:name': (_) => MaterialPage(
          child: EditCommunityScreen(
        name: _.pathParameters['name']!,
      )),
});
