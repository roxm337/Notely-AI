import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:notely_ai/models/note.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/foundation.dart';

class AIService {
  late final GenerativeModel _model;
  bool _isInitialized = false;

  AIService() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final apiKey = dotenv.env['GOOGLE_API_KEY'];
      debugPrint('Loading Gemini API key...');
      
      if (apiKey == null || apiKey.isEmpty) {
        debugPrint('Error: Gemini API key is null or empty');
        debugPrint('Current .env contents: ${dotenv.env}');
        return;
      }

      debugPrint('API key found, initializing model...');
      _model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
      );
      _isInitialized = true;
      debugPrint('AIService initialized successfully');
    } catch (e) {
      debugPrint('Error initializing AIService: $e');
    }
  }

  String _getLocalResponse() {
    return '''I notice there might be an issue with the AI service. Here are your options:

1. Check your Gemini API key in the .env file
2. Make sure you have an active Gemini API key
3. Verify your internet connection

In the meantime, you can still:
- Create and manage your notes
- Search through your existing notes
- Organize your notes into categories

Would you like me to help you with any of these tasks?''';
  }

  Future<String> askAboutNotes(String question, List<Note> notes) async {
    try {
      if (!_isInitialized) {
        return _getLocalResponse();
      }

      // Check if we have any notes to work with
      if (notes.isEmpty) {
        return 'You haven\'t created any notes yet. Would you like to create your first note?';
      }

      // Prepare context from notes
      final context = notes.map((note) => 
        'Title: ${note.title}\nContent: ${note.content}\n'
      ).join('\n');

      // Create the prompt
      final prompt = '''
Based on the following notes, please answer the question. If the answer cannot be found in the notes, say so.

Notes:
$context

Question: $question

Answer:''';

      // Generate content using Gemini
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      if (response.text != null) {
        return response.text!;
      } else {
        return _getLocalResponse();
      }
    } catch (e) {
      debugPrint('Error in askAboutNotes: $e');
      return _getLocalResponse();
    }
  }
} 