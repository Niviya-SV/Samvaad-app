import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      (
      'How do I start learning?',
      'Open Learn from the bottom navigation and choose a learning path.'
      ),
      (
      'How does practice work?',
      'Practice activities help you review signs and improve your confidence.'
      ),
      (
      'How can I change my profile?',
      'Open Profile and choose Edit Profile.'
      ),
      (
      'How do I change my language?',
      'Open Settings → Language and select your preferred language.'
      ),
      (
      'How do I control notifications?',
      'Open Settings → Notifications.'
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF5),
      appBar: AppBar(
        title: const Text(
          'Help & Support',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Frequently asked questions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 15),

          ...faqs.map(
                (faq) => Card(
              elevation: 0,
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 10),
              child: ExpansionTile(
                title: Text(
                  faq.$1,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                childrenPadding:
                const EdgeInsets.fromLTRB(20, 0, 20, 20),
                children: [
                  Text(faq.$2),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Support contact will be connected in the next phase.',
                  ),
                ),
              );
            },
            icon: const Icon(Icons.support_agent_rounded),
            label: const Text('Contact Support'),
          ),
        ],
      ),
    );
  }
}