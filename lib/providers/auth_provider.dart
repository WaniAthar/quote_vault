import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider with ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  User? _user;
  bool _isLoading = true;

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    _user = _supabase.auth.currentUser;
    _isLoading = false;
    print(
      'Initial auth state: user=${_user?.email}, isAuthenticated=$isAuthenticated',
    );
    notifyListeners();

    _supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final session = data.session;
      final user = session?.user;

      print(
        'Auth state change: event=$event, user=${user?.email}, session=${session != null}',
      );

      _user = user;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<String> signUp(String email, String password, String name) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      if (response.user == null) {
        throw Exception('Sign up failed - no user returned');
      }

      print(
        'Sign up response: user=${response.user?.email}, session=${response.session != null}',
      );

      // Check if email confirmation is required
      if (response.session == null) {
        print('Email confirmation required');
        return 'success_confirmation_required';
      }

      print('Sign up successful - user authenticated: ${response.user?.email}');
      return 'success_authenticated';
    } catch (error) {
      print('Sign up error: $error');
      throw Exception('Sign up failed: $error');
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Sign in failed - invalid credentials');
      }

      print('Sign in successful for: ${response.user?.email}');
    } catch (error) {
      print('Sign in error: $error');
      throw Exception('Sign in failed: $error');
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (error) {
      throw Exception('Sign out failed: $error');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (error) {
      throw Exception('Password reset failed: $error');
    }
  }

  Future<void> updateProfile(String name, String? avatarUrl) async {
    try {
      final updates = <String, dynamic>{'name': name};
      if (avatarUrl != null) {
        updates['avatar_url'] = avatarUrl;
      }

      await _supabase.auth.updateUser(UserAttributes(data: updates));
      notifyListeners();
    } catch (error) {
      throw Exception('Profile update failed: $error');
    }
  }
}
