import 'package:flutter/material.dart';
import 'package:flutter_lab/pages/home.dart';
import 'package:flutter_lab/pages/login.dart';
import 'package:flutter_lab/widgets/input.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Text('Weather Station'),
              const SizedBox(height: 20),
              const Text('Register'),
              const SizedBox(height: 20),
              const WeatherInput(
                label: 'Name',
                hintText: 'Enter your name',
                prefixIcon: Icons.person_outline_rounded,
                keyboardType: TextInputType.name, 
              ),
              const SizedBox(height: 20),
              const WeatherInput(
                label: 'Email',
                hintText: 'Enter your email',
                prefixIcon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              const WeatherInput(
                label: 'Password',
                hintText: 'Enter your password',
                prefixIcon: Icons.lock_outline_rounded,
                suffixIcon: Icon(Icons.visibility_off_outlined),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              const WeatherInput(
                label: 'Confirm Password',
                hintText: 'Confirm your password',
                prefixIcon: Icons.lock_outline_rounded,
                suffixIcon: Icon(Icons.visibility_off_outlined),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              const WeatherInput(
                label: 'Meteostation',
                hintText: 'Enter your meteostation',
                prefixIcon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => const HomePage(),
                    ),
                  );
                },
                child: const Text('Register'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),            
            ],
          ),
        ),
      ),
    );
  }
}
