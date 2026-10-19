
import 'package:flutter/material.dart';
import 'my_decks_page.dart';
import 'card_database_page.dart';
import 'match_history_page.dart';

void main() {
  runApp(const CardTrackerApp());
}

class CardTrackerApp extends StatelessWidget {
  const CardTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF121826),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedPage = 0;

  final List<String> pages = [
    'Dashboard',
    'My Decks',
    'Card Database',
    'Match History',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Tracker'),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: Row(
        children: [
          // Sidebar navigation
          Container(
            width: 200,
            color: const Color(0xFF1E293B),
            child: Column(
              children: List.generate(pages.length, (index) {
                return ListTile(
                  title: Text(pages[index]),
                  selected: selectedPage == index,
                  selectedTileColor: Colors.blueGrey,
                  onTap: () {
                    setState(() {
                      selectedPage = index;
                    });
                  },
                );
              }),
            ),
          ),

          // Main content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: selectedPage == 0
                ? buildDashboard()
                : selectedPage == 1
                    ? const MyDecksPage()
                    : selectedPage == 2
                        ? const CardDatabasePage()
                        :selectedPage == 3
                            ? const MatchHistoryPage()
                            : Center(
                                child: Text(
                                  pages[selectedPage],
                                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Welcome to Card Tracker!',
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 24),

        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            buildStatCard('Total Matches', '24'),
            buildStatCard('Wins', '15'),
            buildStatCard('Losses', '9'),
            buildStatCard('Win Rate', '62.5%'),
          ],
        ),

        const SizedBox(height: 32),
        const Text(
          'Recent Matches',
          style: TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 16),
        const ListTile(
          title: Text('Match vs Player 2'),
          trailing: Text(
            'WIN',
            style: TextStyle(color: Colors.green),
          ),
        ),
        const ListTile(
          title: Text('Match vs Player 3'),
          trailing: Text(
            'LOSS',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }

  Widget buildStatCard(String title, String value) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
