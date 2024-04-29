import 'package:flutter/material.dart';
import '../data/shared_prefs.dart';
import './password_detail.dart';
import '../data/sembast_db.dart';
import '../models/password.dart';

class PasswordsScreen extends StatefulWidget {
  const PasswordsScreen({super.key});

  @override
  State<PasswordsScreen> createState() => _PasswordsScreenState();
}

class _PasswordsScreenState extends State<PasswordsScreen> {
  SembastDb? db;
  int settingColor = 0xff1976d2;
  double fontSize = 16;
  SPSettings settings = SPSettings();

  @override
  void initState() {
    db = SembastDb();
    settings.init().then((value) {
      setState(() {
        settingColor = settings.getColor();
        fontSize = settings.getFontSize();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passwords List'),
        backgroundColor: Color(settingColor),
      ),
      body: FutureBuilder(
        future: getPasswords(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          List<Password> passwords = snapshot.data ?? [];
          return ListView.builder(
            itemCount: passwords.length,
            itemBuilder: (_, index) {
              return Dismissible(
                  key: Key(passwords[index].id.toString()),
                  onDismissed: (_) {
                    db?.deletePassword(passwords[index]);
                  },
                  child: ListTile(
                    title: Text(
                      passwords[index].name,
                      style: TextStyle(fontSize: fontSize),
                    ),
                    trailing: const Icon(Icons.edit),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return PasswordDetailDialog(
                                password: passwords[index], isNew: false);
                          });
                    },
                  ));
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(settingColor),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return PasswordDetailDialog(
                  password: Password('', ''),
                  isNew: true,
                );
                // return PasswordDetailDialog(Password('', ''), true);
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<List<Password>> getPasswords() async {
    List<Password> passwords = await db?.getPasswords();
    return passwords;
  }
}
