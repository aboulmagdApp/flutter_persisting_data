import 'package:flutter/material.dart';
import '../data/sembast_db.dart';
import '../models/password.dart';
import 'passwords.dart';

class PasswordDetailDialog extends StatefulWidget {
  final Password password;
  final bool isNew;

  const PasswordDetailDialog(
      {super.key, required this.password, required this.isNew});

  @override
  State<PasswordDetailDialog> createState() => _PasswordDetailDialogState();
}

class _PasswordDetailDialogState extends State<PasswordDetailDialog> {
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  bool hidePassword = true;
  @override
  Widget build(BuildContext context) {
    String title = (widget.isNew) ? 'Insert new Password' : 'Edit Password';
    txtName.text = widget.password.name;
    txtPassword.text = widget.password.password;
    return AlertDialog(
      title: Text(title),
      content: SizedBox(
        height: 300,
        child: Column(
          children: [
            TextField(
              controller: txtName,
              decoration: const InputDecoration(
                hintText: 'Description',
              ),
            ),
            TextField(
              controller: txtPassword,
              obscureText: hidePassword,
              decoration: InputDecoration(
                  hintText: 'Password',
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                      icon: hidePassword
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off))),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Save'),
          onPressed: () {
            widget.password.name = txtName.text;
            widget.password.password = txtPassword.text;
            SembastDb db = SembastDb();
            (widget.isNew)
                ? db.addPassword(widget.password)
                : db.updatePassword(widget.password);
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const PasswordsScreen()));
          },
        ),
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel')),
      ],
    );
  }
}
