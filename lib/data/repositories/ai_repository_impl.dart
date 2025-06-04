import 'package:dartz/dartz.dart';
import '../../domain/repositories/ai_repository.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../datasources/remote/ai_remote_datasource.dart';

class AIRepositoryImpl implements AIRepository {
  final AIRemoteDataSource remoteDataSource;

  AIRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> getResponseFromNotes(String query, List<String> noteContents) async {
    try {
      final response = await remoteDataSource.getResponseFromNotes(query, noteContents);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}