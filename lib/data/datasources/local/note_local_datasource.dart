import 'package:hive/hive.dart';
import '../../models/note_model.dart';

abstract class NoteLocalDataSource {
  Future<List<NoteModel>> getNotes();
  Future<NoteModel> getNoteById(String id);
  Future<NoteModel> saveNote(NoteModel note);
  Future<bool> deleteNote(String id);
}

class NoteLocalDataSourceImpl implements NoteLocalDataSource {
  final Box<NoteModel> notesBox;

  NoteLocalDataSourceImpl({required this.notesBox});

  @override
  Future<List<NoteModel>> getNotes() async {
    return notesBox.values.toList();
  }

  @override
  Future<NoteModel> getNoteById(String id) async {
    final note = notesBox.get(id);
    if (note == null) {
      throw Exception('Note not found');
    }
    return note;
  }

  @override
  Future<NoteModel> saveNote(NoteModel note) async {
    await notesBox.put(note.id, note);
    return note;
  }

  @override
  Future<bool> deleteNote(String id) async {
    await notesBox.delete(id);
    return true;
  }
}