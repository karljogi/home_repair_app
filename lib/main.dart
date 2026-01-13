import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_repair_app/create_session_page.dart';
import 'package:home_repair_app/view_session_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main.g.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'Home repair app'),
        '/create_session': (context) => const CreateSessionPage(),
        '/view_session': (context) => const ViewSessionPage(),
      },
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final sessions = ref.watch(sessionsProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 80, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Home repair mapper',
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 40),
            for (final session in sessions) ...{
              GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text(
                        session.uuid,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Images: ${session.images.length}',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Comments: ${session.comments.length}',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                onTap: () => Navigator.of(
                  context,
                ).pushNamed('/view_session', arguments: session.uuid),
              ),
            },
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed('/create_session'),
                child: Text('Create session'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

@Riverpod(keepAlive: true)
class Sessions extends _$Sessions {
  List<Session> build() => [];

  void add(Session session) {
    state = [...state, session];
  }

  Session get(String uuid) =>
      state.firstWhere((session) => session.uuid == uuid);

  void update(Session session) {
    state = state.map((s) => s.uuid == session.uuid ? session : s).toList();
  }
}

class Session {
  String uuid;
  List<Uint8List> images;
  List<String> comments;

  Session({required this.uuid, required this.images, required this.comments});

  Session copyWith({
    String? uuid,
    List<Uint8List>? images,
    List<String>? comments,
  }) {
    return Session(
      uuid: uuid ?? this.uuid,
      images: images ?? this.images,
      comments: comments ?? this.comments,
    );
  }
}
