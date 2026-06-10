import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;

// True when running on a narrow web viewport (mobile browser).
bool isMobileWeb(BuildContext context) {
  if (!kIsWeb) return false;
  return MediaQuery.of(context).size.width < 800;
}

// ─── Keyboard modes ───────────────────────────────────────────────────────────

enum _Mode { letters, numbers, superSub, symbols, emojis }

// ─── Key layout data ──────────────────────────────────────────────────────────

const _lettersRow1 = ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'];
const _lettersRow2 = ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'];
const _lettersRow3 = ['z', 'x', 'c', 'v', 'b', 'n', 'm'];

const _numRow1 = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
const _numRow2 = ['-', '/', ':', ';', '(', ')', '&', '@', '"', "'"];
const _numRow3 = ['.', ',', '?', '!', '#', '%', '^', '*', '+', '='];

const _superRow1 = ['⁰', '¹', '²', '³', '⁴', '⁵', '⁶', '⁷', '⁸', '⁹'];
const _subRow1   = ['₀', '₁', '₂', '₃', '₄', '₅', '₆', '₇', '₈', '₉'];
const _ssRow2    = ['⁺', '⁻', '⁼', '⁽', '⁾', '₊', '₋', '₌', '₍', '₎'];
const _ssRow3    = ['ⁿ', 'ⁱ', 'ᵃ', 'ᵇ', 'ᶜ', 'ᵈ', 'ᵉ', 'ᶠ', 'ᵍ', 'ʰ'];

const _symRow1 = ['€', '£', '¥', '¢', '₹', '₽', '₩', '₪', '₫', '₺'];
const _symRow2 = ['≈', '≠', '≤', '≥', '∞', '±', '÷', '×', '√', 'π'];
const _symRow3 = ['©', '®', '™', '°', '§', '¶', '…', '·', '•', '‐'];
const _symRow4 = ['←', '→', '↑', '↓', '↔', '⇒', '⇔', '∑', '∫', '∂'];

const _emojis = [
  // Smileys
  '😀','😃','😄','😁','😆','😅','🤣','😂','🙂','😉',
  '😊','😇','🥰','😍','🤩','😘','😋','😜','🤪','😎',
  '🤔','😐','😑','😒','🙄','😬','🥺','😢','😭','😱',
  '😤','😡','😠','🤬','😈','👿','💀','💩','🤡','👻',
  // Hands
  '👋','🤚','✋','👌','✌️','🤞','👍','👎','👊','✊',
  '👏','🙌','🤝','🙏','💪','🤜','🤛','☝️','👆','👇',
  // Hearts & nature
  '❤️','🧡','💛','💚','💙','💜','🖤','🤍','💔','💕',
  '💞','💓','💗','💖','💘','💝','❣️','🔥','✨','⭐',
  '🌟','💫','🌈','⚡','❄️','🌊','🌸','🌺','🌻','🍀',
  // Animals
  '🐶','🐱','🐭','🐰','🦊','🐻','🐼','🐯','🦁','🐮',
  '🐸','🐵','🦄','🐔','🐧','🐦','🦋','🐝','🦀','🐬',
  '🦭','🐘','🦒','🦓','🦍','🐊','🐢','🦎','🐍','🦕',
  // Food & drink
  '🍎','🍊','🍋','🍌','🍉','🍇','🍓','🍔','🍟','🍕',
  '🌮','🍜','🍣','🍱','🎂','🍰','🍩','🍪','🍫','☕',
  '🧃','🥤','🍺','🍻','🥂','🍷','🧋','🍵','🥐','🧇',
  // Objects & places
  '📱','💻','🖥','⌨️','📷','📺','📻','💡','📚','📝',
  '✏️','🔍','🔑','🔒','💰','💳','✈️','🚗','🚀','🌍',
  '🏠','🎮','🎵','🎸','🎹','🎤','🎧','🎉','🏆','🥇',
  // Symbols
  '💯','✅','❌','❗','❓','🔴','🟠','🟡','🟢','🔵',
  '🟣','⚫','⚪','🟤','🔶','🔷','🔸','🔹','▶️','⏸️',
];

// ─── Widget ───────────────────────────────────────────────────────────────────

class CustomKeyboard extends StatefulWidget {
  final TextEditingController? controller;
  final VoidCallback? onDone;

  const CustomKeyboard({super.key, this.controller, this.onDone});

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

  // ── Input helpers ────────────────────────────────────────────────────────

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
      // Delete selection
      final newText = v.text.replaceRange(s, e, '');
      ctrl.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: s),
      );
    } else {
      if (s <= 0) return;
      // Use `characters` for correct Unicode grapheme cluster deletion
      final before = v.text.substring(0, s);
      final after = v.text.substring(s);
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

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0B0B18),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildModeBar(),
            const SizedBox(height: 2),
            if (_mode == _Mode.emojis) _buildEmojiGrid() else _buildKeyArea(),
            const SizedBox(height: 4),
            _buildBottomRow(),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  // ── Mode tab bar ─────────────────────────────────────────────────────────

  Widget _buildModeBar() {
    const tabs = [
      ('ABC', _Mode.letters),
      ('123', _Mode.numbers),
      ('ⁿ₁', _Mode.superSub),
      ('∑', _Mode.symbols),
      ('😊', _Mode.emojis),
    ];
    return Row(
      children: [
        ...tabs.map((t) {
          final active = _mode == t.$2;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() {
                _mode = t.$2;
                _shifted = false;
                _capsLock = false;
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: active
                          ? const Color(0xFF6C3EF5)
                          : Colors.white.withValues(alpha: 0.06),
                      width: active ? 2 : 1,
                    ),
                  ),
                ),
                child: Text(
                  t.$1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: active
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.35),
                    fontSize: 13,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  // ── Key area ─────────────────────────────────────────────────────────────

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

    return LayoutBuilder(builder: (context, constraints) {
      // Base unit: fit 10 keys across with 2px side margin
      final unit = (constraints.maxWidth - 8) / 10 - 4;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...rows.map((r) => _buildRow(r, unit)),
          if (_mode == _Mode.letters) _buildShiftRow(unit),
        ],
      );
    });
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
          // Shift
          _specialKey(
            width: unit * 1.5 + 4,
            active: shiftActive,
            child: Icon(
              _capsLock
                  ? Icons.keyboard_capslock_rounded
                  : Icons.keyboard_arrow_up_rounded,
              color: shiftActive
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.7),
              size: 18,
            ),
            onTap: () => _onKey('⇧'),
          ),
          ..._lettersRow3.map((k) => _key(k, unit)),
          // Backspace
          _specialKey(
            width: unit * 1.5 + 4,
            active: false,
            child: Icon(Icons.backspace_outlined,
                color: Colors.white.withValues(alpha: 0.7), size: 16),
            onTap: _backspace,
          ),
        ],
      ),
    );
  }

  // ── Individual key widgets ────────────────────────────────────────────────

  Widget _key(String label, double unit) {
    final display = (_mode == _Mode.letters && (_shifted || _capsLock))
        ? label.toUpperCase()
        : label;
    return GestureDetector(
      onTap: () => _onKey(label),
      child: Container(
        width: unit,
        height: 48,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
        ),
        alignment: Alignment.center,
        child: Text(
          display,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _specialKey({
    required double width,
    required bool active,
    required Widget child,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 48,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          gradient: active
              ? const LinearGradient(
                  colors: [Color(0xFF6C3EF5), Color(0xFF3E9EF5)])
              : null,
          color: active ? null : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(8),
          border: active
              ? null
              : Border.all(color: Colors.white.withValues(alpha: 0.07)),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  // ── Emoji grid ────────────────────────────────────────────────────────────

  Widget _buildEmojiGrid() {
    return SizedBox(
      height: 224,
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(6, 4, 6, 0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 9,
          mainAxisSpacing: 3,
          crossAxisSpacing: 3,
          childAspectRatio: 1,
        ),
        itemCount: _emojis.length,
        itemBuilder: (ctx, i) => GestureDetector(
          onTap: () { _haptic(); _insert(_emojis[i]); },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: Colors.white.withValues(alpha: 0.04),
            ),
            child: Text(_emojis[i],
                style: const TextStyle(fontSize: 20)),
          ),
        ),
      ),
    );
  }

  // ── Bottom row: space + done (+ backspace on non-letter modes) ────────────

  Widget _buildBottomRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          if (_mode != _Mode.letters && _mode != _Mode.emojis)
            _bottomKey(
              flex: 1,
              child: Icon(Icons.backspace_outlined,
                  color: Colors.white.withValues(alpha: 0.7), size: 16),
              onTap: () { _haptic(); _backspace(); },
            ),
          if (_mode == _Mode.emojis)
            _bottomKey(
              flex: 1,
              child: Icon(Icons.backspace_outlined,
                  color: Colors.white.withValues(alpha: 0.7), size: 16),
              onTap: () { _haptic(); _backspace(); },
            ),
          // Space bar
          _bottomKey(
            flex: 4,
            child: Text('space',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.45),
                    fontSize: 13)),
            onTap: () { _haptic(); _insert(' '); },
          ),
          // Haptic toggle
          _bottomKey(
            flex: 2,
            gradient: _hapticEnabled,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.vibration_rounded,
                  size: 16,
                  color: _hapticEnabled
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.5),
                ),
                const SizedBox(width: 4),
                Text(
                  _hapticEnabled ? 'ON' : 'OFF',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _hapticEnabled
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
            onTap: () => setState(() => _hapticEnabled = !_hapticEnabled),
          ),
          // Done / return
          _bottomKey(
            flex: 2,
            gradient: true,
            child: const Icon(Icons.keyboard_return_rounded,
                color: Colors.white, size: 18),
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
    bool gradient = false,
  }) {
    return Expanded(
      flex: flex,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            gradient: gradient
                ? const LinearGradient(
                    colors: [Color(0xFF6C3EF5), Color(0xFF3E9EF5)])
                : null,
            color: gradient ? null : Colors.white.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(10),
            border: gradient
                ? null
                : Border.all(color: Colors.white.withValues(alpha: 0.07)),
            boxShadow: gradient
                ? [
                    BoxShadow(
                      color: const Color(0xFF6C3EF5).withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}
