import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimedai/features/auth/home/presentation/components/my_drawer.dart';
import 'package:nutrimedai/features/auth/presentation/cubits/auth_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().currentUser;

    return Scaffold(
      appBar: AppBar(title: Text('Home Page'), centerTitle: true),
      drawer: const MyDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user != null) ...[
              Text(
                'Hola, ${user.name}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(user.email, style: const TextStyle(fontSize: 16)),
            ] else ...[
              const Text(
                'Welcome to the Home Page!',
                style: TextStyle(fontSize: 24),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Floating Action Button Pressed')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
