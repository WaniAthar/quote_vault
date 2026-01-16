import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/quote.dart';
import '../../providers/quote_provider.dart';
import '../../providers/theme_provider.dart';

class QuoteCard extends StatefulWidget {
  final Quote quote;
  final VoidCallback? onTap;

  const QuoteCard({super.key, required this.quote, this.onTap});

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimationConfiguration.staggeredList(
      position: 0,
      duration: const Duration(milliseconds: 600),
      child: SlideAnimation(
        verticalOffset: 40.0,
        curve: Curves.easeOutCubic,
        child: FadeInAnimation(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.3)
                      : Colors.grey.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                  spreadRadius: 0,
                ),
              ],
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.black.withOpacity(0.03),
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: widget.onTap,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer.withOpacity(
                            0.3,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          widget.quote.category.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Quote Text
                      Text(
                        widget.quote.text,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                          letterSpacing: -0.5,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Footer (Author + Actions)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.quote.author ?? 'Unknown',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Action Buttons
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildActionButton(
                                context,
                                icon: Icons.playlist_add_rounded,
                                onTap: () =>
                                    _showAddToCollectionBottomSheet(context),
                                tooltip: 'Add to collection',
                              ),
                              const SizedBox(width: 8),
                              _buildActionButton(
                                context,
                                icon: Icons.ios_share_rounded,
                                onTap: () => _showShareBottomSheet(context),
                                tooltip: 'Share',
                              ),
                              const SizedBox(width: 8),
                              Consumer<QuoteProvider>(
                                builder: (context, quoteProvider, child) {
                                  final isFavorited = widget.quote.isFavorite;
                                  return _buildActionButton(
                                    context,
                                    icon: isFavorited
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_border_rounded,
                                    color: isFavorited ? Colors.red : null,
                                    onTap: () async {
                                      await quoteProvider.toggleFavorite(
                                        widget.quote,
                                      );
                                    },
                                    tooltip: 'Favorite',
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
    required String tooltip,
  }) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 20,
            color: color ?? theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  void _showAddToCollectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Consumer<QuoteProvider>(
            builder: (context, quoteProvider, child) {
              final collections = quoteProvider.collections;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Add to Collection',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (collections.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(
                              Icons.collections_bookmark_outlined,
                              size: 48,
                              color: theme.colorScheme.secondary,
                            ),
                            const SizedBox(height: 16),
                            const Text('No collections yet'),
                            const SizedBox(height: 8),
                            const Text(
                              'Create a collection in the Collections tab first',
                              style: TextStyle(color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: collections.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final collection = collections[index];
                          return InkWell(
                            onTap: () async {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Adding to collection...'),
                                  duration: Duration(seconds: 1),
                                ),
                              );

                              await quoteProvider.addQuoteToCollection(
                                collection.id,
                                widget.quote.id!,
                              );

                              if (context.mounted) {
                                if (quoteProvider.lastError != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Error: ${quoteProvider.lastError}',
                                      ),
                                      backgroundColor: theme.colorScheme.error,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Added to ${collection.name}',
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              }
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: theme.colorScheme.outline.withOpacity(
                                    0.1,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.folder_outlined,
                                    color: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    collection.name,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.add_circle_outline,
                                    color: theme.colorScheme.secondary,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _showShareBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final quoteText =
        '"${widget.quote.text}"\n\n- ${widget.quote.author ?? 'Unknown Author'}';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Share Quote',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.text_fields_rounded,
                  color: theme.colorScheme.primary,
                ),
              ),
              title: const Text(
                'Share as Text',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Share.share(quoteText);
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Share as Image',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStyleOption(context, 'Modern', [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ]),
                  _buildStyleOption(context, 'Nature', [
                    const Color(0xFF2D6A4F),
                    const Color(0xFF52B788),
                  ]),
                  _buildStyleOption(context, 'Ocean', [
                    const Color(0xFF0077B6),
                    const Color(0xFF00B4D8),
                  ]),
                  _buildStyleOption(context, 'Midnight', [
                    const Color(0xFF2C3E50),
                    const Color(0xFF4CA1AF),
                  ]),
                  _buildStyleOption(context, 'Sunset', [
                    const Color(0xFFDD5E89),
                    const Color(0xFFF7BB97),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStyleOption(
    BuildContext context,
    String name,
    List<Color> colors,
  ) {
    return GestureDetector(
      onTap: () => _shareAsImage(context, colors),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colors[0].withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Future<void> _shareAsImage(BuildContext context, List<Color> colors) async {
    Navigator.of(context).pop();

    try {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Generating image...')));

      final screenshotController = ScreenshotController();

      // Create a dedicated widget for image generation to ensure consistent styling
      final quoteWidget = Container(
        width: 1080, // High resolution width
        height: 1080, // Square aspect ratio
        padding: const EdgeInsets.all(80),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.format_quote_rounded,
              color: Colors.white70,
              size: 80,
            ),
            const SizedBox(height: 40),
            Text(
              widget.quote.text,
              style: GoogleFonts.inter(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
              maxLines: 10,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 60),
            Container(
              width: 100,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              widget.quote.author ?? 'Unknown',
              style: GoogleFonts.inter(
                fontSize: 36,
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Text(
              'QuoteVault',
              style: GoogleFonts.inter(
                fontSize: 24,
                color: Colors.white.withOpacity(0.5),
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      );

      final imageBytes = await screenshotController.captureFromWidget(
        quoteWidget,
        context: context,
        pixelRatio: 2.0, // High quality
        delay: const Duration(milliseconds: 100),
      );

      final directory = await getTemporaryDirectory();
      final imagePath =
          '${directory.path}/quote_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(imagePath);
      await file.writeAsBytes(imageBytes);

      await Share.shareXFiles([
        XFile(file.path),
      ], text: 'Shared via QuoteVault');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error sharing image: $e')));
      }
    }
  }
}
