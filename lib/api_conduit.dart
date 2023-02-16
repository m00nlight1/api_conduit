import 'dart:io';
import 'package:api_conduit/controllers/app_category_controller.dart';
import 'package:api_conduit/controllers/app_note_token.dart';
import 'package:api_conduit/controllers/app_notes_history_controller.dart';
import 'package:api_conduit/controllers/app_token_controller.dart';
import 'package:api_conduit/controllers/app_user_controller.dart';
import 'package:conduit/conduit.dart';
import 'controllers/app_auth_controller.dart';

class AppService extends ApplicationChannel {
  late final ManagedContext managedContext;

  @override
  Future prepare() {
    final persistentStore = _initDatabase();

    managedContext = ManagedContext(
        ManagedDataModel.fromCurrentMirrorSystem(), persistentStore);

    return super.prepare();
  }

  @override
  Controller get entryPoint => Router()
    ..route('notes-history')
        .link(AppTokenController.new)!
        .link(() => AppNotesHistoryController(managedContext))
    ..route('category/[:id]')
        .link(AppTokenController.new)!
        .link(() => AppCategoryController(managedContext))
    ..route('note/[:id]')
        .link(AppTokenController.new)!
        .link(() => AppNoteController(managedContext))
    ..route('token/[:refresh]').link(
      () => AppAuthController(managedContext),
    )
    ..route('user')
        .link(AppTokenController.new)!
        .link(() => AppUserController(managedContext));

  PersistentStore _initDatabase() {
    final username = Platform.environment['DB_USERNAME'] ?? 'postgres';
    final password = Platform.environment['DB_PASSWORD'] ?? '1424';
    final host = Platform.environment['DB_HOST'] ?? '127.0.0.1';
    final port = int.parse(Platform.environment['DB_PORT'] ?? '5432');
    final databaseName = Platform.environment['DB_NAME'] ?? 'postgres';
    return PostgreSQLPersistentStore(
        username, password, host, port, databaseName);
  }
}
