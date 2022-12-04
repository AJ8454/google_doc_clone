import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_doc_clone/colors.dart';
import 'package:google_doc_clone/repository/auth_repository.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signWithGoogle(WidgetRef ref) {
    ref.watch(authRepositoryProvider).signInWithGoogle();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => signWithGoogle(ref),
          icon: Image.asset(
            "assets/images/gLogo.png",
            height: 20,
          ),
          label: const Text(
            "Sign in with Google",
            style: TextStyle(color: kBlackColor),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: kWhiteColor,
            minimumSize: const Size(150, 50),
          ),
        ),
      ),
    );
  }
}
