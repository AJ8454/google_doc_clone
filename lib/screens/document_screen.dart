import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_doc_clone/colors.dart';
import 'package:google_doc_clone/models/document_model.dart';
import 'package:google_doc_clone/models/error_model.dart';
import 'package:google_doc_clone/repository/auth_repository.dart';
import 'package:google_doc_clone/repository/document_repository.dart';

class DocumentScreen extends ConsumerStatefulWidget {
  final String? id;
  const DocumentScreen({super.key, required this.id});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  TextEditingController titleController =
      TextEditingController(text: "Untitled Document");

  final quill.QuillController _controller = quill.QuillController.basic();
  ErrorModel? errorModel;

  @override
  void initState() {
    super.initState();
    fetchDocumentData();
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  void fetchDocumentData() async {
    errorModel = await ref.read(documentRepositoryProvider).getDocumentById(
          ref.read(userProvider)!.token!,
          widget.id!,
        );
    if (errorModel!.data != null) {
      titleController.text = (errorModel!.data as DocumentModel).title!;
      setState(() {});
    }
  }

  void updateTitle(WidgetRef ref, String title) {
    ref.read(documentRepositoryProvider).updateTitle(
          id: widget.id,
          token: ref.read(userProvider)!.token,
          title: title,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kWhiteColor,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: kGreyColor, width: 0.1),
              ),
            ),
          ),
          elevation: 0.0,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.lock),
                label: const Text("Share"),
                style: ElevatedButton.styleFrom(backgroundColor: kBlueColor),
              ),
            )
          ],
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/docLogo.png',
                  height: 40,
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kBlueColor),
                      ),
                    ),
                    onSubmitted: (value) => updateTitle(ref, value),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
              quill.QuillToolbar.basic(controller: _controller),
              Expanded(
                child: SizedBox(
                  width: 750,
                  child: Card(
                    color: kWhiteColor,
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: quill.QuillEditor.basic(
                        controller: _controller,
                        readOnly: false, // true for view only mode
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
