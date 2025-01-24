import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiktok_clone/common/widgets/main_navigation/appearance_config.dart';
import 'package:tiktok_clone/common/widgets/video_config/video_config.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = false;

  void _onNotificationChanged(bool? newValue) {
    if (newValue != null) {
      setState(() {
        _notifications = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              value: _notifications,
              onChanged: _onNotificationChanged,
              title: Text("Enable notifications"),
            ),
            Checkbox(value: _notifications, onChanged: _onNotificationChanged),
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
            Switch(value: _notifications, onChanged: _onNotificationChanged),
            CupertinoSwitch(
              value: _notifications,
              onChanged: _onNotificationChanged,
            ),
            // using InheritedWidget + StatefulWidget
            // SwitchListTile.adaptive(
            //   value: VideoConfigData.of(context).autoMute,
            //   onChanged: (value) {
            //     VideoConfigData.of(context).toggleMute();
            //   },
            //   title: Text("Auto mute"),
            //   subtitle: Text("Videos will be muted by default"),
            // ),

            // using ChangeNotifier
            // AnimatedBuilder(
            //   animation: videoConfig,
            //   builder: (context, child) => SwitchListTile.adaptive(
            //     // value: videoConfig.autoMute,
            //     value: videoConfig.value,
            //     onChanged: (value) {
            //       // videoConfig.toggleMute();
            //       videoConfig.value = !videoConfig.value;
            //     },
            //     title: Text("Auto mute"),
            //     subtitle: Text("Videos will be muted by default"),
            //   ),
            // ),

            // using ValueNotifier
            // ValueListenableBuilder(
            //   valueListenable: videoConfig,
            //   builder: (context, value, child) => SwitchListTile.adaptive(
            //     value: videoConfig.value,
            //     onChanged: (value) {
            //       videoConfig.value = !videoConfig.value;
            //     },
            //     title: Text("Auto mute"),
            //     subtitle: Text("Videos will be muted by default"),
            //   ),
            // ),

            // using Provider
            SwitchListTile.adaptive(
              value: context.watch<VideoConfig>().isMuted,
              onChanged: (value) {
                context.read<VideoConfig>().toggleMute();
              },
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
                      onPressed: () => Navigator.of(context).pop(),
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
                      onPressed: () => Navigator.of(context).pop(),
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
