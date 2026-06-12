import 'package:flutter/material.dart';

import 'custom_keyboard.dart';

class KeyboardTestPage extends StatefulWidget {
  const KeyboardTestPage({super.key});

  @override
  State<KeyboardTestPage> createState() => _KeyboardTestPageState();
}

class _KeyboardTestPageState extends State<KeyboardTestPage> {
  final _ctrl1 = TextEditingController();
  final _ctrl2 = TextEditingController();
  final _fn1 = FocusNode();
  final _fn2 = FocusNode();

  bool _keyboardVisible = false;
  TextEditingController? _activeCtrl;
  FocusNode? _activeFn;

  bool get _useCKB => isMobileWeb(context);

  void _openKeyboard(TextEditingController ctrl, FocusNode fn) {
    FocusScope.of(context).requestFocus(fn);
    setState(() {
      _activeCtrl = ctrl;
      _activeFn = fn;
      _keyboardVisible = true;
    });
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
    setState(() {
      _activeCtrl = null;
      _activeFn = null;
      _keyboardVisible = false;
    });
  }

  @override
  void dispose() {
    _ctrl1.dispose();
    _ctrl2.dispose();
    _fn1.dispose();
    _fn2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: !_useCKB,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _useCKB ? _dismissKeyboard : null,
              behavior: HitTestBehavior.translucent,
              child: SafeArea(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    const Text(
                      'Custom Keyboard Demo',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _useCKB
                          ? 'Custom keyboard active (mobile web)'
                          : 'System keyboard active (desktop/native)',
                      style: TextStyle(
                        fontSize: 13,
                        color: _useCKB ? Colors.teal : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: _ctrl1,
                      focusNode: _fn1,
                      readOnly: _useCKB,
                      keyboardType: _useCKB ? TextInputType.none : null,
                      showCursor: true,
                      onTap: _useCKB ? () => _openKeyboard(_ctrl1, _fn1) : null,
                      decoration: const InputDecoration(
                        labelText: 'Field 1',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _ctrl2,
                      focusNode: _fn2,
                      readOnly: _useCKB,
                      keyboardType: _useCKB ? TextInputType.none : null,
                      showCursor: true,
                      onTap: _useCKB ? () => _openKeyboard(_ctrl2, _fn2) : null,
                      decoration: const InputDecoration(
                        labelText: 'Field 2',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ValueListenableBuilder(
                      valueListenable: _ctrl1,
                      builder: (context, v, child) => Text('Field 1: ${v.text}'),
                    ),
                    const SizedBox(height: 8),
                    ValueListenableBuilder(
                      valueListenable: _ctrl2,
                      builder: (context, v, child) => Text('Field 2: ${v.text}'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_useCKB && _keyboardVisible)
            CustomKeyboard(
              controller: _activeCtrl,
              focusNode: _activeFn,
              onDone: _dismissKeyboard,
            ),
        ],
      ),
    );
  }
}
