import 'package:flutter/material.dart';

class KeyboardTestPage extends StatefulWidget {
  const KeyboardTestPage({super.key});

  @override
  State<KeyboardTestPage> createState() => _KeyboardTestPageState();
}

class _KeyboardTestPageState extends State<KeyboardTestPage>
    with WidgetsBindingObserver {
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      FocusManager.instance.primaryFocus?.unfocus();
      setState(() {});
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),

                      const Text(
                        'Keyboard Web Test',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 40),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: controller1,
                          decoration: const InputDecoration(
                            labelText: 'Field 1',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: controller2,
                          decoration: const InputDecoration(
                            labelText: 'Field 2',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Test Button'),
                      ),

                      const SizedBox(height: 200),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
