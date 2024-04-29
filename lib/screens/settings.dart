import 'package:flutter/material.dart';
import 'package:persisting_data/screens/notes.dart';
import '../data/shared_prefs.dart';
import '../models/font_size.dart';
import 'passwords.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int settingsColor = 0xff1976d2;
  double fontSize = 16;
  List<int> colors = [0xFF455A64, 0xFFFFC107, 0xFF673AB7, 0xFF57C00, 0xFF95548];
  SPSettings settings = SPSettings();
  final List<FontSize> fontSizes = [
    FontSize('small', 12),
    FontSize('medium', 16),
    FontSize('large', 20),
    FontSize('extra-large', 24),
  ];

  @override
  void initState() {
    settings.init().then((value) {
      setState(() {
        settingsColor = settings.getColor();
        fontSize = settings.getFontSize();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Color(settingsColor),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueGrey),
              child: Text(
                'GlobApp Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),
            ),
            ListTile(
              title: const Text('Passwords'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const PasswordsScreen()));
              },
            ),
            ListTile(
              title: const Text('Notes'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const NotesScreen()));
              },
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Choose a Font Size for the App',
            style: TextStyle(fontSize: fontSize, color: Color(settingsColor)),
          ),
          DropdownButton(
            items: getDropdownMenu(),
            onChanged: changeSize,
            value: fontSize.toString(),
          ),
          Text('App Main Color',
              style:
                  TextStyle(fontSize: fontSize, color: Color(settingsColor))),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  setColor(colors[0]);
                },
                child: ColorSquare(colorCode: colors[0]),
              ),
              GestureDetector(
                onTap: () {
                  setColor(colors[1]);
                },
                child: ColorSquare(colorCode: colors[1]),
              ),
              GestureDetector(
                onTap: () {
                  setColor(colors[2]);
                },
                child: ColorSquare(colorCode: colors[2]),
              ),
              GestureDetector(
                onTap: () {
                  setColor(colors[3]);
                },
                child: ColorSquare(colorCode: colors[3]),
              ),
              GestureDetector(
                onTap: () {
                  setColor(colors[4]);
                },
                child: ColorSquare(colorCode: colors[4]),
              ),
            ],
          )
        ],
      ),
    );
  }

  void setColor(int color) {
    setState(() {
      settingsColor = color;
      settings.setColor(color);
    });
  }

  List<DropdownMenuItem<String>> getDropdownMenu() {
    List<DropdownMenuItem<String>> items = [];
    for (var fontsize in fontSizes) {
      items.add(DropdownMenuItem(
        value: fontsize.size.toString(),
        child: Text(fontsize.name),
      ));
    }
    return items;
  }

  void changeSize(String? newSize) {
    settings.setFontSize(double.parse(newSize ?? '12'));
    setState(() {
      fontSize = double.parse(newSize ?? '12');
    });
  }
}

class ColorSquare extends StatelessWidget {
  final int colorCode;

  const ColorSquare({super.key, required this.colorCode});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          color: Color(colorCode)),
    );
  }
}
