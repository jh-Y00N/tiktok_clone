import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/common/widgets/main_navigation/main_navigation_screen.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/authentication/sign_up_screen.dart';
import 'package:tiktok_clone/features/inbox/views/activity_screen.dart';
import 'package:tiktok_clone/features/inbox/views/chat_detail_screen.dart';
import 'package:tiktok_clone/features/inbox/views/chats_screen.dart';
import 'package:tiktok_clone/features/onboarding/interests_screen.dart';
import 'package:tiktok_clone/features/videos/views/video_recording_screen.dart';

final routerProvider = Provider((ref) {
  // ref.watch(authState);
  return GoRouter(
    initialLocation: "/home",
    redirect: (context, state) {
      final isLoggedIn = ref.read(authRepo).isLoggedIn;
      if (!isLoggedIn) {
        if (state.matchedLocation != SignUpScreen.routeUrl &&
            state.matchedLocation != LoginScreen.routeUrl) {
          return SignUpScreen.routeUrl;
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        name: SignUpScreen.routeName,
        path: SignUpScreen.routeUrl,
        builder: (context, state) => SignUpScreen(),
      ),
      GoRoute(
        name: LoginScreen.routeName,
        path: LoginScreen.routeUrl,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        name: InterestsScreen.routeName,
        path: InterestsScreen.routeUrl,
        builder: (context, state) => InterestsScreen(),
      ),
      GoRoute(
        name: MainNavigationScreen.routeName,
        path: "/:tab(home|discover|inbox|profile)", // () 안에 있는 문자열만 허용
        builder: (context, state) {
          final tab = state.pathParameters["tab"]!;
          return MainNavigationScreen(
            tab: tab,
          );
        },
      ),
      GoRoute(
        name: ActivityScreen.routeName,
        path: ActivityScreen.routeUrl,
        builder: (context, state) => ActivityScreen(),
      ),
      GoRoute(
        name: ChatsScreen.routeName,
        path: ChatsScreen.routeUrl,
        builder: (context, state) => ChatsScreen(),
        routes: [
          GoRoute(
            path: ChatDetailScreen.routeUrl,
            name: ChatDetailScreen.routeName,
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              final user = extra?["user"];
              final chatId = extra?["chatId"];

              return ChatDetailScreen(
                chatId: chatId,
                user: user,
              );
            },
          ),
        ],
      ),
      GoRoute(
        name: VideoRecordingScreen.routeName,
        path: VideoRecordingScreen.routeUrl,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: VideoRecordingScreen(),
          transitionDuration: Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
            position: Tween(begin: Offset(0, 1), end: Offset(0, 0))
                .animate(animation),
            child: child,
          ),
        ),
      ),
    ],
  );
});
