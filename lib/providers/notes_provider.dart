import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notely_ai/models/note.dart';
import 'package:uuid/uuid.dart';

class NotesProvider with ChangeNotifier {
  final Box<Note> _notesBox;
  final _uuid = const Uuid();
  
  List<Note> _notes = [];
  List<Note> get notes => _notes;

  NotesProvider(this._notesBox);

  Future<void> init() async {
    await fetchNotes();
  }

  Future<void> fetchNotes() async {
    try {
      debugPrint('Fetching notes from Hive box');
      debugPrint('Hive box keys: ${_notesBox.keys.toList()}');
      _notes = _notesBox.values.toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      debugPrint('Fetched notes: ${_notes.length}');
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
      debugPrint('=== Delete Note Process Start ===');
      debugPrint('Deleting note with ID: $id');
      debugPrint('Current notes in box: ${_notesBox.values.map((n) => n.id).toList()}');
      
      // Verify the note exists before deletion
      if (!_notesBox.containsKey(id)) {
        debugPrint('Error: Note with ID $id not found in box');
        throw Exception('Note not found');
      }
      
      // Delete from Hive
      await _notesBox.delete(id);
      debugPrint('Note deleted from Hive box');
      
      // Force a box flush to ensure changes are persisted
      await _notesBox.flush();
      debugPrint('Hive box flushed');
      
      // Update the local list
      _notes = _notesBox.values.toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      
      debugPrint('Updated local notes list: ${_notes.map((n) => n.id).toList()}');
      
      // Notify listeners
      notifyListeners();
      debugPrint('=== Delete Note Process End ===');
    } catch (e) {
      debugPrint('Error deleting note: $e');
      rethrow;
    }
  }

  Future<void> clearAllNotes() async {
    try {
      debugPrint('=== Clear All Notes Process Start ===');
      debugPrint('Current notes in box: ${_notesBox.values.map((n) => n.id).toList()}');
      
      // Clear the Hive box
      await _notesBox.clear();
      debugPrint('Hive box cleared');
      
      // Clear the local list
      _notes.clear();
      
      // Notify listeners
      notifyListeners();
      debugPrint('=== Clear All Notes Process End ===');
    } catch (e) {
      debugPrint('Error clearing notes: $e');
      rethrow;
    }
  }
} 