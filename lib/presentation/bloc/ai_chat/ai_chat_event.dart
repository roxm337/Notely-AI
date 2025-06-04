
part of 'ai_chat_bloc.dart';

abstract class AIChatEvent {
  @override
  List<Object> get props => [];
}

class SendMessage extends AIChatEvent {
  final String message;
  final List<String> noteContents;

  SendMessage({required this.message, required this.noteContents});

  @override
  List<Object> get props => [message, noteContents];
}