import 'package:flutter/material.dart';

class CreateFlashcardScreen extends StatefulWidget {
  @override
  _CreateFlashcardScreenState createState() => _CreateFlashcardScreenState();
}

class _CreateFlashcardScreenState extends State<CreateFlashcardScreen> {
  void _showFlashcardOptionsPopup() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
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
        title: Text('Create Flashcard'),
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _showFlashcardOptionsPopup,
          child: Text('Show Flashcard Options'),
        ),
      ),
    );
  }
}

class FlashcardOptionsPopup extends StatelessWidget {
  final Function(String) onOptionSelected;

  FlashcardOptionsPopup({required this.onOptionSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Text('Create Flashcards', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ListTile(
            leading: Icon(Icons.document_scanner),
            title: Text('Scan Document ✨AI'),
            onTap: () => onOptionSelected('scanDocument'),
          ),
          ListTile(
            leading: Icon(Icons.image),
            title: Text('Select Images ✨AI'),
            onTap: () => onOptionSelected('selectImages'),
          ),
          ListTile(
            leading: Icon(Icons.paste),
            title: Text('Paste Text ✨AI'),
            onTap: () => onOptionSelected('pasteText'),
          ),
          ListTile(
            leading: Icon(Icons.create),
            title: Text('Create Manually'),
            onTap: () => onOptionSelected('manual'),
          ),
        ],
      ),
    );
  }
}
