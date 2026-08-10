import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final List<FavoriteSign> signs = [
    const FavoriteSign(
      word: 'Hello',
      category: 'Greetings',
      icon: Icons.waving_hand_rounded,
    ),
    const FavoriteSign(
      word: 'Thank You',
      category: 'Greetings',
      icon: Icons.volunteer_activism_rounded,
    ),
    const FavoriteSign(
      word: 'Good Morning',
      category: 'Greetings',
      icon: Icons.wb_sunny_rounded,
    ),
    const FavoriteSign(
      word: 'Sorry',
      category: 'Basic Words',
      icon: Icons.sentiment_dissatisfied_rounded,
    ),
    const FavoriteSign(
      word: 'Please',
      category: 'Basic Words',
      icon: Icons.favorite_border_rounded,
    ),
  ];

  void removeFavorite(int index) {
    final removed = signs[index];

    setState(() {
      signs.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${removed.word} removed from favorites'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(() {
              signs.insert(index, removed);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFBF5),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF29263D),
          ),
        ),
        title: const Text(
          'Saved Signs',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xFF29263D),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: signs.isEmpty
            ? _buildEmptyState()
            : SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),

              const SizedBox(height: 22),

              ...List.generate(
                signs.length,
                    (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _FavoriteCard(
                    sign: signs[index],
                    onRemove: () => removeFavorite(index),
                    onOpen: () {
                      _openSign(signs[index]);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE9FA),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.bookmark_rounded,
              color: Color(0xFF6C63A8),
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Saved Signs',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF29263D),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${signs.length} signs saved for revision',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF777281),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Color(0xFFEDE9FA),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.bookmark_border_rounded,
                size: 50,
                color: Color(0xFF6C63A8),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Saved Signs',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF29263D),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Save signs while learning and they will appear here for quick revision.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF777281),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openSign(FavoriteSign sign) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFFFFBF5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 55,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFD8D3DF),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: 130,
                height: 130,
                decoration: const BoxDecoration(
                  color: Color(0xFFEDE9FA),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  sign.icon,
                  size: 65,
                  color: const Color(0xFF6C63A8),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                sign.word,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF29263D),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                sign.category,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF777281),
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Sign demonstration will appear here.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF8A8695),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final FavoriteSign sign;
  final VoidCallback onRemove;
  final VoidCallback onOpen;

  const _FavoriteCard({
    required this.sign,
    required this.onRemove,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFE7E2EC),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE9FA),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  sign.icon,
                  color: const Color(0xFF6C63A8),
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sign.word,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF29263D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sign.category,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF8A8695),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onRemove,
                tooltip: 'Remove',
                icon: const Icon(
                  Icons.bookmark_rounded,
                  color: Color(0xFF6C63A8),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF9994A3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FavoriteSign {
  final String word;
  final String category;
  final IconData icon;

  const FavoriteSign({
    required this.word,
    required this.category,
    required this.icon,
  });
}