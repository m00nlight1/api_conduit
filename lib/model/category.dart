import 'package:api_conduit/model/note.dart';
import 'package:conduit/conduit.dart';

class Category extends ManagedObject<_Category> implements _Category {}

class _Category {
  @primaryKey
  int? id;

  @Column(unique: true, indexed: true)
  String? name;

  ManagedSet<Note>? noteList;
}
