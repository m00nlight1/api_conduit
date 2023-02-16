import 'package:api_conduit/model/category.dart';
import 'package:api_conduit/model/user.dart';
import 'package:conduit/conduit.dart';

class Note extends ManagedObject<_Note> implements _Note {}

class _Note {
  @primaryKey
  int? id;
  @Column(indexed: true)
  String? name;
  @Column(indexed: true)
  String? content;
  @Column(indexed: true)
  String? createdAt;
  @Column()
  bool? isDeleted;

  @Serialize(input: true, output: false)
  int? idCategory;

  @Relate(#notes)
  User? user;

  @Relate(#noteList, isRequired: true, onDelete: DeleteRule.cascade)
  Category? category;
}

class NoteHistory extends ManagedObject<_NoteHistory> implements _NoteHistory {}

class _NoteHistory {
  @Column(primaryKey: true)
  String? dateOfAction;

  @Column(indexed: true)
  String? contentOfAction;
}
