import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../core/app_snack_bar.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Please fill in all fields.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final authProvider = context.read<AuthProvider>();
    await authProvider.signIn(email, password);

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
          return Row(
            children: [
              if (!isMobile)
                Expanded(
                  flex: 1,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuCkMKTU3KJoLI49BD_wQsjFXCuKGe_aBw-6LdP7yEn7rwA11ShB7XbW-wxBkc2MSA6fzgJ8VeL21Cruzb87uoTGJhFpdaHQZox64Pk2vIRaK3DII1O-tuVRAopLV21OifLKpbwPN1tlFGY8xplNZmkeZ_b9Lw6hcmNblbosdYpmEzIroDJ0IvNnc-rsccVP-asMbIK12cNapEb1HZJgD1sg9P_y6Y6J-92I_uqSG5D7r8U8njkbIkdU98lFF_GbwDSBSQxaFyOckCY',
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
                                const Color(0xFF1F1B16).withOpacity(0.4),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Positioned(
                        bottom: 64,
                        left: 64,
                        right: 64,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Satin &\nStone',
                              style: TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFF8F4),
                                height: 1.1,
                                letterSpacing: -1,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'A curated digital stage for the contemporary minimalist.',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFFDF2E9),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                flex: 1,
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 48,
                      ),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (isMobile)
                              const Padding(
                                padding: EdgeInsets.only(bottom: 48),
                                child: Center(
                                  child: Text(
                                    'Satin & Stone',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF1F1B16),
                                      letterSpacing: -1,
                                    ),
                                  ),
                                ),
                              ),
                            Align(
                              alignment: isMobile
                                  ? Alignment.centerLeft
                                  : Alignment.centerLeft,
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome back',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1F1B16),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Please enter your details to sign in.',
                                    style: TextStyle(
                                      color: Color(0xFF51443D),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 48),
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
                            _buildInputLabel('Email address'),
                            const SizedBox(height: 8),
                            _buildInputField(
                                hint: 'name@example.com',
                                controller: _emailController),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildInputLabel('Password'),
                                const Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: Color(0xFF7A5136),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            _buildInputField(
                              hint: '••••••••',
                              obscureText: true,
                              controller: _passwordController,
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
                              onPressed: _isLoading ? null : _signIn,
                              child: _isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text(
                                      'Sign In',
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
                                  padding: EdgeInsets.symmetric(horizontal: 16),
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
                                  "Don't have an account?",
                                  style: TextStyle(
                                    color: Color(0xFF51443D),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () {
                                    context.go('/signup');
                                  },
                                  child: const Text(
                                    'Sign Up',
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
                  ),
                ),
              ),
            ],
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
        backgroundColor: const Color(0xFFFFF8F4),
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
