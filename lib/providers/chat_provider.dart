import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notely_ai/models/chat_message.dart';
import 'package:uuid/uuid.dart';

class ChatProvider with ChangeNotifier {
  late Box<ChatMessage> _chatBox;
  final _uuid = const Uuid();
  
  List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  Future<void> init() async {
    _chatBox = Hive.box<ChatMessage>('chat_messages');
    await fetchMessages();
  }

  Future<void> fetchMessages() async {
    try {
      _messages = _chatBox.values.toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching messages: $e');
      _messages = [];
      notifyListeners();
    }
  }

  Future<void> addMessage(String message, bool isUser) async {
    try {
      final chatMessage = ChatMessage(
        id: _uuid.v4(),
        message: message,
        isUser: isUser,
        timestamp: DateTime.now(),
      );

      await _chatBox.put(chatMessage.id, chatMessage);
      await fetchMessages();
    } catch (e) {
      debugPrint('Error adding message: $e');
      rethrow;
    }
  }

  Future<void> clearChat() async {
    try {
      await _chatBox.clear();
      await fetchMessages();
    } catch (e) {
      debugPrint('Error clearing chat: $e');
      rethrow;
    }
  }
} 