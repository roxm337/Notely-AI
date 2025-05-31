import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';

abstract class AIRepository {
  Future<Either<Failure, String>> getResponseFromNotes(String query, List<String> noteContents);
}