import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/quote.dart';
import '../../providers/quote_provider.dart';
import '../../widgets/quote_card.dart';

class QuoteDetailScreen extends StatelessWidget {
  final String? quoteId;

  const QuoteDetailScreen({super.key, this.quoteId});

  @override
  Widget build(BuildContext context) {
    final quoteProvider = Provider.of<QuoteProvider>(context);
    final theme = Theme.of(context);

    // If quoteId is provided, try to find the quote
    Quote? quote;
    if (quoteId != null && quoteId!.isNotEmpty) {
      try {
        quote = quoteProvider.quotes.firstWhere((q) => q.id == quoteId);
      } catch (_) {
        // If not found in current list, check if it's the quote of the day
        if (quoteProvider.quoteOfTheDay?.id == quoteId) {
          quote = quoteProvider.quoteOfTheDay;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quote',
          style: GoogleFonts.inter(fontWeight: FontWeight.w800),
        ),
      ),
      body: Center(
        child: quote != null
            ? QuoteCard(quote: quote)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.format_quote_rounded,
                    size: 64,
                    color: theme.colorScheme.outline.withOpacity(0.3),
                  ),
                  const SizedBox(height: 24),
                  Text('Quote not found', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 12),
                  const Text('It might have been removed or updated.'),
                ],
              ),
      ),
    );
  }
}
