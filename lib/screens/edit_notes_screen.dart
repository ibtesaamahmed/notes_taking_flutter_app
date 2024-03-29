import 'package:flutter/material.dart';
import 'package:notes_app/provider/notes.dart';
import 'package:provider/provider.dart';

class EditNotesScreen extends StatefulWidget {
  final int existingIndex;
  final String existingId;
  const EditNotesScreen(this.existingIndex, this.existingId, {super.key});
  @override
  State<EditNotesScreen> createState() => _EditNotesScreenState();
}

class _EditNotesScreenState extends State<EditNotesScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) => _getText());
    super.initState();
  }

  Future<void> _getText() async {
    final notesSData = Provider.of<Notes>(context, listen: false);
    _titleController.text = notesSData.notes[widget.existingIndex].title;
    _descriptionController.text =
        notesSData.notes[widget.existingIndex].description;
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(
                'An Error Occured',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              content: Text(
                message,
                style: const TextStyle(color: Colors.black),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    )),
              ],
            ));
  }

  var _isLoading = false;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final notesData = Provider.of<Notes>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
        actions: [
          IconButton(
              onPressed: () async {
                final Note newNote;
                if (_titleController.text.isEmpty ||
                    _descriptionController.text.isEmpty) {
                  _showErrorDialog('Empty Fields');
                  return;
                } else {
                  setState(() {
                    _isLoading = true;
                  });
                  newNote = Note(
                      id: notesData.notes[widget.existingIndex].id,
                      title: _titleController.text,
                      description: _descriptionController.text,
                      dateTime: DateTime.now());
                  await notesData.updateNotes(newNote, widget.existingId);
                }
                setState(() {
                  _isLoading = false;
                });
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.done))
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            )
          : SingleChildScrollView(
              child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Title',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: TextField(
                      controller: _descriptionController,
                      maxLines: 28,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            )),
    );
  }
}
