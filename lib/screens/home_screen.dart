import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peblostorybuddy/providers/story_provider.dart';
import 'package:peblostorybuddy/services/tts_service.dart';


class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TtsService ttsService = TtsService();

  final String storyText =
      "Once upon a time, a clever little robot named Pip lost his shiny blue gear in the Whispering Woods...";

  @override
  void initState() {
    super.initState();

    ttsService.initialize();

    ttsService.onComplete(() {
      ref.read(storyProvider.notifier).showQuiz();
    });

    ttsService.onError((message) {
      ref.read(storyProvider.notifier).setError();
    });
  }

  Future<void> readStory() async {
    ref.read(storyProvider.notifier).setLoading();

    await Future.delayed(const Duration(seconds: 1));

    ref.read(storyProvider.notifier).setPlaying();

    await ttsService.speak(storyText);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(storyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Story Buddy"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // AI Buddy
            const CircleAvatar(
              radius: 50,
              child: Icon(
                Icons.smart_toy,
                size: 50,
              ),
            ),

            const SizedBox(height: 20),

            // Story Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  storyText,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: readStory,
              child: const Text("Read Me a Story"),
            ),

            const SizedBox(height: 20),

            if (state == StoryState.loading)
              const CircularProgressIndicator(),

            if (state == StoryState.playing)
              const Text("Reading Story..."),

            if (state == StoryState.error)
              const Text(
                "Oops! Something went wrong.",
              ),

            if (state == StoryState.quizVisible)
              const Text(
                "Quiz Coming Next...",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}