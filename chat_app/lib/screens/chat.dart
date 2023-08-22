import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Chats',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
        actions: [
          IconButton(onPressed: (){
            FirebaseAuth.instance.signOut();
          }, icon: Icon(Icons.exit_to_app, color: Theme.of(context).colorScheme.onPrimary,))
        ],
      ),
      
      body: const Center(
        child: Text('Login page'),
      ),
    );
  }
}
