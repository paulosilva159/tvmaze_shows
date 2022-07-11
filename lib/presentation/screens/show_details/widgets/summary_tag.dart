import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html;

class SummaryTag extends StatelessWidget {
  const SummaryTag({
    super.key,
    required this.title,
    required this.info,
  });

  final String title;
  final String info;

  @override
  Widget build(BuildContext context) {
    final parsedInfo = html.parse(info);
    final infoText = parsedInfo.body?.text ?? '';

    return Card(
      color: Colors.white70,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(infoText),
            ),
          ],
        ),
      ),
    );
  }
}
