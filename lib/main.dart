import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart' as di;
import 'presentation/bloc/note_list/note_list_bloc.dart';
import 'presentation/bloc/note_detail/note_detail_bloc.dart';
import 'presentation/bloc/ai_chat/ai_chat_bloc.dart';
import 'presentation/pages/home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");
  
  // Initialize dependency injection
  await di.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<NoteListBloc>()),
        BlocProvider(create: (_) => di.sl<NoteDetailBloc>()),
        BlocProvider(create: (_) => di.sl<AIChatBloc>()),
      ],
      child: MaterialApp(
        title: 'Notes AI',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
