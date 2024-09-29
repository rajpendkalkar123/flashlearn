import 'package:flutter/material.dart';

class CreateFlashcardScreen extends StatefulWidget {
  const CreateFlashcardScreen({super.key});

  @override
  _CreateFlashcardScreenState createState() => _CreateFlashcardScreenState();
}

class _CreateFlashcardScreenState extends State<CreateFlashcardScreen> {
  void _showFlashcardOptionsPopup() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        return FlashcardOptionsPopup(
          onOptionSelected: (String option) {
            Navigator.pop(context);  // Close the popup
            _handleOptionSelected(option); // Handle option selection
          },
        );
      },
    );
  }

  void _handleOptionSelected(String option) {
    if (option == 'manual') {
      Navigator.pushNamed(context, 'manualFlashcard');  // Navigate to manual flashcard creation
    } else if (option == 'pasteText') {
      Navigator.pushNamed(context, 'pasteTextFlashcard'); // Navigate to text-based AI creation
    }
    // Handle other options like 'scanDocument' and 'selectImages'
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Flashcard'),
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _showFlashcardOptionsPopup,
          child: const Text('Show Flashcard Options'),
        ),
      ),
    );
  }
}

class FlashcardOptionsPopup extends StatelessWidget {
  final Function(String) onOptionSelected;

  const FlashcardOptionsPopup({super.key, required this.onOptionSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 350,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const Text('Create Flashcards', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ListTile(
            leading: const Icon(Icons.document_scanner),
            title: const Text('Scan Document ✨AI'),
            onTap: () => onOptionSelected('scanDocument'),
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text('Select Images ✨AI'),
            onTap: () => onOptionSelected('selectImages'),
          ),
          ListTile(
            leading: const Icon(Icons.paste),
            title: const Text('Paste Text ✨AI'),
            onTap: () => onOptionSelected('pasteText'),
          ),
          ListTile(
            leading: const Icon(Icons.create),
            title: const Text('Create Manually'),
            onTap: () => onOptionSelected('manual'),
          ),
        ],
      ),
    );
  }
}
