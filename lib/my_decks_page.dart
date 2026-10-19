
import 'package:flutter/material.dart';

class MyDecksPage extends StatefulWidget {
  const MyDecksPage({super.key});

  @override
  State<MyDecksPage> createState() => _MyDecksPageState();
}

class _MyDecksPageState extends State<MyDecksPage> {
  final List<String> games = [
    'Pokémon',
    'Yu-Gi-Oh!',
    'Magic: The Gathering',
    'Hearthstone',
  ];

  String selectedGame = 'Pokémon';

  final Map<String, List<String>> decks = {
    'Pokémon': ['Charizard Deck', 'Pikachu Deck'],
    'Yu-Gi-Oh!': ['Blue-Eyes Deck'],
    'Magic: The Gathering': ['Red Aggro Deck'],
    'Hearthstone': ['Mage Deck'],
  };

  void createDeck() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Create New Deck'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Deck Name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = controller.text.trim();

              if (name.isNotEmpty) {
                setState(() {
                  decks[selectedGame]!.add(name);
                });
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    ).then((_) => controller.dispose());
  }

  void viewDeck(String deckName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(deckName),
        content: Text(
          'Game: $selectedGame\n\n'
          'Deck contents will be added later.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentDecks = decks[selectedGame]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'My Decks',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),

        DropdownButton<String>(
          value: selectedGame,
          items: games.map((game) {
            return DropdownMenuItem(
              value: game,
              child: Text(game),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                selectedGame = value;
              });
            }
          },
        ),

        const SizedBox(height: 20),

        ElevatedButton.icon(
          onPressed: createDeck,
          icon: const Icon(Icons.add),
          label: const Text('Create New Deck'),
        ),

        const SizedBox(height: 24),

        Expanded(
          child: ListView.builder(
            itemCount: currentDecks.length,
            itemBuilder: (context, index) {
              final deckName = currentDecks[index];

              return Card(
                child: ListTile(
                  leading: const Icon(Icons.style),
                  title: Text(deckName),
                  subtitle: Text(selectedGame),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => viewDeck(deckName),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
