import 'package:dartz/dartz.dart';
import '../entities/note.dart';
import '../../core/error/failures.dart';

abstract class NoteRepository {
  Future<Either<Failure, List<Note>>> getNotes();
  Future<Either<Failure, Note>> getNoteById(String id);
  Future<Either<Failure, Note>> createNote(Note note);
  Future<Either<Failure, Note>> updateNote(Note note);
  Future<Either<Failure, bool>> deleteNote(String id);
}