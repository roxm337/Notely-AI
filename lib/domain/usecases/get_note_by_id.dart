import 'package:dartz/dartz.dart';
import '../entities/note.dart';
import '../repositories/note_repository.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';

class GetNoteById implements UseCase<Note, String> {
  final NoteRepository repository;

  GetNoteById(this.repository);

  @override
  Future<Either<Failure, Note>> call(String id) async {
    return await repository.getNoteById(id);
  }
}