import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notely_ai/models/note.dart';
import 'package:uuid/uuid.dart';

class NotesProvider with ChangeNotifier {
  late Box<Note> _notesBox;
  final _uuid = const Uuid();
  
  List<Note> _notes = [];
  List<Note> get notes => _notes;

  Future<void> init() async {
    _notesBox = Hive.box<Note>('notes');
    await fetchNotes();
  }

  Future<void> fetchNotes() async {
    try {
      _notes = _notesBox.values.toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching notes: $e');
      _notes = [];
      notifyListeners();
    }
  }

  Future<void> createNote(String title, String content) async {
    try {
      final note = Note(
        id: _uuid.v4(),
        title: title,
        content: content,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _notesBox.put(note.id, note);
      await fetchNotes();
    } catch (e) {
      debugPrint('Error creating note: $e');
      rethrow;
    }
  }

  Future<void> updateNote(Note note) async {
    try {
      final updatedNote = note.copyWith(updatedAt: DateTime.now());
      await _notesBox.put(note.id, updatedNote);
      await fetchNotes();
    } catch (e) {
      debugPrint('Error updating note: $e');
      rethrow;
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await _notesBox.delete(id);
      await fetchNotes();
    } catch (e) {
      debugPrint('Error deleting note: $e');
      rethrow;
    }
  }
} 