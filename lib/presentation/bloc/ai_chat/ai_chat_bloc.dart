import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/usecases/get_ai_response.dart';
import '../../../core/usecases/usecase.dart';

part 'ai_chat_event.dart';
part 'ai_chat_state.dart';

class AIChatBloc extends Bloc<AIChatEvent, AIChatState> {
  final GetAIResponse getAIResponse;

  AIChatBloc({required this.getAIResponse}) : super(AIChatInitial()) {
    on<SendMessage>(_onSendMessage);
  }

  Future<void> _onSendMessage(SendMessage event, Emitter<AIChatState> emit) async {
    emit(AIChatLoading());
    
    final params = AIParams(
      query: event.message,
      noteContents: event.noteContents,
    );
    
    final result = await getAIResponse(params);
    
    result.fold(
      (failure) => emit(AIChatError(message: 'Failed to get response')),
      (response) => emit(AIChatLoaded(response: response)),
    );
  }
}