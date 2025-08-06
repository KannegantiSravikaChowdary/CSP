import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      final welcome = '''
Hi there! 👋 How can I help you today?

Common issues I can assist with:
• Fever
• Headache
• Cold & Cough
• Vomiting
• Stomach pain
• Diarrhea
• Dizziness

For anything severe like chest pain or unconsciousness — consult a doctor immediately!
''';
      setState(() {
        _messages.add({'bot': welcome});
      });
      _tts.speak(welcome);
    });
  }

  void _sendMessage([String? forcedText]) {
    final input = forcedText ?? _controller.text.trim();
    if (input.isEmpty) return;

    setState(() {
      _messages.add({'user': input});
    });

    final botReply = _getBotResponse(input);
    setState(() {
      _messages.add({'bot': botReply});
      _controller.clear();
    });

    _tts.speak(botReply);
  }

  String _getBotResponse(String input) {
    input = input.toLowerCase();

    if (input.contains('hi') || input.contains('hello')) {
      return 'Hi! What’s your age and how are you feeling today?';
    } else if (input.contains(RegExp(r'\b[0-9]{1,2}\b'))) {
      return 'Thanks! Now, please describe your symptoms.';
    } else if (input.contains('fever')) {
      return '''
🤒 For fever:
• Tablet: *Paracetamol 500mg*
• Rest and drink fluids
• See a doctor if it exceeds 102°F
''';
    } else if (input.contains('headache')) {
      return '''
🤕 Headache:
• Tablet: *Dolo 650* or *Crocin*
• Rest, hydrate, and avoid screen time
''';
    } else if (input.contains('cold') || input.contains('sneeze')) {
      return '''
🤧 Cold:
• Tablet: *Cetrizine* or *Levocet*
• Take steam, stay warm
''';
    } else if (input.contains('cough')) {
      return '''
😷 Cough:
• Syrup: *Benadryl* or *Ascoril*
• Avoid cold drinks, take rest
''';
    } else if (input.contains('stomach') || input.contains('pain')) {
      return '''
🤢 Stomach pain:
• Tablet: *Cyclopam* or *Buscopan*
• Eat light food, stay hydrated
''';
    } else if (input.contains('vomiting')) {
      return '''
🤮 Vomiting:
• ORS and *Domstal* can help
• Avoid oily food
• Visit a doctor if frequent
''';
    } else if (input.contains('dizziness')) {
      return '''
😵‍💫 Dizziness:
• Sit down, hydrate
• May be due to low BP or fatigue
''';
    } else if (input.contains('diarrhea')) {
      return '''
💧 Diarrhea:
• Use *ORS*, drink water
• Tablet: *Eldoper*
''';
    } else if (input.contains('chest pain') ||
        input.contains('unconscious') ||
        input.contains('severe') ||
        input.contains('heart')) {
      return '''
⚠️ This seems critical.
Please visit a hospital immediately.
Your safety matters!
''';
    } else if (input.contains('bye')) {
      return 'Take care! Reach out anytime if you need help.';
    }

    return '''
I can help with:
• Fever
• Cold & Cough
• Vomiting
• Diarrhea
• Headache
• Dizziness
• Stomach pain

For anything beyond this, consult a nearby doctor.
''';
  }

  @override
  void dispose() {
    _controller.dispose();
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤖 AskHealth Bot'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg.containsKey('user');
                final text = msg.values.first;
                return Align(
                  alignment:
                  isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.green[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(text, style: const TextStyle(fontSize: 16)),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: const InputDecoration(
                      hintText: 'Describe your symptom...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.green),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
