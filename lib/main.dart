import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tiktok_clone/common/widgets/main_navigation/main_config.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/router.dart';

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
    // using gorouter
    return MaterialApp.router(
      routerConfig: router,
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
      theme: ThemeData(
        splashFactory: NoSplash.splashFactory,
        scaffoldBackgroundColor: Colors.white,
        textSelectionTheme:
            TextSelectionThemeData(cursorColor: Color(0xFFE9435A)),
        primaryColor: const Color(0xFFE9435A),
        highlightColor: Colors.transparent,
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
        scaffoldBackgroundColor: Colors.black,
        primaryColor: const Color(0xFFE9435A),
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
    );

// using navigator
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   themeMode: appearanceConfig.value ? ThemeMode.dark : ThemeMode.light,
    //   title: 'TikTok Clone',
    //   localizationsDelegates: [
    //     S.delegate,
    //     GlobalMaterialLocalizations.delegate,
    //     GlobalCupertinoLocalizations.delegate,
    //     GlobalWidgetsLocalizations.delegate,
    //   ],
    //   supportedLocales: [Locale("en"), Locale("ko")],
    //   theme: ThemeData(
    //     splashFactory: NoSplash.splashFactory,
    //     scaffoldBackgroundColor: Colors.white,
    //     textSelectionTheme:
    //         TextSelectionThemeData(cursorColor: Color(0xFFE9435A)),
    //     primaryColor: const Color(0xFFE9435A),
    //     highlightColor: Colors.transparent, // 길게 탭
    //     appBarTheme: const AppBarTheme(
    //       foregroundColor: Colors.black,
    //       backgroundColor: Colors.white,
    //       surfaceTintColor: Colors.white,
    //       elevation: 0,
    //       titleTextStyle: TextStyle(
    //         color: Colors.black,
    //         fontSize: Sizes.size16 + Sizes.size2,
    //         fontWeight: FontWeight.w600,
    //       ),
    //     ),
    //     listTileTheme: ListTileThemeData(iconColor: Colors.black),
    //     tabBarTheme: TabBarTheme(
    //       indicatorSize: TabBarIndicatorSize.tab,
    //       unselectedLabelColor: Colors.grey.shade500,
    //       indicatorColor: Colors.black,
    //       labelColor: Colors.black,
    //     ),
    //     textTheme: Typography.blackMountainView,
    //   ),
    //   darkTheme: ThemeData(
    //     tabBarTheme: TabBarTheme(
    //       indicatorColor: Colors.white,
    //       indicatorSize: TabBarIndicatorSize.tab,
    //       unselectedLabelColor: Colors.grey.shade700,
    //       labelColor: Colors.white,
    //     ),
    //     bottomAppBarTheme: BottomAppBarTheme(
    //       color: Colors.grey.shade900,
    //     ),
    //     textSelectionTheme:
    //         TextSelectionThemeData(cursorColor: Color(0xFFE9435A)),
    //     brightness: Brightness.dark,
    //     scaffoldBackgroundColor: Colors.black,
    //     primaryColor: const Color(0xFFE9435A),
    //     textTheme: Typography.whiteMountainView,
    //     appBarTheme: AppBarTheme(
    //       backgroundColor: Colors.grey.shade900,
    //       surfaceTintColor: Colors.grey.shade900,
    //       titleTextStyle: TextStyle(
    //         color: Colors.white,
    //         fontSize: Sizes.size16 + Sizes.size2,
    //         fontWeight: FontWeight.w600,
    //       ),
    //       actionsIconTheme: IconThemeData(
    //         color: Colors.grey.shade100,
    //       ),
    //       iconTheme: IconThemeData(
    //         color: Colors.grey.shade100,
    //       ),
    //     ),
    //   ),
    //   initialRoute: SignUpScreen.routeName,
    //   routes: {
    //     SignUpScreen.routeName: (context) => SignUpScreen(),
    //     UsernameScreen.routeName: (context) => UsernameScreen(),
    //     LoginScreen.routeName: (context) => LoginScreen(),
    //     EmailScreen.routeName: (context) => EmailScreen(),
    //   },
    // );
  }
}
