import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_doc_clone/colors.dart';
import 'package:google_doc_clone/common/widgets/loader.dart';
import 'package:google_doc_clone/models/document_model.dart';
import 'package:google_doc_clone/models/error_model.dart';
import 'package:google_doc_clone/repository/auth_repository.dart';
import 'package:google_doc_clone/repository/document_repository.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void signOut(WidgetRef ref) {
    ref.read(authRepositoryProvider).signOut();
    ref.watch(userProvider.notifier).update((state) => null);
  }

  void createDocument(WidgetRef ref, BuildContext context) async {
    String? token = ref.read(userProvider)!.token!;
    final navigator = Routemaster.of(context);
    final snackBar = ScaffoldMessenger.of(context);

    final errorModel =
        await ref.read(documentRepositoryProvider).createDocument(token);
    if (errorModel.data != null) {
      navigator.push("/document/${errorModel.data.id}");
    } else {
      snackBar.showSnackBar(SnackBar(content: Text(errorModel.error!)));
    }
  }

  void navigateToDocument(BuildContext context, String id) {
    Routemaster.of(context).push("/document/$id");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: () => createDocument(ref, context),
            icon: const Icon(
              Icons.add,
              color: kBlackColor,
            ),
          ),
          IconButton(
            onPressed: () => signOut(ref),
            icon: const Icon(
              Icons.logout,
              color: kRedColor,
            ),
          ),
        ],
      ),
      body: FutureBuilder<ErrorModel>(
        future: ref
            .watch(documentRepositoryProvider)
            .getDocument(ref.watch(userProvider)!.token!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              children: List.generate(
                snapshot.data!.data!.length,
                (index) {
                  DocumentModel document = snapshot.data!.data![index];
                  return InkWell(
                    onTap: () => navigateToDocument(context, document.id!),
                    child: SizedBox(
                      height: 150,
                      width: 150,
                      child: Card(
                        child: Center(
                          child: Text(
                            document.title!,
                            style: const TextStyle(
                              color: kRedColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
