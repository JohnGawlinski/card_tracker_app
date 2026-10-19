
import 'package:flutter/material.dart';

class CardDatabasePage extends StatefulWidget {
  const CardDatabasePage({super.key});

  @override
  State<CardDatabasePage> createState() => _CardDatabasePageState();
}

class _CardDatabasePageState extends State<CardDatabasePage> {
  String selectedGame = 'All Games';
  String searchQuery = '';

  final List<String> games = [
    'All Games',
    'Pokémon',
    'Yu-Gi-Oh!',
    'Magic: The Gathering',
    'Hearthstone',
  ];

  // Sample card information for the demo.
  final List<Map<String, String>> cards = [
    {
      'name': 'Charizard',
      'game': 'Pokémon',
      'type': 'Fire',
      'details': 'HP: 120\nAttack: Fire Spin\nDamage: 100',
    },
    {
      'name': 'Pikachu',
      'game': 'Pokémon',
      'type': 'Electric',
      'details': 'HP: 40\nAttack: Thunder Jolt\nDamage: 30',
    },
    {
      'name': 'Blue-Eyes White Dragon',
      'game': 'Yu-Gi-Oh!',
      'type': 'Dragon',
      'details': 'ATK: 3000\nDEF: 2500\nLevel: 8',
    },
    {
      'name': 'Dark Magician',
      'game': 'Yu-Gi-Oh!',
      'type': 'Spellcaster',
      'details': 'ATK: 2500\nDEF: 2100\nLevel: 7',
    },
    {
      'name': 'Lightning Bolt',
      'game': 'Magic: The Gathering',
      'type': 'Instant',
      'details': 'Mana Cost: R\nDeals 3 damage to any target.',
    },
    {
      'name': 'Shivan Dragon',
      'game': 'Magic: The Gathering',
      'type': 'Creature',
      'details': 'Mana Cost: 4RR\nFlying\nPower/Toughness: 5/5',
    },
    {
      'name': 'Fireball',
      'game': 'Hearthstone',
      'type': 'Spell',
      'details': 'Mana Cost: 4\nDeal 6 damage.',
    },
    {
      'name': 'Chillwind Yeti',
      'game': 'Hearthstone',
      'type': 'Minion',
      'details': 'Mana Cost: 4\nAttack: 4\nHealth: 5',
    },
  ];

  void showCardDetails(Map<String, String> card) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(card['name']!),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Game: ${card['game']}'),
            const SizedBox(height: 8),
            Text('Type: ${card['type']}'),
            const SizedBox(height: 16),
            Text(card['details']!),
          ],
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
    final filteredCards = cards.where((card) {
      final matchesGame =
          selectedGame == 'All Games' ||
          card['game'] == selectedGame;

      final matchesSearch = card['name']!
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      return matchesGame && matchesSearch;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Card Database',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),

        // Search bar
        TextField(
          decoration: InputDecoration(
            hintText: 'Search for a card...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
        ),

        const SizedBox(height: 20),

        // Game selection
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

        Text(
          '${filteredCards.length} cards found',
          style: const TextStyle(color: Colors.grey),
        ),

        const SizedBox(height: 12),

        // Card list
        Expanded(
          child: filteredCards.isEmpty
              ? const Center(
                  child: Text('No cards found.'),
                )
              : ListView.builder(
                  itemCount: filteredCards.length,
                  itemBuilder: (context, index) {
                    final card = filteredCards[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const Icon(
                          Icons.style,
                          color: Colors.blueAccent,
                        ),
                        title: Text(card['name']!),
                        subtitle: Text(
                          '${card['game']} - ${card['type']}',
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                        ),
                        onTap: () => showCardDetails(card),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
