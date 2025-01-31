import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/common/widgets/main_navigation/appearance_config.dart';

bool isDarkMode(BuildContext context) => appearanceConfig.value;

void showFirebaseErrorSnack(BuildContext context, Object? error) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        "Oops! error: ${(error as FirebaseException).message ?? "Something went wrong"}",
      ),
    ),
  );
}
