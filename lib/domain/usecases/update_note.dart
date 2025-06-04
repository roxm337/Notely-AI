import 'package:dartz/dartz.dart';
import '../entities/note.dart';
import '../repositories/note_repository.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';

class UpdateNote implements UseCase<Note, Note> {
  final NoteRepository repository;

  UpdateNote(this.repository);

  @override
  Future<Either<Failure, Note>> call(Note note) async {
    return await repository.updateNote(note);
  }
}