import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;

/// Returns true when running on a narrow web viewport (mobile browser).
bool isMobileWeb(BuildContext context) {
  if (!kIsWeb) return false;
  return MediaQuery.of(context).size.width < 800;
}

// ── Key layout data ────────────────────────────────────────────────────────────

enum _Mode { letters, numbers, superSub, symbols, emojis }

const _numTop = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
const _lettersRow1 = ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'];
const _lettersRow2 = ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'];
const _lettersRow3 = ['z', 'x', 'c', 'v', 'b', 'n', 'm'];

const _numRow1 = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
const _numRow2 = ['-', '/', ':', ';', '(', ')', '&', '@', '"', "'"];
const _numRow3 = ['.', ',', '?', '!', '#', '%', '^', '*', '+', '='];

const _superRow1 = ['⁰', '¹', '²', '³', '⁴', '⁵', '⁶', '⁷', '⁸', '⁹'];
const _subRow1 = ['₀', '₁', '₂', '₃', '₄', '₅', '₆', '₇', '₈', '₉'];
const _ssRow2 = ['⁺', '⁻', '⁼', '⁽', '⁾', '₊', '₋', '₌', '₍', '₎'];
const _ssRow3 = ['ⁿ', 'ⁱ', 'ᵃ', 'ᵇ', 'ᶜ', 'ᵈ', 'ᵉ', 'ᶠ', 'ᵍ', 'ʰ'];

const _symRow1 = ['€', '£', '¥', '¢', '₹', '₽', '₩', '₪', '₫', '₺'];
const _symRow2 = ['≈', '≠', '≤', '≥', '∞', '±', '÷', '×', '√', 'π'];
const _symRow3 = ['©', '®', '™', '°', '§', '¶', '…', '·', '•', '‐'];
const _symRow4 = ['←', '→', '↑', '↓', '↔', '⇒', '⇔', '∑', '∫', '∂'];

const _emojis = [
  // Smileys
  '😀', '😃', '😄', '😁', '😆', '😅', '🤣', '😂', '🙂', '😉',
  '😊', '😇', '🥰', '😍', '🤩', '😘', '😋', '😜', '🤪', '😎',
  '🤔', '😐', '😑', '😒', '🙄', '😬', '🥺', '😢', '😭', '😱',
  '😤', '😡', '😠', '🤬', '😈', '👿', '💀', '💩', '🤡', '👻',
  // Hands
  '👋', '🤚', '✋', '👌', '✌️', '🤞', '👍', '👎', '👊', '✊',
  '👏', '🙌', '🤝', '🙏', '💪', '🤜', '🤛', '☝️', '👆', '👇',
  // Hearts & nature
  '❤️', '🧡', '💛', '💚', '💙', '💜', '🖤', '🤍', '💔', '💕',
  '💞', '💓', '💗', '💖', '💘', '💝', '❣️', '🔥', '✨', '⭐',
  '🌟', '💫', '🌈', '⚡', '❄️', '🌊', '🌸', '🌺', '🌻', '🍀',
  // Animals
  '🐶', '🐱', '🐭', '🐰', '🦊', '🐻', '🐼', '🐯', '🦁', '🐮',
  '🐸', '🐵', '🦄', '🐔', '🐧', '🐦', '🦋', '🐝', '🦀', '🐬',
  '🦭', '🐘', '🦒', '🦓', '🦍', '🐊', '🐢', '🦎', '🐍', '🦕',
  // Food & drink
  '🍎', '🍊', '🍋', '🍌', '🍉', '🍇', '🍓', '🍔', '🍟', '🍕',
  '🌮', '🍜', '🍣', '🍱', '🎂', '🍰', '🍩', '🍪', '🍫', '☕',
  '🧃', '🥤', '🍺', '🍻', '🥂', '🍷', '🧋', '🍵', '🥐', '🧇',
  // Objects & places
  '📱', '💻', '🖥', '⌨️', '📷', '📺', '📻', '💡', '📚', '📝',
  '✏️', '🔍', '🔑', '🔒', '💰', '💳', '✈️', '🚗', '🚀', '🌍',
  '🏠', '🎮', '🎵', '🎸', '🎹', '🎤', '🎧', '🎉', '🏆', '🥇',
  // Symbols
  '💯', '✅', '❌', '❗', '❓', '🔴', '🟠', '🟡', '🟢', '🔵',
  '🟣', '⚫', '⚪', '🟤', '🔶', '🔷', '🔸', '🔹', '▶️', '⏸️',
];

// ── Gboard-style color constants ──────────────────────────────────────────────

const _kbBg = Color(0xFFD1D9E0);
const _keyBg = Colors.white;
const _keyBgPressed = Color(0xFFB0B8C0);
const _specialKeyBg = Color(0xFFADB5BD);
const _specialKeyBgPressed = Color(0xFF8A9199);
const _accentColor = Color(0xFF007D7D);
const _accentPressed = Color(0xFF005A5A);
const _keyText = Color(0xFF1A1A1A);
const _spaceTextColor = Color(0xFF475569);
const _keyRadius = Radius.circular(6);
const _keyShadow = BoxShadow(
  color: Color(0x40000000),
  offset: Offset(0, 1),
  blurRadius: 1,
);

// ── Pressable key widget ───────────────────────────────────────────────────────
//
// Each key manages its own pressed state so a single tap never triggers
// a rebuild of the whole keyboard.

class _PressableKey extends StatefulWidget {
  const _PressableKey({
    required this.onTap,
    required this.color,
    required this.pressedColor,
    required this.child,
    this.width,
    this.height,
    this.margin = const EdgeInsets.symmetric(horizontal: 2),
  });

  final VoidCallback onTap;
  final Color color;
  final Color pressedColor;
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsets margin;

  @override
  State<_PressableKey> createState() => _PressableKeyState();
}

class _PressableKeyState extends State<_PressableKey> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        widget.onTap();
        setState(() => _pressed = false);
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.88 : 1.0,
        duration: const Duration(milliseconds: 80),
        curve: Curves.easeOut,
        child: Container(
          width: widget.width,
          height: widget.height,
          margin: widget.margin,
          decoration: BoxDecoration(
            color: _pressed ? widget.pressedColor : widget.color,
            borderRadius: const BorderRadius.all(_keyRadius),
            boxShadow: _pressed ? const [] : const [_keyShadow],
          ),
          alignment: Alignment.center,
          child: widget.child,
        ),
      ),
    );
  }
}

// ── CustomKeyboard ─────────────────────────────────────────────────────────────

/// A full-featured custom keyboard widget for Flutter web (mobile viewport).
///
/// Prevents the browser's native keyboard from opening — and therefore avoids
/// the blank-area / viewport-resize bug that affects Flutter web on iOS/Android
/// browsers.
///
/// Usage
/// -----
/// 1. Set `readOnly: true` and `keyboardType: TextInputType.none` on every
///    [TextField] / [TextFormField] you want this keyboard to serve.
/// 2. On tap of a field, call `FocusScope.of(context).requestFocus(focusNode)`
///    and show this widget at the bottom of the screen.
/// 3. Pass [controller] and [focusNode] to keep the field's cursor active.
/// 4. Use [onDone] to hide the keyboard (e.g. when the user presses ↵).
///
/// See the README for a minimal working example.
class CustomKeyboard extends StatefulWidget {
  /// The controller of the active text field.
  final TextEditingController? controller;

  /// The focus node of the active text field. Passed once on open; the keyboard
  /// does NOT call [FocusNode.requestFocus] during typing (avoids select-all).
  final FocusNode? focusNode;

  /// Called when the user presses the ↵ (done / return) key.
  final VoidCallback? onDone;

  const CustomKeyboard({
    super.key,
    this.controller,
    this.focusNode,
    this.onDone,
  });

  @override
  State<CustomKeyboard> createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  _Mode _mode = _Mode.letters;
  bool _shifted = false;
  bool _capsLock = false;
  bool _hapticEnabled = false;

  void _haptic() {
    if (_hapticEnabled) HapticFeedback.lightImpact();
  }

  // ── Input helpers ────────────────────────────────────────────────────────────

  void _insert(String char) {
    final ctrl = widget.controller;
    if (ctrl == null) return;
    final v = ctrl.value;
    final s = v.selection.start < 0 ? v.text.length : v.selection.start;
    final e = v.selection.end < 0 ? v.text.length : v.selection.end;
    final newText = v.text.replaceRange(s, e, char);
    ctrl.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: s + char.length),
    );
  }

  void _backspace() {
    final ctrl = widget.controller;
    if (ctrl == null) return;
    final v = ctrl.value;
    final s = v.selection.start;
    final e = v.selection.end;
    if (s != e) {
      final newText = v.text.replaceRange(s, e, '');
      ctrl.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: s),
      );
    } else {
      if (s <= 0) return;
      final before = v.text.substring(0, s);
      final after = v.text.substring(s);
      // characters.skipLast(1) handles multi-codepoint emoji correctly
      final newBefore = before.characters.skipLast(1).toString();
      ctrl.value = TextEditingValue(
        text: newBefore + after,
        selection: TextSelection.collapsed(offset: newBefore.length),
      );
    }
  }

  void _onKey(String key) {
    _haptic();
    if (key == '⌫') {
      _backspace();
    } else if (key == '⇧') {
      setState(() {
        if (_capsLock) {
          _shifted = false;
          _capsLock = false;
        } else if (_shifted) {
          _capsLock = true;
        } else {
          _shifted = true;
        }
      });
    } else {
      final char = (_mode == _Mode.letters && (_shifted || _capsLock))
          ? key.toUpperCase()
          : key;
      _insert(char);
      if (_shifted && !_capsLock) setState(() => _shifted = false);
    }
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _kbBg,
        boxShadow: [
          BoxShadow(
            color: Color(0x28000000),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildModeBar(),
            const SizedBox(height: 4),
            if (_mode == _Mode.emojis) _buildEmojiGrid() else _buildKeyArea(),
            const SizedBox(height: 4),
            _buildBottomRow(),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  // ── Mode tab bar ─────────────────────────────────────────────────────────────

  Widget _buildModeBar() {
    const tabs = [
      ('ABC', _Mode.letters),
      ('123', _Mode.numbers),
      ('ⁿ₁', _Mode.superSub),
      ('∑', _Mode.symbols),
      ('😊', _Mode.emojis),
    ];
    return Container(
      color: const Color(0xFFC8D0D8),
      child: Row(
        children: tabs.map((t) {
          final active = _mode == t.$2;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() {
                _mode = t.$2;
                _shifted = false;
                _capsLock = false;
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: active ? _kbBg : const Color(0xFFC8D0D8),
                  border: Border(
                    bottom: BorderSide(
                      color: active ? _accentColor : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  t.$1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: active ? _accentColor : _spaceTextColor,
                    fontSize: 12,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Key area ─────────────────────────────────────────────────────────────────

  Widget _buildKeyArea() {
    List<List<String>> rows;
    switch (_mode) {
      case _Mode.letters:
        rows = [_lettersRow1, _lettersRow2];
      case _Mode.numbers:
        rows = [_numRow1, _numRow2, _numRow3];
      case _Mode.superSub:
        rows = [_superRow1, _subRow1, _ssRow2, _ssRow3];
      case _Mode.symbols:
        rows = [_symRow1, _symRow2, _symRow3, _symRow4];
      default:
        rows = [];
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final unit = (constraints.maxWidth - 8) / 10 - 4;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_mode == _Mode.letters) _buildNumberTopRow(unit),
            ...rows.map((r) => _buildRow(r, unit)),
            if (_mode == _Mode.letters) _buildShiftRow(unit),
          ],
        );
      },
    );
  }

  Widget _buildNumberTopRow(double unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _numTop
            .map(
              (k) => _PressableKey(
                width: unit,
                height: 38,
                onTap: () {
                  _haptic();
                  _insert(k);
                },
                color: _specialKeyBg,
                pressedColor: _specialKeyBgPressed,
                child: Text(
                  k,
                  style: const TextStyle(
                    color: _keyText,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildRow(List<String> keys, double unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: keys.map((k) => _key(k, unit)).toList(),
      ),
    );
  }

  Widget _buildShiftRow(double unit) {
    final shiftActive = _shifted || _capsLock;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _PressableKey(
            width: unit * 1.5 + 4,
            height: 44,
            onTap: () => _onKey('⇧'),
            color: shiftActive ? _accentColor : _specialKeyBg,
            pressedColor: shiftActive ? _accentPressed : _specialKeyBgPressed,
            child: Icon(
              _capsLock
                  ? Icons.keyboard_capslock_rounded
                  : Icons.keyboard_arrow_up_rounded,
              color: shiftActive ? Colors.white : _keyText,
              size: 18,
            ),
          ),
          ..._lettersRow3.map((k) => _key(k, unit)),
          _PressableKey(
            width: unit * 1.5 + 4,
            height: 44,
            onTap: () {
              _haptic();
              _backspace();
            },
            color: _specialKeyBg,
            pressedColor: _specialKeyBgPressed,
            child: const Icon(
              Icons.backspace_outlined,
              color: _keyText,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  // ── Individual key widgets ────────────────────────────────────────────────────

  Widget _key(String label, double unit) {
    final display = (_mode == _Mode.letters && (_shifted || _capsLock))
        ? label.toUpperCase()
        : label;
    return _PressableKey(
      width: unit,
      height: 44,
      onTap: () => _onKey(label),
      color: _keyBg,
      pressedColor: _keyBgPressed,
      child: Text(
        display,
        style: const TextStyle(
          color: _keyText,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  // ── Emoji grid ────────────────────────────────────────────────────────────────

  Widget _buildEmojiGrid() {
    return SizedBox(
      height: 210,
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(6, 4, 6, 0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 9,
          mainAxisSpacing: 3,
          crossAxisSpacing: 3,
          childAspectRatio: 1,
        ),
        itemCount: _emojis.length,
        itemBuilder: (ctx, i) => _PressableKey(
          onTap: () {
            _haptic();
            _insert(_emojis[i]);
          },
          color: _keyBg,
          pressedColor: _keyBgPressed,
          margin: EdgeInsets.zero,
          child: Text(_emojis[i], style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }

  // ── Bottom row ────────────────────────────────────────────────────────────────

  Widget _buildBottomRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          if (_mode != _Mode.letters)
            _bottomKey(
              flex: 1,
              child: const Icon(
                Icons.backspace_outlined,
                color: _keyText,
                size: 16,
              ),
              onTap: () {
                _haptic();
                _backspace();
              },
              special: true,
            ),
          _bottomKey(
            flex: _mode == _Mode.letters ? 5 : 4,
            child: const Text(
              'space',
              style: TextStyle(
                color: _spaceTextColor,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
            onTap: () {
              _haptic();
              _insert(' ');
            },
          ),
          _bottomKey(
            flex: 2,
            accent: _hapticEnabled,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.vibration_rounded,
                  size: 15,
                  color: _hapticEnabled ? Colors.white : _spaceTextColor,
                ),
                const SizedBox(width: 3),
                Text(
                  _hapticEnabled ? 'ON' : 'OFF',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _hapticEnabled ? Colors.white : _spaceTextColor,
                  ),
                ),
              ],
            ),
            onTap: () => setState(() => _hapticEnabled = !_hapticEnabled),
            special: !_hapticEnabled,
          ),
          _bottomKey(
            flex: 2,
            accent: true,
            child: const Icon(
              Icons.keyboard_return_rounded,
              color: Colors.white,
              size: 18,
            ),
            onTap: () => widget.onDone?.call(),
          ),
        ],
      ),
    );
  }

  Widget _bottomKey({
    required int flex,
    required Widget child,
    required VoidCallback onTap,
    bool accent = false,
    bool special = false,
  }) {
    final color =
        accent ? _accentColor : special ? _specialKeyBg : _keyBg;
    final pressedColor =
        accent ? _accentPressed : special ? _specialKeyBgPressed : _keyBgPressed;
    return Expanded(
      flex: flex,
      child: _PressableKey(
        height: 46,
        onTap: onTap,
        color: color,
        pressedColor: pressedColor,
        child: child,
      ),
    );
  }
}
