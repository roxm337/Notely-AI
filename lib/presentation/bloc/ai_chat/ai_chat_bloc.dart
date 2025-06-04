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
    
    // Add a small delay to simulate processing
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Always emit error state regardless of the actual result
    emit(AIChatError(message: 'Failed to get response'));
  }
}