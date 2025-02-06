import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/common/widgets/main_navigation/appearance_config.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/authentication/sign_up_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Localizations.override(
      locale: Locale("es"),
      context: context,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: ListView(
          children: [
            CloseButton(),
            CupertinoActivityIndicator(
              animating: false,
            ),
            Center(child: CircularProgressIndicator()),
            CircularProgressIndicator.adaptive(),
            ListTile(
              onTap: () => showAboutDialog(context: context),
              title: Text(
                "About",
              ),
            ),
            AboutListTile(),
            ListTile(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1980),
                  lastDate: DateTime(2030),
                );
                if (!context.mounted || date == null) return;
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (!context.mounted || time == null) return;
                await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(1980),
                  lastDate: DateTime(2030),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData(
                        colorScheme: ColorScheme.fromSwatch(
                          cardColor: Colors.white,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
              },
              title: Text(
                "Birthday",
              ),
            ),
            CheckboxListTile(
              checkColor: Colors.white,
              activeColor: Colors.black,
              value: false,
              onChanged: (value) {},
              title: Text("Enable notifications"),
            ),
            Checkbox(
              value: false,
              onChanged: (value) {},
            ),
            AnimatedBuilder(
              animation: appearanceConfig,
              builder: (context, child) {
                return SwitchListTile(
                  title: Text("Turn on dark mode"),
                  value: appearanceConfig.value,
                  onChanged: (_) {
                    appearanceConfig.value = !appearanceConfig.value;
                  },
                );
              },
            ),
            SwitchListTile(
              value: false,
              // value: ref.watch(playbackConfigProvider).isAutoplay,
              onChanged: (value) => {
                // ref.read(playbackConfigProvider.notifier).setAutoplay(value),
              },
              title: Text("Autoplay"),
              subtitle: Text("Videos will autoplay by default"),
            ),
            CupertinoSwitch(
              value: false,
              onChanged: (value) {},
            ),
            SwitchListTile.adaptive(
              value: false,
              onChanged: (value) {},
              // value: ref.watch(playbackConfigProvider).isMuted,
              // onChanged: ref.read(playbackConfigProvider.notifier).setMuted,
              title: Text("Auto mute"),
              subtitle: Text("Videos will be muted by default"),
            ),
            ListTile(
              title: Text("Log out (iOS)"),
              textColor: Colors.red,
              onTap: () => showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: Text("Are you sure?"),
                  content: Text("Plz dont go"),
                  actions: [
                    CupertinoDialogAction(
                      child: Text("cancel"),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    CupertinoDialogAction(
                      isDestructiveAction: true,
                      child: Text("confirm"),
                      onPressed: () {
                        ref.read(authRepo).signOut();
                        context.go(SignUpScreen.routeUrl);
                      },
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: Text("Log out (AOS)"),
              textColor: Colors.red,
              onTap: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Are you sure?"),
                  content: Text("Plz dont go"),
                  actions: [
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.ban),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      child: Text("confirm"),
                      onPressed: () => ref.read(authRepo).signOut(),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: Text("modal (iOS)"),
              textColor: Colors.red,
              onTap: () => showCupertinoModalPopup(
                context: context,
                builder: (context) => CupertinoActionSheet(
                  title: Text("Are you sure?"),
                  message: Text("Plz dont go"),
                  actions: [
                    CupertinoActionSheetAction(
                      child: Text("cancel"),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    CupertinoActionSheetAction(
                      isDestructiveAction: true,
                      child: Text("confirm"),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
