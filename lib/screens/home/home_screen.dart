import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../models/quote.dart';
import '../../models/collection.dart';
import '../../providers/auth_provider.dart';
import '../../providers/quote_provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/notification_service.dart';
import '../../widgets/quote_card.dart';
import '../../constants/app_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late PageStorageBucket _bucket;
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bucket = PageStorageBucket();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    final quoteProvider = Provider.of<QuoteProvider>(context, listen: false);
    await quoteProvider.loadCategories();
    await quoteProvider.loadQuoteOfTheDay();
    await quoteProvider.loadQuotes();
    await quoteProvider.loadFavorites();
    await quoteProvider.loadCollections();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final quoteProvider = Provider.of<QuoteProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'QuoteVault',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w800,
                fontSize: 22,
                letterSpacing: -0.5,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () {
              themeProvider.setThemeMode(
                themeProvider.isDarkMode ? ThemeMode.light : ThemeMode.dark,
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.logout_rounded,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () async {
              await authProvider.signOut();
            },
          ),
        ],
      ),
      body: PageStorage(
        bucket: _bucket,
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildHomeTab(quoteProvider),
            _buildBrowseTab(quoteProvider),
            _buildFavoritesTab(quoteProvider),
            _buildCollectionsTab(quoteProvider),
            _buildSettingsTab(themeProvider, quoteProvider),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        indicatorColor: theme.colorScheme.primaryContainer,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore_rounded),
            label: 'Browse',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border_rounded),
            selectedIcon: Icon(Icons.favorite_rounded),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(Icons.collections_bookmark_outlined),
            selectedIcon: Icon(Icons.collections_bookmark_rounded),
            label: 'Collections',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab(QuoteProvider quoteProvider) {
    if (quoteProvider.isLoading && quoteProvider.quotes.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (quoteProvider.quotes.isEmpty && !quoteProvider.isLoading) {
      return _buildEmptyState(
        context,
        Icons.format_quote_rounded,
        'Welcome to QuoteVault',
        'Your daily source of inspiration is empty. Tap the button below to populate the database with sample quotes!',
        action: FilledButton.icon(
          onPressed: () => _handleSeedDatabase(quoteProvider),
          icon: const Icon(Icons.auto_awesome_rounded),
          label: const Text('Populate with 100+ Quotes'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      );
    }

    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () => quoteProvider.loadQuoteOfTheDay(),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          // Quote of the Day Section
          if (quoteProvider.quoteOfTheDay != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text(
                'Quote of the Day',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.format_quote_rounded,
                    color: theme.colorScheme.onPrimary.withOpacity(0.5),
                    size: 48,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    quoteProvider.quoteOfTheDay!.text,
                    style: GoogleFonts.inter(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      quoteProvider.quoteOfTheDay!.author ?? 'Unknown Author',
                      style: GoogleFonts.inter(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Categories Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              'Explore Categories',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
          ),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: AppConstants.categories.length,
              itemBuilder: (context, index) {
                final category = AppConstants.categories[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: FilterChip(
                    label: Text(category),
                    labelStyle: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: theme.colorScheme.outline.withOpacity(0.3),
                      ),
                    ),
                    backgroundColor: theme.colorScheme.surface,
                    selectedColor: theme.colorScheme.primaryContainer,
                    onSelected: (selected) {
                      if (selected) {
                        quoteProvider.filterByCategory(category);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            setState(() {
                              _selectedIndex = 1; // Switch to browse tab
                            });
                          }
                        });
                      }
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // Recent Quotes Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Quotes',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => _selectedIndex = 1),
                  child: const Text('See All'),
                ),
              ],
            ),
          ),
          ...quoteProvider.quotes
              .take(5)
              .map((quote) => QuoteCard(quote: quote)),
        ],
      ),
    );
  }

  Widget _buildBrowseTab(QuoteProvider quoteProvider) {
    final theme = Theme.of(context);
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search quotes or authors...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          quoteProvider.clearSearch();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest
                    .withOpacity(0.3),
                contentPadding: const EdgeInsets.all(16),
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  quoteProvider.clearSearch();
                }
              },
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  quoteProvider.searchQuotes(value);
                }
              },
            ),
          ),
        ),

        // Categories filter
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: quoteProvider.categories.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: const Text('All'),
                    selected: quoteProvider.currentCategory == null,
                    onSelected: (selected) {
                      quoteProvider.filterByCategory(null);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              }
              final category = quoteProvider.categories[index - 1];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(category),
                  selected: quoteProvider.currentCategory == category,
                  onSelected: (selected) {
                    quoteProvider.filterByCategory(selected ? category : null);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 16),

        // Quotes list
        Expanded(
          child: quoteProvider.quotes.isEmpty && !quoteProvider.isLoading
              ? _buildEmptyState(
                  context,
                  Icons.search_off_rounded,
                  'No quotes found',
                  quoteProvider.searchQuery != null
                      ? 'We couldn\'t find any quotes matching "${quoteProvider.searchQuery}".'
                      : 'The database is empty.',
                  action: quoteProvider.searchQuery == null
                      ? FilledButton.icon(
                          onPressed: () => _handleSeedDatabase(quoteProvider),
                          icon: const Icon(Icons.auto_awesome_rounded),
                          label: const Text('Populate Database'),
                        )
                      : null,
                )
              : RefreshIndicator(
                  onRefresh: () => quoteProvider.loadQuotes(refresh: true),
                  child: AnimationLimiter(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount:
                          quoteProvider.quotes.length +
                          (quoteProvider.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == quoteProvider.quotes.length) {
                          // Load more indicator
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            quoteProvider.loadQuotes();
                          });
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final quote = quoteProvider.quotes[index];
                        return QuoteCard(quote: quote);
                      },
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildFavoritesTab(QuoteProvider quoteProvider) {
    if (quoteProvider.isLoading && quoteProvider.favorites.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (quoteProvider.favorites.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => quoteProvider.loadFavorites(),
        child: Stack(
          children: [
            ListView(), // Allows PTR
            _buildEmptyState(
              context,
              Icons.favorite_border_rounded,
              'No favorites yet',
              'Tap the heart icon on any quote to save it here for quick access.',
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => quoteProvider.loadFavorites(),
      child: AnimationLimiter(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: quoteProvider.favorites.length,
          itemBuilder: (context, index) {
            return QuoteCard(quote: quoteProvider.favorites[index]);
          },
        ),
      ),
    );
  }

  Widget _buildCollectionsTab(QuoteProvider quoteProvider) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Collections',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              FilledButton.icon(
                onPressed: () =>
                    _showCreateCollectionDialog(context, quoteProvider),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('New'),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: quoteProvider.isLoading && quoteProvider.collections.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : quoteProvider.collections.isEmpty
              ? RefreshIndicator(
                  onRefresh: () => quoteProvider.loadCollections(),
                  child: Stack(
                    children: [
                      ListView(),
                      _buildEmptyState(
                        context,
                        Icons.collections_bookmark_outlined,
                        'No collections',
                        'Create custom collections to organize your favorite quotes.',
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => quoteProvider.loadCollections(),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: quoteProvider.collections.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final collection = quoteProvider.collections[index];
                      return Container(
                        decoration: BoxDecoration(
                          color:
                              theme.cardTheme.color ??
                              theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: theme.colorScheme.outline.withOpacity(0.1),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer
                                  .withOpacity(0.5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.folder_open_rounded,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          title: Text(
                            collection.name,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: FutureBuilder<int>(
                            future: quoteProvider.getCollectionQuoteCount(
                              collection.id,
                            ),
                            builder: (context, snapshot) {
                              return Text(
                                '${snapshot.data ?? collection.quoteCount} quotes',
                                style: TextStyle(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              );
                            },
                          ),
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          onTap: () => _viewCollection(context, collection),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    IconData icon,
    String title,
    String message, {
    Widget? action,
  }) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withOpacity(
                  0.3,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: theme.colorScheme.primary.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[const SizedBox(height: 32), action],
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTab(
    ThemeProvider themeProvider,
    QuoteProvider quoteProvider,
  ) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Appearance',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 16),
        _buildSettingsCard([
          SwitchListTile(
            title: const Text(
              'Dark Mode',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            secondary: const Icon(Icons.dark_mode_outlined),
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.setThemeMode(
                value ? ThemeMode.dark : ThemeMode.light,
              );
            },
          ),
          ListTile(
            title: const Text(
              'Font Size',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            leading: const Icon(Icons.text_fields_rounded),
            subtitle: Slider(
              value: themeProvider.fontSize,
              min: 12,
              max: 24,
              divisions: 6,
              onChanged: (value) {
                themeProvider.setFontSize(value);
              },
            ),
          ),
        ]),

        const SizedBox(height: 24),
        Text(
          'Theme',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:
                Theme.of(context).cardTheme.color ??
                Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildThemeOption(
                context,
                themeProvider,
                AppTheme.orange,
                Colors.orange,
                'Orange',
              ),
              _buildThemeOption(
                context,
                themeProvider,
                AppTheme.nature,
                Colors.green,
                'Nature',
              ),
              _buildThemeOption(
                context,
                themeProvider,
                AppTheme.ocean,
                Colors.blue,
                'Ocean',
              ),
              _buildThemeOption(
                context,
                themeProvider,
                AppTheme.minimal,
                Colors.black,
                'Minimal',
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        Text(
          'General',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 16),
        _buildSettingsCard([
          ListTile(
            title: const Text(
              'Profile',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            leading: const Icon(Icons.person_outline_rounded),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push('/profile'),
          ),
          ListTile(
            title: const Text(
              'Daily Notifications',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            leading: const Icon(Icons.notifications_outlined),
            subtitle: const Text('Set reminder time'),
            onTap: () => _showNotificationTimePicker(context),
          ),
          ListTile(
            title: const Text(
              'Seed Database',
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red),
            ),
            leading: const Icon(Icons.storage_rounded, color: Colors.red),
            onTap: () => _handleSeedDatabase(quoteProvider),
          ),
        ]),
      ],
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color:
            Theme.of(context).cardTheme.color ??
            Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  void _showCreateCollectionDialog(
    BuildContext context,
    QuoteProvider quoteProvider,
  ) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Create Collection',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Creating collection...')),
                );
                await quoteProvider.createCollection(
                  nameController.text,
                  descriptionController.text.isEmpty
                      ? null
                      : descriptionController.text,
                );
                if (context.mounted) context.pop();
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _viewCollection(BuildContext context, Collection collection) {
    context.push('/collection/${collection.id}', extra: collection);
  }

  Widget _buildThemeOption(
    BuildContext context,
    ThemeProvider themeProvider,
    AppTheme theme,
    Color color,
    String label,
  ) {
    final isSelected = themeProvider.selectedTheme == theme;
    return GestureDetector(
      onTap: () => themeProvider.setSelectedTheme(theme),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? color : Colors.transparent,
                width: 2,
              ),
            ),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : null,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? color
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSeedDatabase(QuoteProvider quoteProvider) async {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Seeding database...')));
    await quoteProvider.seedDatabase();
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Done!')));
    }
  }

  void _showNotificationTimePicker(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      await NotificationService().scheduleDailyQuoteNotification(pickedTime);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Notification set!')));
      }
    }
  }
}
