
import 'package:riverpod/legacy.dart';

enum StoryState {
  idle,
  loading,
  playing,
  quizVisible,
  success,
  error,
}

class StoryNotifier extends StateNotifier<StoryState> {
  StoryNotifier() : super(StoryState.idle);

  void setLoading() {
    state = StoryState.loading;
  }

  void setPlaying() {
    state = StoryState.playing;
  }

  void showQuiz() {
    state = StoryState.quizVisible;
  }

  void setSuccess() {
    state = StoryState.success;
  }

  void setError() {
    state = StoryState.error;
  }

  void reset() {
    state = StoryState.idle;
  }
}

final storyProvider =
StateNotifierProvider<StoryNotifier, StoryState>((ref) {
  return StoryNotifier();
});
