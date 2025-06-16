import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:notely_ai/providers/notes_provider.dart';
import 'package:notely_ai/providers/chat_provider.dart';
import 'package:notely_ai/screens/home_screen.dart';
import 'package:notely_ai/models/note.dart';
import 'package:notely_ai/models/chat_message.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register adapters
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(NoteAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(ChatMessageAdapter());
  }
  
  // Open boxes
  final notesBox = await Hive.openBox<Note>('notes');
  final chatBox = await Hive.openBox<ChatMessage>('chat_messages');
  
  runApp(MyApp(notesBox: notesBox, chatBox: chatBox));
}

class MyApp extends StatelessWidget {
  final Box<Note> notesBox;
  final Box<ChatMessage> chatBox;
  
  const MyApp({
    super.key, 
    required this.notesBox,
    required this.chatBox,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NotesProvider()..init(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider()..init(),
        ),
      ],
      child: MaterialApp(
        title: 'NoteflowAI',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          fontFamily: 'madani',
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
