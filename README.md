# keyboardweb

A custom Flutter keyboard widget that fixes the blank-area bug on Flutter mobile web.

When the system keyboard opens in a mobile browser, the browser resizes the viewport and leaves a blank area at the bottom of the screen after the keyboard is dismissed. This widget replaces the system keyboard entirely — so the viewport never changes and the bug physically cannot occur.

---

## Features

- Gboard-inspired light theme
- Press feedback: each key darkens and scales on tap-down
- Number row above the letter rows (quick digit access)
- Shift / Caps Lock (single tap = shift, double tap = caps lock)
- Modes: Letters · Numbers · Superscript/Subscript · Symbols · Emoji
- Optional haptic feedback toggle
- Correct Unicode backspace (multi-codepoint emoji deleted as one unit)
- Works on mobile web only — falls back to system keyboard on desktop/native automatically via `isMobileWeb()`

---

## Getting started

### 1. Add to your project

Copy `lib/custom_keyboard.dart` into your project. No additional packages needed — it only uses `package:flutter`.

### 2. Set up a screen

```dart
import 'custom_keyboard.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _keyboardVisible = false;

  bool get _useCKB => isMobileWeb(context);

  void _openKeyboard() {
    FocusScope.of(context).requestFocus(_focusNode);
    setState(() => _keyboardVisible = true);
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
    setState(() => _keyboardVisible = false);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Prevent system keyboard from resizing the screen on mobile web
      resizeToAvoidBottomInset: !_useCKB,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  // Disable system keyboard on mobile web
                  readOnly: _useCKB,
                  keyboardType: _useCKB ? TextInputType.none : null,
                  showCursor: true,
                  onTap: _useCKB ? _openKeyboard : null,
                  decoration: const InputDecoration(labelText: 'Type here'),
                ),
              ],
            ),
          ),
          // Show custom keyboard at bottom of screen
          if (_useCKB && _keyboardVisible)
            CustomKeyboard(
              controller: _controller,
              focusNode: _focusNode,
              onDone: _dismissKeyboard,
            ),
        ],
      ),
    );
  }
}
```

### 3. Multiple fields

When you have multiple text fields, track which one is active:

```dart
TextEditingController? _activeCtrl;
FocusNode? _activeFn;

void _openKeyboard(TextEditingController ctrl, FocusNode fn) {
  FocusScope.of(context).requestFocus(fn);
  setState(() {
    _activeCtrl = ctrl;
    _activeFn = fn;
    _keyboardVisible = true;
  });
}

// In your TextField:
onTap: _useCKB ? () => _openKeyboard(_nameCtrl, _nameFn) : null,

// CustomKeyboard at the bottom:
CustomKeyboard(
  controller: _activeCtrl,
  focusNode: _activeFn,
  onDone: _dismissKeyboard,
),
```

### 4. Inside a Dialog

Wrap the form content in `Flexible` and constrain the dialog height so the keyboard fits:

```dart
Dialog(
  insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
  child: ConstrainedBox(
    constraints: BoxConstraints(
      maxWidth: 520,
      maxHeight: MediaQuery.of(context).size.height - 64,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: /* your form */,
            ),
          ),
        ),
        if (useCKB && keyboardVisible)
          CustomKeyboard(
            controller: activeCtrl,
            focusNode: activeFn,
            onDone: dismissKeyboard,
          ),
      ],
    ),
  ),
),
```

---

## API

| Parameter | Type | Description |
|---|---|---|
| `controller` | `TextEditingController?` | The active field's controller |
| `focusNode` | `FocusNode?` | The active field's focus node |
| `onDone` | `VoidCallback?` | Called when the ↵ key is pressed |

### Helper

```dart
bool isMobileWeb(BuildContext context)
```

Returns `true` when running on web with a viewport width under 800px. Use this to decide whether to show the custom keyboard or use the system one.

---

## Why not just fix `resizeToAvoidBottomInset`?

Setting `resizeToAvoidBottomInset: false` stops the Scaffold from resizing, but the browser still scrolls the viewport when the system keyboard opens and leaves a blank area after dismissal. The only reliable fix is to prevent the system keyboard from opening at all — which is exactly what this widget does by setting `readOnly: true` and `keyboardType: TextInputType.none` on the text fields.

---

## Demo

Run the included demo app:

```
flutter run -d chrome
```

The demo automatically switches between the custom keyboard (mobile web viewport < 800px) and the system keyboard (desktop).
