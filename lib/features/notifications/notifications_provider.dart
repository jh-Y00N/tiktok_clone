import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/views/activity_screen.dart';
import 'package:tiktok_clone/features/inbox/views/chats_screen.dart';
import 'package:tiktok_clone/features/videos/views/video_recording_screen.dart';

class NotificationsProvider extends FamilyAsyncNotifier<void, BuildContext> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  @override
  FutureOr<void> build(BuildContext arg) async {
    final token = await _messaging.getToken();
    if (token == null) return;
    await _updateToken(token);
    if (arg.mounted) await initListeners(arg);
    _messaging.onTokenRefresh
        .listen((newToken) async => await _updateToken(newToken));
  }

  Future<void> _updateToken(String token) async {
    final user = ref.read(authRepo).user;
    _db.collection("users").doc(user!.uid).update({"token": token});
  }

  Future<void> initListeners(BuildContext context) async {
    final permission = await _messaging.requestPermission();
    if (permission.authorizationStatus == AuthorizationStatus.denied) {
      return;
    }

    // Foreground
    FirebaseMessaging.onMessage.listen((event) {
      if (context.mounted) context.pushNamed(ChatsScreen.routeName);
    });
    // Background
    FirebaseMessaging.onMessageOpenedApp.listen(
      (event) {
        if (context.mounted) context.pushNamed(VideoRecordingScreen.routeName);
      },
    );
    // Terminated
    final notification = await _messaging.getInitialMessage();
    if (notification != null) {
      if (context.mounted) context.pushNamed(ActivityScreen.routeName);
    }
  }
}

final notificationsProvider = AsyncNotifierProvider.family(
  () => NotificationsProvider(),
);
