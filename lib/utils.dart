import 'package:flutter/material.dart';
import 'package:tiktok_clone/common/widgets/main_navigation/main_config.dart';

bool isDarkMode(BuildContext context) =>
    // MediaQuery.of(context).platformBrightness == Brightness.dark;
    appearanceConfig.value;
