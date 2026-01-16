import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/quote.dart';
import '../models/collection.dart';
import '../constants/app_constants.dart';

class QuoteService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Fetch quotes with pagination and filtering
  Future<List<Quote>> fetchQuotes({
    int limit = AppConstants.quotesPerPage,
    int offset = 0,
    String? category,
    String? searchQuery,
    String? author,
  }) async {
    try {
      var query = _supabase.from('quotes').select();

      // Apply filters
      if (category != null && category.isNotEmpty) {
        query = query.eq('category', category);
      }

      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query.or(
          'text.ilike.%$searchQuery%,author.ilike.%$searchQuery%',
        );
      }

      if (author != null && author.isNotEmpty) {
        query = query.ilike('author', '%$author%');
      }

      // Order by created_at desc and apply pagination
      final response = await query
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (response as List).map((json) => Quote.fromJson(json)).toList();
    } catch (error) {
      throw Exception('Failed to fetch quotes: $error');
    }
  }

  // Get quote of the day
  Future<Quote?> getQuoteOfTheDay() async {
    try {
      // Get total quotes count first
      final totalQuotes = await _getTotalQuotesCount();
      if (totalQuotes == 0) return null;

      // Use the day of the year as a seed to ensure it changes daily
      final now = DateTime.now();
      // Create a unique integer for the specific day (e.g. 2023305 for year 2023, day 305)
      // This avoids the issue where milliseconds modulo total count might align periodically
      final daySeed = now.year * 1000 + int.parse('${now.month}${now.day}');

      final random = Random(daySeed);
      final quoteIndex = random.nextInt(totalQuotes);

      final response = await _supabase
          .from('quotes')
          .select()
          .range(quoteIndex, quoteIndex)
          .limit(1);

      if (response.isEmpty) return null;

      return Quote.fromJson(response[0]);
    } catch (error) {
      throw Exception('Failed to get quote of the day: $error');
    }
  }

  // Get total quotes count
  Future<int> _getTotalQuotesCount() async {
    try {
      final response = await _supabase.from('quotes').select('id');

      return (response as List).length;
    } catch (error) {
      return 0;
    }
  }

  // Get categories
  Future<List<String>> getCategories() async {
    try {
      final response = await _supabase
          .from('quotes')
          .select('category')
          .order('category');

      final categories = (response as List)
          .map((item) => item['category'] as String)
          .toSet()
          .toList();

      return categories;
    } catch (error) {
      throw Exception('Failed to fetch categories: $error');
    }
  }

  // Toggle favorite
  Future<void> toggleFavorite(String quoteId, bool isFavorite) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      if (isFavorite) {
        // Add to favorites
        await _supabase.from('user_favorites').insert({
          'user_id': userId,
          'quote_id': quoteId,
        });
      } else {
        // Remove from favorites
        await _supabase
            .from('user_favorites')
            .delete()
            .eq('user_id', userId)
            .eq('quote_id', quoteId);
      }
    } catch (error) {
      throw Exception('Failed to toggle favorite: $error');
    }
  }

  // Get user's favorites
  Future<List<Quote>> getUserFavorites() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _supabase
          .from('user_favorites')
          .select('''
            quote_id,
            quotes!inner(*)
          ''')
          .eq('user_id', userId);

      return (response as List)
          .map((item) => Quote.fromJson(item['quotes']))
          .toList();
    } catch (error) {
      throw Exception('Failed to fetch favorites: $error');
    }
  }

  Future<List<Collection>> getUserCollections() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      // First fetch collections
      final response = await _supabase
          .from('collections')
          .select()
          .eq('user_id', userId);

      final collections = (response as List).map((json) {
        return Collection.fromJson(json);
      }).toList();

      // Then manually fetch counts for each collection
      final List<Collection> result = [];

      for (final collection in collections) {
        int count = 0;
        try {
          final countResponse = await _supabase
              .from('collection_quotes')
              .select('id')
              .eq('collection_id', collection.id);
          count = (countResponse as List).length;
        } catch (e) {
          // Ignore table not found error for counts
          print(
            'QuoteService: Could not fetch count for collection ${collection.name}: $e',
          );
        }

        result.add(
          Collection(
            id: collection.id,
            userId: collection.userId,
            name: collection.name,
            description: collection.description,
            createdAt: collection.createdAt,
            updatedAt: collection.updatedAt,
            quoteCount: count,
          ),
        );
      }

      return result;
    } catch (error) {
      print('QuoteService: Error fetching collections: $error');
      // Fallback to empty list instead of crashing UI
      return [];
    }
  }

  Future<void> createCollection(String name, String? description) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      await _supabase.from('collections').insert({
        'user_id': userId,
        'name': name,
        'description': description,
      });
    } catch (error) {
      throw Exception('Failed to create collection: $error');
    }
  }

  Future<void> addQuoteToCollection(String collectionId, String quoteId) async {
    try {
      await _supabase.from('collection_quotes').insert({
        'collection_id': collectionId,
        'quote_id': quoteId,
      });
    } catch (error) {
      throw Exception('Failed to add quote to collection: $error');
    }
  }

  Future<void> removeQuoteFromCollection(
    String collectionId,
    String quoteId,
  ) async {
    try {
      await _supabase
          .from('collection_quotes')
          .delete()
          .eq('collection_id', collectionId)
          .eq('quote_id', quoteId);
    } catch (error) {
      throw Exception('Failed to remove quote from collection: $error');
    }
  }

  Future<int> getCollectionQuoteCount(String collectionId) async {
    try {
      final response = await _supabase
          .from('collection_quotes')
          .select('id')
          .eq('collection_id', collectionId);
      return (response as List).length;
    } catch (e) {
      return 0;
    }
  }

  Future<List<Quote>> getCollectionQuotes(String collectionId) async {
    try {
      final response = await _supabase
          .from('collection_quotes')
          .select('''
            quote_id,
            quotes!inner(*)
          ''')
          .eq('collection_id', collectionId);

      return (response as List)
          .map((item) => Quote.fromJson(item['quotes']))
          .toList();
    } catch (error) {
      throw Exception('Failed to fetch collection quotes: $error');
    }
  }

  // Seed initial quotes
  Future<void> seedInitialQuotes() async {
    try {
      final List<Map<String, dynamic>> quotes = [
        // Motivation
        {
          'text': 'The only way to do great work is to love what you do.',
          'author': 'Steve Jobs',
          'category': 'Motivation',
        },
        {
          'text': 'Believe you can and you\'re halfway there.',
          'author': 'Theodore Roosevelt',
          'category': 'Motivation',
        },
        {
          'text':
              'The future belongs to those who believe in the beauty of their dreams.',
          'author': 'Eleanor Roosevelt',
          'category': 'Motivation',
        },
        {
          'text': 'You miss 100% of the shots you don\'t take.',
          'author': 'Wayne Gretzky',
          'category': 'Motivation',
        },
        {
          'text': 'The best way to predict the future is to create it.',
          'author': 'Peter Drucker',
          'category': 'Motivation',
        },
        {
          'text': 'The secret of getting ahead is getting started.',
          'author': 'Mark Twain',
          'category': 'Motivation',
        },
        {
          'text': 'It always seems impossible until it\'s done.',
          'author': 'Nelson Mandela',
          'category': 'Motivation',
        },
        {
          'text': 'Don\'t stop when you\'re tired. Stop when you\'re done.',
          'author': 'Unknown',
          'category': 'Motivation',
        },
        {
          'text': 'Opportunities don\'t happen, you create them.',
          'author': 'Chris Grosser',
          'category': 'Motivation',
        },
        {
          'text': 'Start where you are. Use what you have. Do what you can.',
          'author': 'Arthur Ashe',
          'category': 'Motivation',
        },

        // Love
        {
          'text': 'The best thing to hold onto in life is each other.',
          'author': 'Audrey Hepburn',
          'category': 'Love',
        },
        {
          'text': 'Love is composed of a single soul inhabiting two bodies.',
          'author': 'Aristotle',
          'category': 'Love',
        },
        {
          'text':
              'I love you not only for what you are, but for what I am when I am with you.',
          'author': 'Roy Croft',
          'category': 'Love',
        },
        {
          'text': 'Where there is love there is life.',
          'author': 'Mahatma Gandhi',
          'category': 'Love',
        },
        {
          'text':
              'You know you\'re in love when you can\'t fall asleep because reality is finally better than your dreams.',
          'author': 'Dr. Seuss',
          'category': 'Love',
        },
        {
          'text':
              'The best and most beautiful things in this world cannot be seen or even heard, but must be felt with the heart.',
          'author': 'Helen Keller',
          'category': 'Love',
        },
        {
          'text':
              'Being deeply loved by someone gives you strength, while loving someone deeply gives you courage.',
          'author': 'Lao Tzu',
          'category': 'Love',
        },
        {
          'text': 'Love is a smoke made with the fume of sighs.',
          'author': 'William Shakespeare',
          'category': 'Love',
        },
        {
          'text': 'If I know what love is, it is because of you.',
          'author': 'Hermann Hesse',
          'category': 'Love',
        },
        {
          'text': 'To love and be loved is to feel the sun from both sides.',
          'author': 'David Viscott',
          'category': 'Love',
        },

        // Success
        {
          'text':
              'Success is not final, failure is not fatal: It is the courage to continue that counts.',
          'author': 'Winston Churchill',
          'category': 'Success',
        },
        {
          'text':
              'Success usually comes to those who are too busy to be looking for it.',
          'author': 'Henry David Thoreau',
          'category': 'Success',
        },
        {
          'text': 'The road to success is always under construction.',
          'author': 'Lily Tomlin',
          'category': 'Success',
        },
        {
          'text':
              'Success is the sum of small efforts, repeated day in and day out.',
          'author': 'Robert Collier',
          'category': 'Success',
        },
        {
          'text':
              'Success is not the key to happiness. Happiness is the key to success.',
          'author': 'Albert Schweitzer',
          'category': 'Success',
        },
        {
          'text': 'Action is the foundational key to all success.',
          'author': 'Pablo Picasso',
          'category': 'Success',
        },
        {
          'text':
              'I find that the harder I work, the more luck I seem to have.',
          'author': 'Thomas Jefferson',
          'category': 'Success',
        },
        {
          'text':
              'The successful warrior is the average man, with laser-like focus.',
          'author': 'Bruce Lee',
          'category': 'Success',
        },
        {
          'text':
              'Successful people do what unsuccessful people are not willing to do.',
          'author': 'Jim Rohn',
          'category': 'Success',
        },
        {
          'text':
              'A dream doesn\'t become reality through magic; it takes sweat, determination and hard work.',
          'author': 'Colin Powell',
          'category': 'Success',
        },

        // Wisdom
        {
          'text': 'The only true wisdom is in knowing you know nothing.',
          'author': 'Socrates',
          'category': 'Wisdom',
        },
        {
          'text': 'Knowledge speaks, but wisdom listens.',
          'author': 'Jimi Hendrix',
          'category': 'Wisdom',
        },
        {
          'text':
              'The wise man does not lay up his own treasures. The more he gives to others, the more he has for his own.',
          'author': 'Lao Tzu',
          'category': 'Wisdom',
        },
        {
          'text': 'Wisdom begins in wonder.',
          'author': 'Socrates',
          'category': 'Wisdom',
        },
        {
          'text': 'Everything has beauty, but not everyone sees it.',
          'author': 'Confucius',
          'category': 'Wisdom',
        },
        {
          'text': 'The journey of a thousand miles begins with one step.',
          'author': 'Lao Tzu',
          'category': 'Wisdom',
        },
        {
          'text':
              'We are what we repeatedly do. Excellence, then, is not an act, but a habit.',
          'author': 'Aristotle',
          'category': 'Wisdom',
        },
        {
          'text':
              'When you change the way you look at things, the things you look at change.',
          'author': 'Wayne Dyer',
          'category': 'Wisdom',
        },
        {
          'text': 'He who has a why to live can bear almost any how.',
          'author': 'Friedrich Nietzsche',
          'category': 'Wisdom',
        },
        {
          'text':
              'The man who moves a mountain begins by carrying away small stones.',
          'author': 'Confucius',
          'category': 'Wisdom',
        },

        // Humor
        {
          'text':
              'Why don\'t scientists trust atoms? Because they make up everything!',
          'author': 'Unknown',
          'category': 'Humor',
        },
        {
          'text':
              'I\'m reading a book on anti-gravity. It\'s impossible to put down!',
          'author': 'Unknown',
          'category': 'Humor',
        },
        {
          'text':
              'Parallel lines have so much in common. It\'s a shame they\'ll never meet.',
          'author': 'Unknown',
          'category': 'Humor',
        },
        {
          'text': 'I used to play piano by ear, but now I use my hands.',
          'author': 'Unknown',
          'category': 'Humor',
        },
        {
          'text':
              'I told my wife she should embrace her mistakes. She gave me a hug.',
          'author': 'Unknown',
          'category': 'Humor',
        },
        {
          'text': 'I\'m not lazy, I\'m just on energy saving mode.',
          'author': 'Unknown',
          'category': 'Humor',
        },
        {
          'text': 'Smile while you still have teeth.',
          'author': 'Unknown',
          'category': 'Humor',
        },
        {
          'text':
              'My bed is a magical place where I suddenly remember everything I forgot to do.',
          'author': 'Unknown',
          'category': 'Humor',
        },
        {
          'text':
              'I told my computer I needed a break, and it replied \'I can\'t process that request.\'',
          'author': 'Unknown',
          'category': 'Humor',
        },
        {
          'text': 'I’m not arguing, I’m just explaining why I’m right.',
          'author': 'Unknown',
          'category': 'Humor',
        },
      ];

      print('QuoteService: Attempting to insert ${quotes.length} quotes...');
      final response = await _supabase.from('quotes').insert(quotes).select();
      print('QuoteService: Successfully inserted ${response.length} quotes.');
    } catch (error) {
      print('QuoteService: Exception during seeding: $error');
      rethrow;
    }
  }

  // Check if quotes are favorited
  Future<List<String>> getFavoritedQuoteIds() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return [];

      final response = await _supabase
          .from('user_favorites')
          .select('quote_id')
          .eq('user_id', userId);

      return (response as List)
          .map((item) => item['quote_id'] as String)
          .toList();
    } catch (error) {
      return [];
    }
  }
}
