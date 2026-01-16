import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/collection.dart';
import '../../models/quote.dart';
import '../../providers/quote_provider.dart';
import '../../widgets/quote_card.dart';

class CollectionDetailScreen extends StatefulWidget {
  final Collection collection;

  const CollectionDetailScreen({super.key, required this.collection});

  @override
  State<CollectionDetailScreen> createState() => _CollectionDetailScreenState();
}

class _CollectionDetailScreenState extends State<CollectionDetailScreen> {
  late Future<List<Quote>> _quotesFuture;

  @override
  void initState() {
    super.initState();
    _loadQuotes();
  }

  void _loadQuotes() {
    final quoteProvider = Provider.of<QuoteProvider>(context, listen: false);
    _quotesFuture = quoteProvider.getCollectionQuotes(widget.collection.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.collection.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDeleteCollection(),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.collection.description != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.collection.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          Expanded(
            child: FutureBuilder<List<Quote>>(
              future: _quotesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final quotes = snapshot.data ?? [];

                if (quotes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.collections_bookmark_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                        const SizedBox(height: 16),
                        const Text('No quotes in this collection yet.'),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: quotes.length,
                  itemBuilder: (context, index) {
                    final quote = quotes[index];
                    return QuoteCard(
                      quote: quote,
                      onTap: () {
                        // Optional: Navigate to full quote view
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDeleteCollection() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Collection'),
        content: Text(
          'Are you sure you want to delete "${widget.collection.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // final quoteProvider = Provider.of<QuoteProvider>(context, listen: false);
      // TODO: Implement deleteCollection in QuoteProvider if not exists
      // await quoteProvider.deleteCollection(widget.collection.id);
      Navigator.pop(context);
    }
  }
}
