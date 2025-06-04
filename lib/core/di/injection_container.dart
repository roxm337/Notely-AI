import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../data/datasources/local/note_local_datasource.dart';
import '../../data/datasources/remote/ai_remote_datasource.dart';
import '../../data/models/note_model.dart';
import '../../data/repositories/note_repository_impl.dart';
import '../../data/repositories/ai_repository_impl.dart';
import '../../domain/repositories/note_repository.dart';
import '../../domain/repositories/ai_repository.dart';
import '../../domain/usecases/get_notes.dart';
import '../../domain/usecases/get_note_by_id.dart';
import '../../domain/usecases/create_note.dart';
import '../../domain/usecases/update_note.dart';
import '../../domain/usecases/delete_note.dart';
import '../../domain/usecases/get_ai_response.dart';
import '../../presentation/bloc/note_list/note_list_bloc.dart';
import '../../presentation/bloc/note_detail/note_detail_bloc.dart';
import '../../presentation/bloc/ai_chat/ai_chat_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(NoteModelAdapter());
  final notesBox = await Hive.openBox<NoteModel>('notes');

  // BLoCs
  sl.registerFactory(() => NoteListBloc(getNotes: sl()));
  sl.registerFactory(() => NoteDetailBloc(
        getNoteById: sl(),
        createNote: sl(),
        updateNote: sl(),
        deleteNote: sl(),
      ));
  sl.registerFactory(() => AIChatBloc(getAIResponse: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetNotes(sl()));
  sl.registerLazySingleton(() => GetNoteById(sl()));
  sl.registerLazySingleton(() => CreateNote(sl()));
  sl.registerLazySingleton(() => UpdateNote(sl()));
  sl.registerLazySingleton(() => DeleteNote(sl()));
  sl.registerLazySingleton(() => GetAIResponse(sl()));

  // Repositories
  sl.registerLazySingleton<NoteRepository>(
    () => NoteRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<AIRepository>(
    () => AIRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<NoteLocalDataSource>(
    () => NoteLocalDataSourceImpl(notesBox: notesBox),
  );
  sl.registerLazySingleton<AIRemoteDataSource>(
    () => AIRemoteDataSourceImpl(
      dio: sl(),
      apiKey: dotenv.env['OPENAI_API_KEY'] ?? '', // Get API key from .env
    ),
  );

  // External
  sl.registerLazySingleton(() => Dio());
}