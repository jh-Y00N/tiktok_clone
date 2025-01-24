import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tiktok_clone/common/widgets/main_navigation/main_config.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/sign_up_screen.dart';
import 'package:tiktok_clone/generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

  runApp(const TikTokApp());
}

class TikTokApp extends StatelessWidget {
  const TikTokApp({super.key});

  @override
  Widget build(BuildContext context) {
    // S.load(Locale("en"));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: appearanceConfig.value ? ThemeMode.dark : ThemeMode.light,
      title: 'TikTok Clone',
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [Locale("en"), Locale("ko")],
      // theme: FlexThemeData.light(scheme: FlexScheme.mandyRed),
      // darkTheme: FlexThemeData.dark(scheme: FlexScheme.mandyRed),
      theme: ThemeData(
        useMaterial3: false,
        splashFactory: NoSplash.splashFactory,
        scaffoldBackgroundColor: Colors.white,
        textSelectionTheme:
            TextSelectionThemeData(cursorColor: Color(0xFFE9435A)),
        primaryColor: const Color(0xFFE9435A),
        // splashColor: Colors.transparent, // 클릭 그라데이션 효과
        highlightColor: Colors.transparent, // 길게 탭
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: Sizes.size16 + Sizes.size2,
            fontWeight: FontWeight.w600,
          ),
        ),
        listTileTheme: ListTileThemeData(iconColor: Colors.black),
        tabBarTheme: TabBarTheme(
          indicatorSize: TabBarIndicatorSize.tab,
          unselectedLabelColor: Colors.grey.shade500,
          indicatorColor: Colors.black,
          labelColor: Colors.black,
        ),
        textTheme: Typography.blackMountainView,
        // bottomAppBarTheme: BottomAppBarTheme(
        //   color: Colors.grey.shade50,
        // ),
      ),
      darkTheme: ThemeData(
        tabBarTheme: TabBarTheme(
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          unselectedLabelColor: Colors.grey.shade700,
          labelColor: Colors.white,
        ),
        bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.grey.shade900,
        ),
        textSelectionTheme:
            TextSelectionThemeData(cursorColor: Color(0xFFE9435A)),
        brightness: Brightness.dark,
        useMaterial3: false,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: const Color(0xFFE9435A),
        // textTheme: GoogleFonts.robotoTextTheme(
        //   ThemeData(brightness: Brightness.dark).textTheme,
        // ),
        textTheme: Typography.whiteMountainView,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade900,
          surfaceTintColor: Colors.grey.shade900,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: Sizes.size16 + Sizes.size2,
            fontWeight: FontWeight.w600,
          ),
          actionsIconTheme: IconThemeData(
            color: Colors.grey.shade100,
          ),
          iconTheme: IconThemeData(
            color: Colors.grey.shade100,
          ),
        ),
      ),
      home: SignUpScreen(),
    );
  }
}
