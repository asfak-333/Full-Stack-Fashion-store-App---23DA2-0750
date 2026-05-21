import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../core/app_snack_bar.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() => _error = 'Please fill in all fields.');
      return;
    }

    if (password != confirmPassword) {
      setState(() => _error = 'Passwords do not match.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final authProvider = context.read<AuthProvider>();
    await authProvider.signUp(email, password, name);

    if (!mounted) return;

    if (authProvider.error != null) {
      setState(() {
        _error = authProvider.error;
        _isLoading = false;
      });
      AppSnackBar.showError(context, authProvider.error!);
    } else {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F4),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 800;
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF2E9),
                    borderRadius: BorderRadius.circular(isMobile ? 0 : 24),
                    boxShadow: isMobile
                        ? []
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 40,
                              offset: const Offset(0, 24),
                            ),
                          ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!isMobile)
                        Expanded(
                          flex: 1,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 700),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        'https://lh3.googleusercontent.com/aida-public/AB6AXuBcKVEfLZlYMbzCTomRshZMAT4iq68UrUWV0DL-T8ZX__olM7rQ4Gdb5NZg8GdO17Oy8nTBmYk5lyuLobon4i83lDfg2eq7kt0WE8_2bJ88FRLvqqRuoiORgz-PPvmX6dCyaNb0yN-yyJwojC9EIpyFUFbeZIZ9T3ExNvmBcYXYjcWAgtxLAo4S-js8qg9WAoQ72yduq4tm_W0wGAUXdqwZAfug_Y-yokYUXKYH9r_eEqkRgFL1hJ0Bf3mLuZmH5u79PVzuC1qXwEU',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          const Color(
                                            0xFF7A5136,
                                          ).withOpacity(0.4),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const Positioned(
                                  bottom: 48,
                                  left: 48,
                                  right: 48,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Satin & Stone',
                                        style: TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                          height: 1.1,
                                          letterSpacing: -1,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Curated elegance for the modern individual. Join our exclusive community.',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFFEBE1D8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(isMobile ? 32 : 64),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (isMobile)
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 32),
                                  child: Text(
                                    'Satin & Stone',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF1F1B16),
                                      letterSpacing: -1,
                                    ),
                                  ),
                                ),
                              const Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F1B16),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Step into a world of curated fashion and timeless style.',
                                style: TextStyle(color: Color(0xFF51443D)),
                              ),
                              const SizedBox(height: 32),
                              if (_error != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFDAD6).withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0xFFBA1A1A).withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.error_outline,
                                          color: Color(0xFFBA1A1A),
                                          size: 18,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            _error!,
                                            style: const TextStyle(
                                              color: Color(0xFFBA1A1A),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              height: 1.4,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              _buildInputLabel('Name'),
                              const SizedBox(height: 8),
                              _buildInputField(
                                  hint: 'Evelyn Stone',
                                  controller: _nameController),
                              const SizedBox(height: 16),
                              _buildInputLabel('Email'),
                              const SizedBox(height: 8),
                              _buildInputField(
                                  hint: 'hello@satinandstone.com',
                                  controller: _emailController),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildInputLabel('Password'),
                                        const SizedBox(height: 8),
                                        _buildInputField(
                                          hint: '••••••••',
                                          obscureText: true,
                                          controller: _passwordController,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildInputLabel('Confirm'),
                                        const SizedBox(height: 8),
                                        _buildInputField(
                                          hint: '••••••••',
                                          obscureText: true,
                                          controller: _confirmPasswordController,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF7A5136),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 8,
                                  shadowColor: const Color(
                                    0xFF7A5136,
                                  ).withOpacity(0.4),
                                ),
                                onPressed: _isLoading ? null : _signUp,
                                child: _isLoading
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text(
                                        'Create Account',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                              ),
                              const SizedBox(height: 40),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 1,
                                      color: const Color(
                                        0xFFD5C3B9,
                                      ).withOpacity(0.5),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Text(
                                      'OR CONTINUE WITH',
                                      style: TextStyle(
                                        color: Color(0xFF83746C),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 1,
                                      color: const Color(
                                        0xFFD5C3B9,
                                      ).withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Already have an account?",
                                    style: TextStyle(
                                      color: Color(0xFF51443D),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  GestureDetector(
                                    onTap: () {
                                      context.go('/signin');
                                    },
                                    child: const Text(
                                      'Sign In',
                                      style: TextStyle(
                                        color: Color(0xFF7A5136),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'PRIVACY POLICY',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF83746C),
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Text(
                                    'TERMS OF SERVICE',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF83746C),
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Text(
                                    'CONTACT US',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF83746C),
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF1F1B16)),
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/');
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }

  Widget _buildInputLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Color(0xFF51443D),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String hint,
    bool obscureText = false,
    TextEditingController? controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFDF2E9),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF83746C)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    bool isGoogle = false,
  }) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF1F1B16),
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        side: BorderSide(color: const Color(0xFFD5C3B9).withOpacity(0.5)),
      ),
      onPressed: () {},
      icon: isGoogle
          ? Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAk-FAPhQmzGOEKoGEa74E406NQ1QRq7WmhZTPn6tLyP7sIf3pT9eRRSXHwfERbuelHHufoIHbRw9iKSrqpIL6XtHinG1Umk8Mz7P4oKJCH1lZ_l9j6WufNRaMssc7TSN3ZaQiVdM8xwm1qqGxJRCnxg-FtcPKRqTMktiSYrqZ4azSFFgnedbKPf7RxHJrFYGzS0peLoxyl83Ug8Qq_gZTj8IsUAfSXOI-bYHncbyO41spgtOvShL8hAoaDkf3OW6vviOWgoByYdh4',
              width: 20,
              height: 20,
            )
          : Icon(icon, size: 20),
      label: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }
}
