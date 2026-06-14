import 'package:flutter/material.dart';
import '../models/quiz_model.dart';

class QuizCard extends StatelessWidget {
  final QuizModel quiz;
  final Function(String) onOptionSelected;

  const QuizCard({
    super.key,
    required this.quiz,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              quiz.question,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            ...quiz.options.map(
                  (option) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      onOptionSelected(option);
                    },
                    child: Text(option),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}