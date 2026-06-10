import 'dart:ui';
import 'package:flutter/material.dart';
import 'custom_keyboard.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _scrollController = ScrollController();

  TextEditingController? _activeCtrl;
  // Decoupled from FocusNode state — only _openKeyboard / _dismissKeyboard
  // change this, so browser blur events from key taps can never hide the keyboard.
  bool _keyboardVisible = false;

  bool _obscureSignIn = true;
  bool _obscureCreate = true;
  bool _obscureConfirm = true;

  final _signInEmail    = TextEditingController();
  final _signInPassword = TextEditingController();
  final _createUsername = TextEditingController();
  final _createEmail    = TextEditingController();
  final _createPassword = TextEditingController();
  final _createConfirm  = TextEditingController();

  final _fnSignInEmail    = FocusNode();
  final _fnSignInPassword = FocusNode();
  final _fnCreateUsername = FocusNode();
  final _fnCreateEmail    = FocusNode();
  final _fnCreatePassword = FocusNode();
  final _fnCreateConfirm  = FocusNode();

  bool get _showCustomKeyboard => isMobileWeb(context) && _keyboardVisible;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  void _openKeyboard(TextEditingController ctrl, FocusNode fn) {
    FocusScope.of(context).requestFocus(fn);
    setState(() {
      _activeCtrl = ctrl;
      _keyboardVisible = true;
    });
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
    setState(() {
      _activeCtrl = null;
      _keyboardVisible = false;
    });
    if (_scrollController.hasClients) _scrollController.jumpTo(0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _signInEmail.dispose();
    _signInPassword.dispose();
    _createUsername.dispose();
    _createEmail.dispose();
    _createPassword.dispose();
    _createConfirm.dispose();
    _fnSignInEmail.dispose();
    _fnSignInPassword.dispose();
    _fnCreateUsername.dispose();
    _fnCreateEmail.dispose();
    _fnCreatePassword.dispose();
    _fnCreateConfirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final useCKB = isMobileWeb(context);
    return Scaffold(
      // We own the bottom inset when the custom keyboard is active.
      resizeToAvoidBottomInset: !useCKB,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackground(),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _dismissKeyboard,
                    behavior: HitTestBehavior.translucent,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLogo(),
                          const SizedBox(height: 40),
                          _buildCard(useCKB),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_showCustomKeyboard)
                  CustomKeyboard(
                    controller: _activeCtrl,
                    onDone: _dismissKeyboard,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Background ─────────────────────────────────────────────────────────────

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D0D1A), Color(0xFF1A0D2E), Color(0xFF0D1A2E)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(top: -80, left: -80,   child: _glow(const Color(0xFF6C3EF5), 300)),
          Positioned(bottom: -60, right: -60, child: _glow(const Color(0xFF3E9EF5), 260)),
          Positioned(top: 200, right: 40,    child: _glow(const Color(0xFFAA3EF5), 140)),
        ],
      ),
    );
  }

  Widget _glow(Color color, double size) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withValues(alpha: 0.35), color.withValues(alpha: 0)],
        ),
      ),
    );
  }

  // ── Logo ───────────────────────────────────────────────────────────────────

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 72, height: 72,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFF6C3EF5), Color(0xFF3E9EF5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6C3EF5).withValues(alpha: 0.5),
                blurRadius: 24, offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.keyboard_alt_outlined, color: Colors.white, size: 36),
        ),
        const SizedBox(height: 16),
        const Text(
          'KeyboardWeb',
          style: TextStyle(
            color: Colors.white, fontSize: 26,
            fontWeight: FontWeight.w700, letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Your typing universe',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.45),
            fontSize: 13, letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  // ── Card ───────────────────────────────────────────────────────────────────

  Widget _buildCard(bool useCKB) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 420),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Column(
            children: [
              _buildTabBar(),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 8, 28, 28),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 260),
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.04, 0), end: Offset.zero,
                      ).animate(anim),
                      child: child,
                    ),
                  ),
                  child: _tabController.index == 0
                      ? _buildSignIn(key: const ValueKey('signin'), useCKB: useCKB)
                      : _buildCreateAccount(key: const ValueKey('create'), useCKB: useCKB),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          gradient: const LinearGradient(
            colors: [Color(0xFF6C3EF5), Color(0xFF3E9EF5)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C3EF5).withValues(alpha: 0.4),
              blurRadius: 12, offset: const Offset(0, 4),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withValues(alpha: 0.4),
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600, fontSize: 14, letterSpacing: 0.4,
        ),
        tabs: const [Tab(text: 'Sign In'), Tab(text: 'Create Account')],
      ),
    );
  }

  // ── Sign-in form ───────────────────────────────────────────────────────────

  Widget _buildSignIn({Key? key, required bool useCKB}) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        _field(
          controller: _signInEmail, focusNode: _fnSignInEmail,
          label: 'Email or Username', icon: Icons.person_outline_rounded,
          readOnly: useCKB,
        ),
        const SizedBox(height: 16),
        _field(
          controller: _signInPassword, focusNode: _fnSignInPassword,
          label: 'Password', icon: Icons.lock_outline_rounded,
          obscure: _obscureSignIn, readOnly: useCKB,
          onToggle: () => setState(() => _obscureSignIn = !_obscureSignIn),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero, minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Forgot password?',
              style: TextStyle(color: Color(0xFF9B7AF5), fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _gradientButton(label: 'Sign In', onTap: () {}),
        const SizedBox(height: 20),
        _divider(),
        const SizedBox(height: 20),
        _socialRow(),
      ],
    );
  }

  // ── Create-account form ────────────────────────────────────────────────────

  Widget _buildCreateAccount({Key? key, required bool useCKB}) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        _field(
          controller: _createUsername, focusNode: _fnCreateUsername,
          label: 'Username', icon: Icons.alternate_email_rounded,
          readOnly: useCKB,
        ),
        const SizedBox(height: 16),
        _field(
          controller: _createEmail, focusNode: _fnCreateEmail,
          label: 'Email', icon: Icons.mail_outline_rounded,
          readOnly: useCKB,
        ),
        const SizedBox(height: 16),
        _field(
          controller: _createPassword, focusNode: _fnCreatePassword,
          label: 'Password', icon: Icons.lock_outline_rounded,
          obscure: _obscureCreate, readOnly: useCKB,
          onToggle: () => setState(() => _obscureCreate = !_obscureCreate),
        ),
        const SizedBox(height: 16),
        _field(
          controller: _createConfirm, focusNode: _fnCreateConfirm,
          label: 'Confirm Password', icon: Icons.lock_reset_rounded,
          obscure: _obscureConfirm, readOnly: useCKB,
          onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
        ),
        const SizedBox(height: 28),
        _gradientButton(label: 'Create Account', onTap: () {}),
        const SizedBox(height: 20),
        _divider(),
        const SizedBox(height: 20),
        _socialRow(),
      ],
    );
  }

  // ── Shared field widget ────────────────────────────────────────────────────

  Widget _field({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required IconData icon,
    bool obscure = false,
    bool readOnly = false,
    VoidCallback? onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _activeCtrl == controller && readOnly
              ? const Color(0xFF6C3EF5).withValues(alpha: 0.6)
              : Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        readOnly: readOnly,
        obscureText: obscure,
        showCursor: true,
        cursorColor: const Color(0xFF9B7AF5),
        cursorWidth: 2,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        keyboardType: readOnly ? TextInputType.none : null,
        // TextField.onTap fires reliably even with readOnly: true, unlike an
        // outer GestureDetector which loses the gesture arena to the TextField.
        onTap: readOnly ? () => _openKeyboard(controller, focusNode) : null,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white.withValues(alpha: 0.4), size: 20),
          suffixIcon: onToggle != null
              ? IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: Colors.white.withValues(alpha: 0.4), size: 20,
                  ),
                  onPressed: onToggle,
                )
              : null,
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 14),
          floatingLabelStyle: const TextStyle(color: Color(0xFF9B7AF5), fontSize: 12),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  // ── Gradient button ────────────────────────────────────────────────────────

  Widget _gradientButton({required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(colors: [Color(0xFF6C3EF5), Color(0xFF3E9EF5)]),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C3EF5).withValues(alpha: 0.45),
              blurRadius: 20, offset: const Offset(0, 8),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w700,
            fontSize: 15, letterSpacing: 0.6,
          ),
        ),
      ),
    );
  }

  // ── Divider + social ───────────────────────────────────────────────────────

  Widget _divider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.12), height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'or continue with',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.35), fontSize: 12),
          ),
        ),
        Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.12), height: 1)),
      ],
    );
  }

  Widget _socialRow() {
    return Row(
      children: [
        _socialButton(icon: Icons.g_mobiledata_rounded),
        const SizedBox(width: 12),
        _socialButton(icon: Icons.apple_rounded),
        const SizedBox(width: 12),
        _socialButton(icon: Icons.discord),
      ],
    );
  }

  Widget _socialButton({required IconData icon}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: Colors.white.withValues(alpha: 0.7), size: 22),
        ),
      ),
    );
  }
}
