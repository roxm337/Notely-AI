import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/note_list/note_list_bloc.dart';
import '../widgets/note_card.dart';
import 'note_detail_page.dart';
import 'ai_chat_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes AI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AIChatPage()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NoteListBloc, NoteListState>(
        builder: (context, state) {
          if (state is NoteListInitial) {
            context.read<NoteListBloc>().add(FetchNotes());
            return const Center(child: CircularProgressIndicator());
          } else if (state is NoteListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NoteListLoaded) {
            return state.notes.isEmpty
                ? const Center(child: Text('No notes yet. Create one!'))
                : ListView.builder(
                    itemCount: state.notes.length,
                    itemBuilder: (context, index) {
                      final note = state.notes[index];
                      return NoteCard(
                        note: note,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NoteDetailPage(noteId: note.id),
                            ),
                          ).then((_) {
                            context.read<NoteListBloc>().add(FetchNotes());
                          });
                        },
                      );
                    },
                  );
          } else if (state is NoteListError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Something went wrong'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NoteDetailPage()),
          ).then((_) {
            context.read<NoteListBloc>().add(FetchNotes());
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}