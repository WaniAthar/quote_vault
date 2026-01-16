import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../constants/app_constants.dart';

class AuthTestScreen extends StatefulWidget {
  const AuthTestScreen({super.key});

  @override
  State<AuthTestScreen> createState() => _AuthTestScreenState();
}

class _AuthTestScreenState extends State<AuthTestScreen> {
  String _testResult = 'Testing...';
  bool _isTesting = true;

  @override
  void initState() {
    super.initState();
    _testSupabaseConnection();
  }

  Future<void> _testSupabaseConnection() async {
    try {
      // Test basic connection
      final supabase = Supabase.instance.client;

      // Test if we can access the client
      final user = supabase.auth.currentUser;

      setState(() {
        _testResult =
            '✓ Supabase client initialized successfully\n'
            'Current user: ${user?.email ?? 'None'}\n'
            'URL: ${AppConstants.supabaseUrl}\n'
            'Anon Key: ${AppConstants.supabaseAnonKey.substring(0, 20)}...';
        _isTesting = false;
      });

      // Test a simple query to check if tables exist
      try {
        final response = await supabase.from('quotes').select('count').limit(1);
        setState(() {
          _testResult +=
              '\n✓ Database connection successful\n✓ Quotes table accessible';
        });
      } catch (dbError) {
        setState(() {
          _testResult +=
              '\n✗ Database error: $dbError\n'
              'Please check if database tables are created and RLS policies are set up.';
        });
      }
    } catch (error) {
      setState(() {
        _testResult =
            '✗ Connection failed: $error\n'
            'Please check:\n'
            '1. Supabase URL and anon key\n'
            '2. Internet connection\n'
            '3. Supabase project status';
        _isTesting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth Test'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Supabase Connection Test',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isTesting
                    ? Theme.of(context).colorScheme.surfaceContainerHighest
                    : (_testResult.contains('✗')
                          ? Theme.of(context).colorScheme.errorContainer
                          : Theme.of(context).colorScheme.primaryContainer),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isTesting
                      ? Theme.of(context).colorScheme.outline
                      : (_testResult.contains('✗')
                            ? Theme.of(context).colorScheme.error
                            : Theme.of(context).colorScheme.primary),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (_isTesting)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else if (_testResult.contains('✗'))
                        Icon(
                          Icons.error,
                          color: Theme.of(context).colorScheme.error,
                        )
                      else
                        Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      const SizedBox(width: 8),
                      Text(
                        _isTesting ? 'Testing...' : 'Test Result',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _isTesting
                              ? Theme.of(context).colorScheme.onSurface
                              : (_testResult.contains('✗')
                                    ? Theme.of(context).colorScheme.error
                                    : Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _testResult,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (!_isTesting && _testResult.contains('✗')) ...[
              Text(
                'Troubleshooting Steps:',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '1. Verify Supabase URL and anon key in app_constants.dart\n'
                '2. Check if Supabase project is active\n'
                '3. Ensure database tables are created (see README)\n'
                '4. Check internet connection\n'
                '5. Verify RLS policies are set up correctly',
                style: TextStyle(fontSize: 14),
              ),
            ],
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isTesting
                    ? null
                    : () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Back to Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
