# Peblo AI Story Buddy & Quiz Challenge

## Framework Chosen

I chose **Flutter** because it allows rapid UI development, cross-platform support, and provides excellent performance for interactive experiences on both Android and iOS devices.

---

## Feature Overview

This project implements a mini AI Story Buddy experience for children.

Features:

* Kid-friendly UI
* Text-to-Speech story narration
* Loading and error states
* Data-driven quiz rendering
* Wrong-answer feedback
* Success state with celebration
* Riverpod state management
* Confetti animation

---

## Story Flow

1. User taps **"Read Me a Story"**
2. App enters loading state
3. Story narration begins using Flutter TTS
4. After narration completes, the quiz appears automatically
5. User answers the quiz
6. Wrong answers show feedback and allow retry
7. Correct answer triggers a success state and celebration

---

## Audio → Quiz Transition

The transition from narration to quiz is handled using the TTS completion callback.

When narration finishes:

```dart
ttsService.onComplete(() {
  ref.read(storyProvider.notifier).showQuiz();
});
```

This ensures the quiz is shown only after the story narration has fully completed.

---

## Data-Driven Quiz Implementation

The quiz is rendered from JSON data instead of hardcoded UI.

Example:

```json
{
  "question": "What colour was Pip the Robot's lost gear?",
  "options": ["Red", "Green", "Blue", "Yellow"],
  "answer": "Blue"
}
```

The UI dynamically generates answer options using the options list, allowing future questions with different numbers of options without code changes.

---

## State Management

Riverpod is used to manage application states:

* idle
* loading
* playing
* quizVisible
* success
* error

This keeps UI updates predictable and prevents unnecessary rebuilds.

---

## Audio Loading & Error Handling

Loading state:

* Preparing Story...

Error state:

* Friendly error message displayed
* Application remains responsive
* User can retry

This prevents crashes and improves user experience.

---

## Performance Considerations

To keep the application lightweight for mid-range Android devices:

* Used Flutter TTS instead of heavy audio processing
* Kept widget tree simple
* Used Riverpod for efficient state updates
* Avoided unnecessary rebuilds
* Used lightweight animations

---

## Caching Strategy

This implementation uses the device's native TTS engine.

Since audio is generated locally, remote audio caching is not required.

If remote audio APIs such as ElevenLabs were used, audio files could be cached using a package such as `flutter_cache_manager`.

---

## AI Assistance

AI tools were used for:

* Architecture planning
* Riverpod structure guidance
* Flutter TTS integration guidance
* Code review and debugging assistance

All code was reviewed, modified, and integrated manually.

One suggestion that was changed was using a hardcoded quiz UI. Instead, the final implementation renders quiz options dynamically from JSON data to support future scalability.

---

## Future Improvements

* Animated AI Buddy states
* Multiple story support
* Remote story and quiz APIs
* Voice selection
* Progress tracking
* Better accessibility support

---

## Packages Used

* flutter_riverpod
* flutter_tts
* confetti
* animate_do

---

## Author

Vikas Sonawane
