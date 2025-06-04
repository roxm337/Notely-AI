import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/note_detail/note_detail_bloc.dart';
import '../../domain/entities/note.dart';

class NoteDetailPage extends StatefulWidget {
  final String? noteId;

  const NoteDetailPage({Key? key, this.noteId}) : super(key: key);

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  late Note _currentNote;
  bool _isNewNote = true;

  @override
  void initState() {
    super.initState();
    context.read<NoteDetailBloc>().add(LoadNote(id: widget.noteId));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note'),
        actions: [
          BlocBuilder<NoteDetailBloc, NoteDetailState>(
            builder: (context, state) {
              if (state is NoteDetailEditing && !state.isNewNote) {
                return IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    context.read<NoteDetailBloc>().add(
                          DeleteNoteEvent(id: state.note.id),
                        );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: BlocConsumer<NoteDetailBloc, NoteDetailState>(
        listener: (context, state) {
          if (state is NoteDetailEditing) {
            _titleController.text = state.note.title;
            _contentController.text = state.note.content;
            _currentNote = state.note;
            _isNewNote = state.isNewNote;
          } else if (state is NoteDetailSaved || state is NoteDetailDeleted) {
            Navigator.pop(context);
          } else if (state is NoteDetailError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is NoteDetailLoading || state is NoteDetailSaving) {
            return const Center(child: CircularProgressIndicator());
          }
          
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: TextField(
                    controller: _contentController,
                    decoration: const InputDecoration(
                      labelText: 'Content',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    maxLines: null,
                    expands: true,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _saveNote() {
    if (_titleController.text.isEmpty && _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note is empty')),
      );
      return;
    }

    final updatedNote = Note(
      id: _currentNote.id,
      title: _titleController.text,
      content: _contentController.text,
      createdAt: _currentNote.createdAt,
      updatedAt: DateTime.now(),
    );

    context.read<NoteDetailBloc>().add(
          SaveNote(note: updatedNote, isNewNote: _isNewNote),
        );
  }
}