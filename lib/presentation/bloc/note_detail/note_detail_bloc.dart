import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/note.dart';
import '../../../domain/usecases/get_note_by_id.dart';
import '../../../domain/usecases/create_note.dart';
import '../../../domain/usecases/update_note.dart';
import '../../../domain/usecases/delete_note.dart';
import 'package:uuid/uuid.dart';



class NoteDetailBloc extends Bloc<NoteDetailEvent, NoteDetailState> {
  final GetNoteById getNoteById;
  final CreateNote createNote;
  final UpdateNote updateNote;
  final DeleteNote deleteNote;

  NoteDetailBloc({
    required this.getNoteById,
    required this.createNote,
    required this.updateNote,
    required this.deleteNote,
  }) : super(NoteDetailInitial()) {
    on<LoadNote>(_onLoadNote);
    on<SaveNote>(_onSaveNote);
    on<DeleteNoteEvent>(_onDeleteNote);
  }

  Future<void> _onLoadNote(LoadNote event, Emitter<NoteDetailState> emit) async {
    if (event.id == null) {
      emit(NoteDetailEditing(
        note: Note(
          id: const Uuid().v4(),
          title: '',
          content: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        isNewNote: true,
      ));
      return;
    }

    emit(NoteDetailLoading());
    final result = await getNoteById(event.id!);
    result.fold(
      (failure) => emit(NoteDetailError(message: 'Failed to load note')),
      (note) => emit(NoteDetailEditing(note: note, isNewNote: false)),
    );
  }

  Future<void> _onSaveNote(SaveNote event, Emitter<NoteDetailState> emit) async {
    emit(NoteDetailSaving());
    
    final note = Note(
      id: event.note.id,
      title: event.note.title,
      content: event.note.content,
      createdAt: event.note.createdAt,
      updatedAt: DateTime.now(),
    );
    final result = event.isNewNote
        ? await createNote(note)
        : await updateNote(note);
    
    result.fold(
      (failure) => emit(NoteDetailError(message: 'Failed to save note')),
      (savedNote) => emit(NoteDetailSaved(note: savedNote)),
    );
  }

  Future<void> _onDeleteNote(DeleteNoteEvent event, Emitter<NoteDetailState> emit) async {
    emit(NoteDetailLoading());
    final result = await deleteNote(event.id);
    result.fold(
      (failure) => emit(NoteDetailError(message: 'Failed to delete note')),
      (success) => emit(NoteDetailDeleted()),
    );
  }
}


abstract class NoteDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadNote extends NoteDetailEvent {
  final String? id;

  LoadNote({this.id});

  @override
  List<Object?> get props => [id];
}

class SaveNote extends NoteDetailEvent {
  final Note note;
  final bool isNewNote;

  SaveNote({required this.note, required this.isNewNote});

  @override
  List<Object> get props => [note, isNewNote];
}

class DeleteNoteEvent extends NoteDetailEvent {
  final String id;

  DeleteNoteEvent({required this.id});

  @override
  List<Object> get props => [id];
}



abstract class NoteDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NoteDetailInitial extends NoteDetailState {}

class NoteDetailLoading extends NoteDetailState {}

class NoteDetailSaving extends NoteDetailState {}

class NoteDetailEditing extends NoteDetailState {
  final Note note;
  final bool isNewNote;

  NoteDetailEditing({required this.note, required this.isNewNote});

  @override
  List<Object> get props => [note, isNewNote];
}

class NoteDetailSaved extends NoteDetailState {
  final Note note;

  NoteDetailSaved({required this.note});

  @override
  List<Object> get props => [note];
}

class NoteDetailDeleted extends NoteDetailState {}

class NoteDetailError extends NoteDetailState {
  final String message;

  NoteDetailError({required this.message});

  @override
  List<Object> get props => [message];
}