import 'package:dartz/dartz.dart';
import '../repositories/note_repository.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';

class DeleteNote implements UseCase<bool, String> {
  final NoteRepository repository;

  DeleteNote(this.repository);

  @override
  Future<Either<Failure, bool>> call(String id) async {
    return await repository.deleteNote(id);
  }
}