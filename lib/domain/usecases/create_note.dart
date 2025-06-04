import 'package:dartz/dartz.dart';
import '../entities/note.dart';
import '../repositories/note_repository.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';

class CreateNote implements UseCase<Note, Note> {
  final NoteRepository repository;

  CreateNote(this.repository);

  @override
  Future<Either<Failure, Note>> call(Note note) async {
    return await repository.createNote(note);
  }
}