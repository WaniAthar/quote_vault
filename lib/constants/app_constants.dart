class AppConstants {
  // Supabase Configuration
  // Replace these with your actual Supabase project URL and anon key
  static const String supabaseUrl = 'https://tdvjixmwrvgdkgklflcb.supabase.co';
  static const String supabaseAnonKey = 'sb_publishable_Vfl9Ar31uXxqyBXXJF8Kog_LKvk0Rj4';

  // App Constants
  static const String appName = 'QuoteVault';

  // Categories
  static const List<String> categories = [
    'Motivation',
    'Love',
    'Success',
    'Wisdom',
    'Humor',
  ];

  // Notification Settings
  static const String dailyQuoteNotificationChannel = 'daily_quote';
  static const String dailyQuoteNotificationId = 'daily_quote_id';

  // Storage
  static const String profileImagesBucket = 'profile_images';
  static const String quoteImagesBucket = 'quote_images';

  // Pagination
  static const int quotesPerPage = 20;

  // Animation durations
  static const Duration animationDuration = Duration(milliseconds: 300);
}
