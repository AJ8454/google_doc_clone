import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_doc_clone/models/error_model.dart';
import 'package:google_doc_clone/repository/auth_repository.dart';
import 'package:google_doc_clone/screens/home_screen.dart';
import 'package:google_doc_clone/screens/login_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  ErrorModel? errorModel;
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    errorModel = await ref.read(authRepositoryProvider).getUserData();
    if (errorModel != null && errorModel!.data != null) {
      ref.read(userProvider.notifier).update((state) => errorModel!.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: user == null ? const LoginScreen() : const HomeScreen(),
    );
  }
}
