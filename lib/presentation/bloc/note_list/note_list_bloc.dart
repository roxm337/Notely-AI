import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/note.dart';
import '../../../domain/usecases/get_notes.dart';
import '../../../core/usecases/usecase.dart';

// The state definitions are now included directly in this file

class NoteListBloc extends Bloc<NoteListEvent, NoteListState> {
  final GetNotes getNotes;

  NoteListBloc({required this.getNotes}) : super(NoteListInitial()) {
    on<FetchNotes>(_onFetchNotes);
  }

  Future<void> _onFetchNotes(FetchNotes event, Emitter<NoteListState> emit) async {
    emit(NoteListLoading());
    final result = await getNotes(NoParams());
    result.fold(
      (failure) => emit(NoteListError(message: 'Failed to load notes')),
      (notes) => emit(NoteListLoaded(notes: notes)),
    );
  }
}

// note_list_event.dart

abstract class NoteListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchNotes extends NoteListEvent {}

// note_list_state.dart

abstract class NoteListState extends Equatable {
  @override
  List<Object> get props => [];
}

class NoteListInitial extends NoteListState {}

class NoteListLoading extends NoteListState {}

class NoteListLoaded extends NoteListState {
  final List<Note> notes;

  NoteListLoaded({required this.notes});

  @override
  List<Object> get props => [notes];
}

class NoteListError extends NoteListState {
  final String message;

  NoteListError({required this.message});

  @override
  List<Object> get props => [message];
}