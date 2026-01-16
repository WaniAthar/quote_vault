import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/auth_test_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/collections/collection_detail_screen.dart';
import '../models/collection.dart';

class AppRouter {
  static GoRouter? _router;

  static GoRouter createRouter(BuildContext context) {
    if (_router != null) return _router!;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    _router = GoRouter(
      initialLocation: '/',
      refreshListenable: authProvider,
      redirect: (context, state) {
        final isAuthenticated = authProvider.isAuthenticated;
        final isAuthRoute =
            state.matchedLocation == '/login' ||
            state.matchedLocation == '/auth-test';
        final isGoingToAuth = state.matchedLocation.startsWith('/auth');

        // If not authenticated and not on auth routes, redirect to login
        if (!isAuthenticated && !isAuthRoute && !isGoingToAuth) {
          return '/login';
        }

        // If authenticated and on login page, redirect to home
        if (isAuthenticated && state.matchedLocation == '/login') {
          return '/';
        }

        return null;
      },
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/collection/:id',
          builder: (context, state) {
            final collection = state.extra as Collection;
            return CollectionDetailScreen(collection: collection);
          },
        ),
        GoRoute(
          path: '/auth-test',
          builder: (context, state) => const AuthTestScreen(),
        ),
        // Deep linking route for auth callbacks
        GoRoute(
          path: '/auth/callback',
          builder: (context, state) {
            // Handle auth callback from email confirmation
            final code = state.uri.queryParameters['code'];
            final error = state.uri.queryParameters['error'];

            if (code != null) {
              // Handle successful auth callback
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Email confirmed successfully! You can now sign in.',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
                context.go('/login');
              });
            } else if (error != null) {
              // Handle auth error
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Authentication error: $error'),
                    backgroundColor: Colors.red,
                  ),
                );
                context.go('/login');
              });
            }

            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Page not found'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );

    return _router!;
  }
}
