part of 'ai_chat_bloc.dart';

abstract class AIChatState {
  @override
  List<Object> get props => [];
}

class AIChatInitial extends AIChatState {}

class AIChatLoading extends AIChatState {}

class AIChatLoaded extends AIChatState {
  final String response;

  AIChatLoaded({required this.response});

  @override
  List<Object> get props => [response];
}

class AIChatError extends AIChatState {
  final String message;

  AIChatError({required this.message});

  @override
  List<Object> get props => [message];
}