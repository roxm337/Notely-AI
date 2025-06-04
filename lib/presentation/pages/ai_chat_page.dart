import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/ai_chat/ai_chat_bloc.dart';
import '../bloc/note_list/note_list_bloc.dart';

class AIChatPage extends StatefulWidget {
  const AIChatPage({Key? key}) : super(key: key);

  @override
  State<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends State<AIChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    // Ensure notes are loaded
    context.read<NoteListBloc>().add(FetchNotes());
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<AIChatBloc, AIChatState>(
              listener: (context, state) {
                if (state is AIChatLoaded) {
                  setState(() {
                    _messages.add(ChatMessage(
                      text: state.response,
                      isUser: false,
                    ));
                  });
                } else if (state is AIChatError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessage(_messages[index]);
                  },
                );
              },
            ),
          ),
          BlocBuilder<AIChatBloc, AIChatState>(
            builder: (context, state) {
              final isLoading = state is AIChatLoading;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: const Offset(0, -1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Ask something about your notes...',
                          border: InputBorder.none,
                        ),
                        enabled: !isLoading,
                      ),
                    ),
                    IconButton(
                      icon: isLoading
                          ? const CircularProgressIndicator()
                          : const Icon(Icons.send),
                      onPressed: isLoading ? null : _sendMessage,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return Align(
      alignment: message.isUser
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: message.isUser
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.secondary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser
                ? Colors.white
                : Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.isEmpty) return;

    final message = _messageController.text;
    setState(() {
      _messages.add(ChatMessage(
        text: message,
        isUser: true,
      ));
    });
    _messageController.clear();

    // Get note contents from the NoteListBloc
    final noteListState = context.read<NoteListBloc>().state;
    final List<String> noteContents = [];
    
    if (noteListState is NoteListLoaded) {
      for (final note in noteListState.notes) {
        if (note.title.isNotEmpty) {
          noteContents.add('Title: ${note.title}\nContent: ${note.content}');
        } else {
          noteContents.add(note.content);
        }
      }
    }

    context.read<AIChatBloc>().add(
          SendMessage(
            message: message,
            noteContents: noteContents,
          ),
        );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}