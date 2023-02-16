import 'package:api_conduit/model/note.dart';
import 'package:conduit/conduit.dart';

class User extends ManagedObject<_User> implements _User {
  Map<String, dynamic> toJson() => asMap();
}

class _User {
  @primaryKey
  int? id;
  @Column(unique: true, indexed: true)
  String? userName;
  @Column(unique: true, indexed: true)
  String? email;
  @Serialize(input: true, output: false)
  String? password;
  @Column(nullable: true)
  String? accessToken;
  @Column(nullable: true)
  String? refreshToken;

  @Column(omitByDefault: true)
  String? salt;
  @Column(omitByDefault: true)
  String? hashPassword;

  ManagedSet<Note>? notes;
}
