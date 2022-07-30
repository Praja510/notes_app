import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/home/add_edit_notes_screen.dart';
import 'package:notes_app/models/notes.dart';

import '../database/notes_database.dart';

class NotesDetailScreen extends StatefulWidget {
  const NotesDetailScreen({Key? key, required this.noteId}) : super(key: key);

  final int? noteId;

  @override
  State<NotesDetailScreen> createState() => _NotesDetailScreenState();
}

class _NotesDetailScreenState extends State<NotesDetailScreen> {
  late Notes note;
  bool isLoading = false;

  Future refreshNote() async {
    setState(() {
      isLoading = true;
    });
    note = await NoteDatabase.instance.getNote(widget.noteId!);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    refreshNote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          editBtn(),
          deleteBtn(),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(8),
              children: [
                Text(
                  note.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  DateFormat.yMMMd().format(note.createdTime),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  note.description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                )
              ],
            ),
    );
  }

  Widget editBtn() => IconButton(
        onPressed: () async {
          if (isLoading) return;

          final route = MaterialPageRoute(
              builder: (context) => AddEditNotesScreen(notes: note));
          await Navigator.push(context, route);
          refreshNote();
        },
        icon: const Icon(
          Icons.edit_outlined,
        ),
      );

  Widget deleteBtn() => IconButton(
        onPressed: () async {
          await NoteDatabase.instance.delete(widget.noteId!);
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.delete,
        ),
      );
}
