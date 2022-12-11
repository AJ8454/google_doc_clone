import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_doc_clone/models/document_model.dart';
import 'package:google_doc_clone/models/error_model.dart';
import 'package:http/http.dart';

import '../constants.dart';

final documentRepositoryProvider =
    Provider((ref) => DocumentRepository(client: Client()));

class DocumentRepository {
  final Client _client;
  DocumentRepository({required Client client}) : _client = client;

  Future<ErrorModel> createDocument(String token) async {
    ErrorModel error =
        ErrorModel(error: "Some unexpected error occured.", data: null);
    try {
      var res = await _client.post(Uri.parse("$host/doc/create"),
          body:
              jsonEncode({"createdAt": DateTime.now().millisecondsSinceEpoch}),
          headers: {
            "Content-Type": "application/json; charset=UTF-8",
            "x-auth-token": token,
          });

      switch (res.statusCode) {
        case 200:
          error =
              ErrorModel(error: null, data: DocumentModel.fromJson(res.body));
          break;
        default:
          error = ErrorModel(error: res.body, data: null);
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }

  Future<ErrorModel> getDocument(String token) async {
    ErrorModel error =
        ErrorModel(error: "Some unexpected error occured.", data: null);
    try {
      var res = await _client.get(Uri.parse("$host/docs/me"), headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "x-auth-token": token,
      });

      switch (res.statusCode) {
        case 200:
          List<DocumentModel> documents = [];
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            documents.add(
                DocumentModel.fromJson(jsonEncode(jsonDecode(res.body)[i])));
          }
          error = ErrorModel(error: null, data: documents);
          break;
        default:
          error = ErrorModel(error: res.body, data: null);
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }

  void updateTitle({
    required String? token,
    required String? id,
    required String? title,
  }) async {
    try {
      await _client.post(Uri.parse("$host/doc/title"),
          body: jsonEncode({"id": id, "title": title}),
          headers: {
            "Content-Type": "application/json; charset=UTF-8",
            "x-auth-token": token!,
          });
    } catch (e) {
      log("error on update title $e");
    }
  }

  Future<ErrorModel> getDocumentById(String token, String id) async {
    ErrorModel error =
        ErrorModel(error: "Some unexpected error occured.", data: null);
    try {
      var res = await _client.get(Uri.parse("$host/doc/$id"), headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "x-auth-token": token,
      });

      switch (res.statusCode) {
        case 200:
          error =
              ErrorModel(error: null, data: DocumentModel.fromJson(res.body));
          break;
        default:
          throw "This Document does not exits, Please create a new one.";
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }
}
