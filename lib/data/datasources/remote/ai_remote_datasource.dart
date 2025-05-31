import 'package:dio/dio.dart';

abstract class AIRemoteDataSource {
  Future<String> getResponseFromNotes(String query, List<String> noteContents);
}

class AIRemoteDataSourceImpl implements AIRemoteDataSource {
  final Dio dio;
  final String apiKey; // Store this securely in a real app

  AIRemoteDataSourceImpl({required this.dio, required this.apiKey});

  @override
  Future<String> getResponseFromNotes(String query, List<String> noteContents) async {
    try {
      final response = await dio.post(
        'https://api.openai.com/v1/chat/completions',
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content': 'You are a helpful assistant that answers questions based on the user\'s notes. Here are the notes: ${noteContents.join("\n\n")}',
            },
            {
              'role': 'user',
              'content': query,
            },
          ],
        },
      );

      return response.data['choices'][0]['message']['content'];
    } catch (e) {
      throw Exception('Failed to get AI response: $e');
    }
  }
}