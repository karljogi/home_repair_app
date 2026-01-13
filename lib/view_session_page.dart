import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_repair_app/main.dart';

class ViewSessionPage extends ConsumerStatefulWidget {
  const ViewSessionPage({super.key});

  @override
  ConsumerState<ViewSessionPage> createState() => _ViewSessionPageState();
}

class _ViewSessionPageState extends ConsumerState<ViewSessionPage> {
  Session? _session;

  @override
  Widget build(BuildContext context) {
    final sessionUuid = ModalRoute.of(context)!.settings.arguments as String;
    final session = ref.read(sessionsProvider.notifier).get(sessionUuid);
    return Scaffold(
      floatingActionButton: ElevatedButton(
        onPressed: () {
          if (_session != null) {
            ref.read(sessionsProvider.notifier).update(session);
          }
          Navigator.pop(context);
        },
        child: Text('Save changes'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Text(
              'Session name: ${session.uuid}',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),
            for (final (index, image) in session.images.indexed) ...{
              SessionCard(
                image: image,
                comment: session.comments[index],
                onChange: (value) {
                  final comments = _session != null
                      ? _session!.comments
                      : session.comments;
                  comments[index] = value;

                  setState(
                    () => _session = session.copyWith(comments: comments),
                  );
                },
              ),
            },
          ],
        ),
      ),
    );
  }
}

class SessionCard extends StatefulWidget {
  final Uint8List image;
  final String comment;
  final Function(String) onChange;
  const SessionCard({
    super.key,
    required this.image,
    required this.comment,
    required this.onChange,
  });

  @override
  State<SessionCard> createState() => SessionCardState();
}

class SessionCardState extends State<SessionCard> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.comment;
    _controller.addListener(() => widget.onChange(_controller.text));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.memory(widget.image, height: 240, width: 135),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a comment',
            ),
          ),
        ),
      ],
    );
  }
}
