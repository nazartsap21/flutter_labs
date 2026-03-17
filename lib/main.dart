import 'package:flutter/material.dart';

void main() {
  runApp(const FlutterLab());
}

class FlutterLab extends StatelessWidget {
  const FlutterLab({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Lab',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flutter Lab - Guess the Number Game'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController _controller;

  int _target = 0;
  String _feedback = '';
  bool _gameActive = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _newGame();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _newGame() {
    setState(() {
      _target = 1 + (DateTime.now().millisecondsSinceEpoch % 100);
      _feedback = 'Guess a number between 1 and 100';
      _gameActive = true;
      _controller.clear();
    });
  }

  void _submitGuess(String input) {
    final guess = int.tryParse(input.trim());

    setState(() {
      if (guess == null) {
        _feedback = 'Please enter a valid integer';
      } else if (guess < 1 || guess > 100) {
        _feedback = 'Number must be between 1 and 100';
      } else if (guess < _target) {
        _feedback = 'Too low';
      } else if (guess > _target) {
        _feedback = 'Too high';
      } else {
        _feedback = 'Correct! The number was $_target';
        _gameActive = false;
      }

      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_feedback, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            SizedBox(
              width: 200,
              child: TextField(
                controller: _controller,
                enabled: _gameActive,
                keyboardType: TextInputType.number,
                onSubmitted: _submitGuess,
                decoration: const InputDecoration(
                  labelText: 'Your guess',
                  hintText: 'Enter a number',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _gameActive
                  ? () => _submitGuess(_controller.text)
                  : null,
              child: const Text('Submit'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _newGame, child: const Text('New Game')),
          ],
        ),
      ),
    );
  }
}
