import 'package:flutter/material.dart';
import 'package:notes_app/database/notes_database.dart';
import 'package:notes_app/models/notes.dart';
import 'package:notes_app/widgets/notes_form_widget.dart';

class AddEditNotesScreen extends StatefulWidget {
  const AddEditNotesScreen({Key? key, this.notes}) : super(key: key);

  final Notes? notes;

  @override
  State<AddEditNotesScreen> createState() => _AddEditNotesScreenState();
}

class _AddEditNotesScreenState extends State<AddEditNotesScreen> {
  final _formKey = GlobalKey<FormState>();

  late bool isImportant;
  late int number;
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();
    isImportant = widget.notes?.isImportant ?? false;
    number = widget.notes?.number ?? 0;
    title = widget.notes?.title ?? "";
    description = widget.notes?.description ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          buildButtonSave(),
        ],
      ),
      body: Form(
        key: _formKey,
        child: NotesFormWidget(
            isImportant: isImportant,
            onChangedIsImportant: (value) {
              setState(() {
                isImportant = value;
              });
            },
            number: number,
            onChangedNumber: (value) {
              setState(() {
                number = value;
              });
            },
            title: title,
            onChangeTitle: (value) {
              title = value;
            },
            description: description,
            onChangeDescription: (value) {
              setState(() {
                description = value;
              });
            }),
      ),
    );
  }

  Widget buildButtonSave() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
          onPressed: addOrEditNote,
          style: ElevatedButton.styleFrom(onPrimary: Colors.white),
          child: const Text("Save")),
    );
  }

  void addOrEditNote() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      final isUpdate = widget.notes != null;
      if (isUpdate) {
        await updateNotes();
      } else {
        await addNote();
      }
      Navigator.pop(context);
    }
  }

  Future updateNotes() async {
    final note = widget.notes?.copy(
        title: title,
        isImportant: isImportant,
        number: number,
        description: description,
        createdTime: DateTime.now()
    );
    await NoteDatabase.instance.updateNote(note!);
  }


  Future addNote() async {
    final notes = Notes(
        isImportant: isImportant,
        number: number,
        title: title,
        description: description,
        createdTime: DateTime.now());

    await NoteDatabase.instance.createdNotes(notes);
  }
}
