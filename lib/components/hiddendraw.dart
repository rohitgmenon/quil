import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:quil/screens/ide.dart';
import 'package:quil/screens/notelist.dart';
import 'package:quil/screens/recyclebin.dart';
import 'package:quil/screens/settings.dart';
import 'package:quil/screens/tasksrceen.dart';

class Hiddendraw extends StatefulWidget {
  const Hiddendraw({super.key});

  @override
  State<Hiddendraw> createState() => _HiddendrawState();
}

class _HiddendrawState extends State<Hiddendraw> {
  List<ScreenHiddenDrawer> pages = [];
  @override
  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorMenu: Theme.of(context).colorScheme.primary,
      screens: pages = [
        ScreenHiddenDrawer(
          ItemHiddenMenu(
            name: 'Notes',
            baseStyle: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),

            selectedStyle: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            colorLineSelected: Theme.of(context).colorScheme.inversePrimary,
          ),
          Notelist(),
        ),
        ScreenHiddenDrawer(
          ItemHiddenMenu(
            name: 'Tasks',
            baseStyle: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            selectedStyle: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            colorLineSelected: Theme.of(context).colorScheme.inversePrimary,
          ),
          Tasksrceen(),
        ),
        ScreenHiddenDrawer(
          ItemHiddenMenu(
            name: 'Code',
            baseStyle: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            selectedStyle: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            colorLineSelected: Theme.of(context).colorScheme.inversePrimary,
          ),
          Ide(),
        ),
        ScreenHiddenDrawer(
          ItemHiddenMenu(
            name: 'Recycle Bin',
            baseStyle: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            selectedStyle: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            colorLineSelected: Theme.of(context).colorScheme.inversePrimary,
          ),
          Bin(),
        ),
        ScreenHiddenDrawer(
          ItemHiddenMenu(
            name: 'Settings',
            baseStyle: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            selectedStyle: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            colorLineSelected: Theme.of(context).colorScheme.inversePrimary,
          ),
          Settings(),
        ),
      ],
      initPositionSelected: 0,
      disableAppBarDefault: true,
      slidePercent: 55,
      enableScaleAnimation: true,

      contentCornerRadius: 40,
      enableShadowItensMenu: false,
    );
  }
}
