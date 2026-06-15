import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peblostorybuddy/widgets/quize_card.dart';

import '../models/quiz_model.dart';
import '../providers/story_provider.dart';
import '../services/tts_service.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TtsService ttsService = TtsService();

  late ConfettiController _confettiController;

  final String storyText =
      "Once upon a time, a clever little robot named Pip lost his shiny blue gear in the Whispering Woods...";

  final QuizModel quiz = QuizModel.fromJson({
    "question": "What colour was Pip the Robot's lost gear?",
    "options": ["Red", "Green", "Blue", "Yellow"],
    "answer": "Blue",
  });

  @override
  void initState() {
    super.initState();

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

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

  void checkAnswer(String selectedAnswer) {
    if (selectedAnswer == quiz.answer) {
      _confettiController.play();

      ref.read(storyProvider.notifier).setSuccess();
    } else {
      HapticFeedback.mediumImpact();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Try Again!"),
        ),
      );
    }
  }


  @override
  void dispose() {
    _confettiController.dispose();
    ttsService.stop();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final state = ref.watch(storyProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E7),
      appBar: AppBar(
        title: const Text("AI Story Buddy"),
        centerTitle: true,
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
            ),

            const SizedBox(height: 10),

            // AI Buddy
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.smart_toy,
                size: 90,
                color: Colors.orange,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Meet Pip the Robot!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // Story Card
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),git
                child: Text(
                  storyText,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.6,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Read Story Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed:
                state == StoryState.loading ||
                    state == StoryState.playing
                    ? null
                    : readStory,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "📖 Read Me a Story",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            if (state == StoryState.loading)
              const Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text(
                    "Preparing Story...",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),

            if (state == StoryState.playing)
              const Column(
                children: [
                  Icon(
                    Icons.volume_up,
                    size: 50,
                    color: Colors.orange,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Reading Story...",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

            if (state == StoryState.error)
              Card(
                color: Colors.red.shade50,
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Oops! Couldn't read the story.\nPlease try again.",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

            const SizedBox(height: 20),

            if (state == StoryState.quizVisible)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: QuizCard(
                  quiz: quiz,
                  onOptionSelected: checkAnswer,
                ),
              ),

            if (state == StoryState.success)
              Column(
                children: [
                  const Icon(
                    Icons.celebration,
                    size: 120,
                    color: Colors.green,
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "🎉 Great Job!",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "You found the correct answer!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      ref.read(storyProvider.notifier).reset();
                    },
                    child: const Text("Play Again"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}