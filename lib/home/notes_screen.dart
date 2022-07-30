import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/database/notes_database.dart';

import '../models/notes.dart';
import '../widgets/card_widget.dart';
import 'add_edit_notes_screen.dart';
import 'notes_detail_screen.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late List<Notes> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  Future refreshNotes() async {
    setState(() {
      isLoading = true;
    });

    notes = await NoteDatabase.instance.getAllNotes();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : notes.isEmpty
                ? const Text("Kosong Bestie",
                    style: TextStyle(color: Colors.white, fontSize: 22))
                : buildNotesView(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final route =
              MaterialPageRoute(builder: (context) => AddEditNotesScreen());
          await Navigator.push(context, route);
          refreshNotes();
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildNotesView() => MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return GestureDetector(
              onTap: () async {
                final route = MaterialPageRoute(
                    builder: (context) => NotesDetailScreen(noteId: note.id));
                await Navigator.push(context, route);
                refreshNotes();
              },
              child: NoteCardWidget(notes: note, index: index));
        },
      );
}
