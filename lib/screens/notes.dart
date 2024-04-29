import 'package:flutter/material.dart';
import '../data/shared_prefs.dart';
import '../models/note.dart';
import '../data/sql_helper.dart';
import './note.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});
  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  int settingColor = 0xff1976d2;
  double fontSize = 16;
  SPSettings settings = SPSettings();
  SqlHelper sqlHelper = SqlHelper();

  @override
  void initState() {
    sqlHelper = SqlHelper();
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
        title: const Text('Notes'),
        backgroundColor: Color(settingColor),
      ),
      body: FutureBuilder(
        future: getNotes(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          // List<Note> notes =
          //     snapshot.data == null ? [] : snapshot.data as List<Note>;
          List<Note> notes = snapshot.data ?? [];
          if (notes.isEmpty) {
            return Container();
          } else {
            return ReorderableListView(
              onReorder: (oldIndex, newIndex) async {},
              children: [
                for (final note in notes)
                  Dismissible(
                      key: Key(note.id.toString()),
                      onDismissed: (direction) {
                        sqlHelper.deleteNote(note);
                      },
                      child: Card(
                        key: ValueKey(note.position),
                        child: ListTile(
                          title: Text(note.name),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    NoteScreen(note: note, isNew: false)));
                          },
                        ),
                      ))
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(settingColor),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  NoteScreen(note: Note('', '', '', 1), isNew: true)));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<List<Note>> getNotes() async {
    List<Note> notes = await sqlHelper.getNotes();
    return notes;
  }
}
