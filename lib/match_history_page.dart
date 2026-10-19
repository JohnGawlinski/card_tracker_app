
import 'package:flutter/material.dart';

class MatchHistoryPage extends StatefulWidget {
  const MatchHistoryPage({super.key});

  @override
  State<MatchHistoryPage> createState() => _MatchHistoryPageState();
}

class _MatchHistoryPageState extends State<MatchHistoryPage> {
  String selectedGame = 'All Games';

  final games = [
    'All Games',
    'Pokémon',
    'Yu-Gi-Oh!',
    'Magic: The Gathering',
    'Hearthstone',
  ];

  final List<Map<String, String>> matches = [
    {
      'game': 'Pokémon',
      'deck': 'Charizard Deck',
      'opponent': 'Pikachu Deck',
      'result': 'Win',
      'date': '2026-10-15',
    },
    {
      'game': 'Yu-Gi-Oh!',
      'deck': 'Blue-Eyes Deck',
      'opponent': 'Dark Magician Deck',
      'result': 'Loss',
      'date': '2026-10-14',
    },
    {
      'game': 'Magic: The Gathering',
      'deck': 'Red Aggro Deck',
      'opponent': 'Control Deck',
      'result': 'Win',
      'date': '2026-10-13',
    },
    {
      'game': 'Hearthstone',
      'deck': 'Mage Deck',
      'opponent': 'Warrior Deck',
      'result': 'Win',
      'date': '2026-10-12',
    },
  ];

  void addMatch() {
    String game = 'Pokémon';
    String result = 'Win';
    final deckController = TextEditingController();
    final opponentController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, updateDialog) => AlertDialog(
          title: const Text('Add Match'),
          content: SizedBox(
            width: 350,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: game,
                  decoration: const InputDecoration(
                    labelText: 'Game',
                  ),
                  items: games.skip(1).map((g) {
                    return DropdownMenuItem(
                      value: g,
                      child: Text(g),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      updateDialog(() => game = value);
                    }
                  },
                ),
                TextField(
                  controller: deckController,
                  decoration: const InputDecoration(
                    labelText: 'Your Deck',
                  ),
                ),
                TextField(
                  controller: opponentController,
                  decoration: const InputDecoration(
                    labelText: 'Opponent Deck',
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: result,
                  decoration: const InputDecoration(
                    labelText: 'Result',
                  ),
                  items: ['Win', 'Loss'].map((r) {
                    return DropdownMenuItem(
                      value: r,
                      child: Text(r),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      updateDialog(() => result = value);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final deck = deckController.text.trim();
                final opponent = opponentController.text.trim();

                if (deck.isEmpty || opponent.isEmpty) {
                  return;
                }

                setState(() {
                  matches.insert(0, {
                    'game': game,
                    'deck': deck,
                    'opponent': opponent,
                    'result': result,
                    'date': DateTime.now()
                        .toIso8601String()
                        .substring(0, 10),
                  });
                });

                Navigator.pop(dialogContext);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    ).then((_) {
      deckController.dispose();
      opponentController.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredMatches = matches.where((match) {
      return selectedGame == 'All Games' ||
          match['game'] == selectedGame;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Match History',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 20,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
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
                  setState(() => selectedGame = value);
                }
              },
            ),
            ElevatedButton.icon(
              onPressed: addMatch,
              icon: const Icon(Icons.add),
              label: const Text('Add Match'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Expanded(
          child: filteredMatches.isEmpty
              ? const Center(
                  child: Text('No matches found.'),
                )
              : ListView.builder(
                  itemCount: filteredMatches.length,
                  itemBuilder: (context, index) {
                    final match = filteredMatches[index];
                    final won = match['result'] == 'Win';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Icon(
                          won ? Icons.emoji_events : Icons.close,
                          color: won ? Colors.green : Colors.red,
                        ),
                        title: Text(
                          '${match['deck']} vs ${match['opponent']}',
                        ),
                        subtitle: Text(
                          '${match['game']} | ${match['date']}',
                        ),
                        trailing: Text(
                          match['result']!,
                          style: TextStyle(
                            color: won ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
