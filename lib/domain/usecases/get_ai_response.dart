import 'package:dartz/dartz.dart';
import '../repositories/ai_repository.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import 'package:equatable/equatable.dart';

class GetAIResponse implements UseCase<String, AIParams> {
  final AIRepository repository;

  GetAIResponse(this.repository);

  @override
  Future<Either<Failure, String>> call(AIParams params) async {
    return await repository.getResponseFromNotes(params.query, params.noteContents);
  }
}

class AIParams extends Equatable {
  final String query;
  final List<String> noteContents;

  const AIParams({required this.query, required this.noteContents});

  @override
  List<Object> get props => [query, noteContents];
}