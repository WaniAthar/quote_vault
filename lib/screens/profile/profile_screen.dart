import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/quote_provider.dart';
import '../../widgets/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    if (user != null) {
      _nameController.text =
          user.userMetadata?['name'] ?? user.email!.split('@')[0];
      _emailController.text = user.email ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () => _toggleEditMode(),
          ),
        ],
      ),
      body: Consumer3<AuthProvider, ThemeProvider, QuoteProvider>(
        builder: (context, authProvider, themeProvider, quoteProvider, child) {
          final user = authProvider.user;

          if (user == null) {
            return const Center(
              child: Text('Please log in to view your profile'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // Avatar
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primaryContainer,
                      backgroundImage: user.userMetadata?['avatar_url'] != null
                          ? NetworkImage(user.userMetadata!['avatar_url'])
                          : null,
                      child: user.userMetadata?['avatar_url'] == null
                          ? Text(
                              _nameController.text.isNotEmpty
                                  ? _nameController.text[0].toUpperCase()
                                  : 'U',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                              ),
                            )
                          : null,
                    ),
                    if (_isEditing)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.camera_alt,
                              color: Theme.of(context).colorScheme.onPrimary,
                              size: 20,
                            ),
                            onPressed: () => _changeAvatar(),
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 30),

                // Name field
                TextFormField(
                  controller: _nameController,
                  enabled: _isEditing,
                  decoration: InputDecoration(
                    labelText: 'Display Name',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: _isEditing
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(
                            context,
                          ).colorScheme.surface.withOpacity(0.5),
                  ),
                ),

                const SizedBox(height: 20),

                // Email field (read-only)
                TextFormField(
                  controller: _emailController,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(
                      context,
                    ).colorScheme.surface.withOpacity(0.5),
                  ),
                ),

                const SizedBox(height: 30),

                // Statistics
                if (!_isEditing) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            'Your Statistics',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Icon(
                                    Icons.favorite,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    size: 30,
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    'Favorites',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 5),
                                  FutureBuilder<List>(
                                    future: quoteProvider.getUserFavorites(),
                                    builder: (context, snapshot) {
                                      return Text(
                                        '${snapshot.data?.length ?? 0}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Icon(
                                    Icons.collections_bookmark,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                    size: 30,
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    'Collections',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${quoteProvider.collections.length}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 30),

                // Theme preferences
                if (!_isEditing) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Theme Preferences',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          SwitchListTile(
                            title: const Text('Dark Mode'),
                            subtitle: const Text('Enable dark theme'),
                            value: themeProvider.isDarkMode,
                            onChanged: (value) {
                              themeProvider.setThemeMode(
                                value ? ThemeMode.dark : ThemeMode.light,
                              );
                            },
                          ),
                          ListTile(
                            title: const Text('Font Size'),
                            subtitle: Text('${themeProvider.fontSize.toInt()}'),
                            trailing: SizedBox(
                              width: 150,
                              child: Slider(
                                value: themeProvider.fontSize,
                                min: 12,
                                max: 24,
                                divisions: 6,
                                onChanged: (value) {
                                  themeProvider.setFontSize(value);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 30),

                // Save button (only show when editing)
                if (_isEditing)
                  CustomButton(
                    text: 'Save Changes',
                    onPressed: () => _saveProfile(),
                    isLoading: authProvider.isLoading,
                  ),

                const SizedBox(height: 20),

                // Logout button
                CustomButton(
                  text: 'Logout',
                  onPressed: () => _logout(),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _toggleEditMode() {
    if (_isEditing) {
      _saveProfile();
    } else {
      setState(() {
        _isEditing = true;
      });
    }
  }

  Future<void> _saveProfile() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      await authProvider.updateProfile(_nameController.text.trim(), null);

      setState(() {
        _isEditing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating profile: $e')));
      }
    }
  }

  Future<void> _changeAvatar() async {
    // TODO: Implement image picker for avatar
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Avatar upload coming soon!')));
  }

  Future<void> _logout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.signOut();

    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }
}
