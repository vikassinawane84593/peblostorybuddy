import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../models/quiz_model.dart';

class QuizCard extends StatefulWidget {
  final QuizModel quiz;
  final Function(String) onOptionSelected;

  const QuizCard({
    super.key,
    required this.quiz,
    required this.onOptionSelected,
  });

  @override
  State<QuizCard> createState() => _QuizCardState();
}

class _QuizCardState extends State<QuizCard> {
  bool shake = false;

  void triggerShake() {
    setState(() {
      shake = true;
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          shake = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget card = Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              widget.quiz.question,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            ...widget.quiz.options.map(
                  (option) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onOptionSelected(option);

                      if (option != widget.quiz.answer) {
                        triggerShake();
                      }
                    },
                    child: Text(
                      option,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return shake
        ? ShakeX(
      duration: const Duration(milliseconds: 500),
      child: card,
    )
        : card;
  }
}