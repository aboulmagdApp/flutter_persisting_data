import 'package:flutter/material.dart';
import '../data/shared_prefs.dart';
import '../models/note.dart';
import '../data/sql_helper.dart';
import 'notes.dart';

class NoteScreen extends StatefulWidget {
  final Note note;
  final bool isNew;

  const NoteScreen({super.key, required this.note, required this.isNew});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  int settingColor = 0xff1976D2;
  double fontSize = 16;
  SPSettings settings = SPSettings();
  SqlHelper helper = SqlHelper();
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtNotes = TextEditingController();
  final TextEditingController txtDate = TextEditingController();

  @override
  void initState() {
    settings.init().then((_) {
      setState(() {
        settingColor = settings.getColor();
        fontSize = settings.getFontSize();
      });
    });
    if (!widget.isNew) {
      txtName.text = widget.note.name;
      txtNotes.text = widget.note.note;
      txtDate.text = widget.note.date;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            widget.isNew ? const Text('Insert Note') : const Text('Edit Note'),
        backgroundColor: Color(settingColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            NoteText(
                description: 'Name', controller: txtName, textSize: fontSize),
            NoteText(
                description: 'Description',
                controller: txtNotes,
                textSize: fontSize),
            NoteText(
                description: 'Date', controller: txtDate, textSize: fontSize),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(settingColor),
        onPressed: () {
          //save Note
          widget.note.name = txtName.text;
          widget.note.note = txtNotes.text;
          widget.note.date = txtDate.text;
          widget.note.position = 0;
          if (widget.isNew) {
            helper.insertNote(widget.note);
          } else {
            helper.updateNote(widget.note);
          }
          Navigator.of(context).pop();
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const NotesScreen()));
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}

class NoteText extends StatelessWidget {
  final String description;
  final TextEditingController controller;
  final double textSize;

  const NoteText(
      {super.key,
      required this.description,
      required this.controller,
      required this.textSize});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: TextField(
        controller: controller,
        style: TextStyle(
          fontSize: textSize,
        ),
        decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: description),
      ),
    );
  }
}
