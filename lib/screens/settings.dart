import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_drawer_menu/controllers/simple_hidden_drawer_controller.dart';
import 'package:provider/provider.dart';
import 'package:quil/screens/setpass.dart';
import 'package:quil/screens/updatescreen.dart';
import 'package:quil/services/securestorage.dart';
import 'package:quil/supabase/auth/authservice.dart';
import 'package:quil/themes/themesprovider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isLocked = false;
  final contrl = TextEditingController();
  Future<void> onlock(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    if (!value) {
      final userpin = await pinStorage.getPin();
      if (userpin == null) return;
      if (!mounted) return;
      contrl.clear();
      final enteredpin = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Enter pin'),
          content: TextField(
            controller: contrl,
            keyboardType: TextInputType.number,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'cancel',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, contrl.text),
              child: Text(
                'ok',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),
          ],
        ),
      );
      if (!mounted) return;
      if (enteredpin == null || enteredpin != userpin) {
        setState(() {
          isLocked = true;
        });
        return;
      }
    }

    if (value) {
      final pin = await pinStorage.getPin();
      if (pin == null) {
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (_) => const Setpass()),
        );
        setState(() {
          isLocked = false;
        });
        return;
      }
    }
    await prefs.setBool('archive_locked', value);
    if (!mounted) return;
    setState(() => isLocked = value);
  }

  @override
  void initState() {
    super.initState();
    _loadLockPref();
  }

  Future<void> _loadLockPref() async {
    final prefs = await SharedPreferences.getInstance();
    final locked = prefs.getBool('archive_locked') ?? false;
    setState(() => isLocked = locked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                SimpleHiddenDrawerController.of(context).toggle();
              },
              icon: Icon(Icons.menu),
            );
          },
        ),

        title: Text(
          'Settings',
          style: GoogleFonts.dmSerifText(
            fontSize: 28,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Card(
              color: Theme.of(context).colorScheme.primary,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    title: Text(
                      "Darkmode",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    trailing: CupertinoSwitch(
                      value: Provider.of<Themesprovider>(
                        context,
                        listen: false,
                      ).isDark,
                      onChanged: (value) => Provider.of<Themesprovider>(
                        context,
                        listen: false,
                      ).toggle(),
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Theme.of(
                      context,
                    ).colorScheme.inversePrimary.withValues(alpha: .12),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    title: Text(
                      "Lock Archive",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    trailing: CupertinoSwitch(
                      value: isLocked,
                      onChanged: (value) => onlock(value),
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Theme.of(
                      context,
                    ).colorScheme.inversePrimary.withValues(alpha: .12),
                  ),
                  Opacity(
                    opacity: isLocked ? 1 : 0.20,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      enabled: isLocked,
                      title: Text(
                        "Update archive pasword",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Updatescreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Theme.of(
                      context,
                    ).colorScheme.inversePrimary.withValues(alpha: .12),
                  ),

                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),

                    title: Text(
                      "Logout",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    onTap: () => logout(),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Theme.of(
                      context,
                    ).colorScheme.inversePrimary.withValues(alpha: .12),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),

                    title: Text(
                      "sync",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    onTap: () => (),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  final auth = Authservice();
  void logout() async {
    await auth.signout();
  }
}
