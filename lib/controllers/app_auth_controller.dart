import 'dart:io';

import 'package:api_conduit/model/model_response.dart';
import 'package:api_conduit/model/note.dart';
import 'package:api_conduit/model/user.dart';
import 'package:api_conduit/utils/app_response.dart';
import 'package:api_conduit/utils/app_utils.dart';
import 'package:conduit/conduit.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class AppAuthController extends ResourceController {
  AppAuthController(this.managedContext);

  final ManagedContext managedContext;

  @Operation.post()
  Future<Response> signIn(@Bind.body() User user) async {
    if (user.password == null || user.userName == null) {
      return Response.badRequest(
          body: ModelResponse(message: 'Поля username и password обязательны'));
    }

    try {
      final qFindUser = Query<User>(managedContext)
        ..where((x) => x.userName).equalTo(user.userName)
        ..returningProperties((x) => [x.id, x.salt, x.hashPassword]);

      final findUser = await qFindUser.fetchOne();

      if (findUser == null) {
        throw QueryException.input('Пользователь не найден', []);
      }

      final requestHashPassword =
          generatePasswordHash(user.password ?? '', findUser.salt ?? '');

      if (requestHashPassword == findUser.hashPassword) {
        _updateTokens(findUser.id ?? -1, managedContext);

        final newUser =
            await managedContext.fetchObjectWithID<User>(findUser.id);

        return Response.ok(ModelResponse(
            data: newUser!.backing.contents, message: 'Успешная авторизация'));
      } else {
        throw QueryException.input('Неверный пароль', []);
      }
    } catch (e) {
      return AppResponse.serverError(e);
    }
  }

  @Operation.put()
  Future<Response> signUp(@Bind.body() User user) async {
    if (user.password == null || user.userName == null || user.email == null) {
      return Response.badRequest(
          body: ModelResponse(
              message: 'Поля username, email и password обязательны'));
    }

    final salt = generateRandomSalt();
    final hashPassword = generatePasswordHash(user.password!, salt);

    try {
      late final int id;

      await managedContext.transaction((transaction) async {
        final qCreateUser = Query<User>(transaction)
          ..values.userName = user.userName
          ..values.email = user.email
          ..values.salt = salt
          ..values.hashPassword = hashPassword;

        final createdUser = await qCreateUser.insert();
        id = createdUser.id!;
        _updateTokens(id, transaction);
      });

      final userData = await managedContext.fetchObjectWithID<User>(id);

      final qNoteHistory = Query<NoteHistory>(managedContext)
        ..values.contentOfAction =
            'Зарегистрировался пользователь: ${user.userName}. Email: ${user.email}'
        ..values.dateOfAction = DateTime.now().toString();
      await qNoteHistory.insert();

      return AppResponse.ok(
          body: userData!.backing.contents,
          message: 'Пользователь успешно зарегистрировался');
    } catch (e) {
      return AppResponse.serverError(e);
    }
  }

  @Operation.post('refresh')
  Future<Response> refreshToken(
      @Bind.path('refresh') String refreshToken) async {
    try {
      final id = AppUtils.getIdFromToken(refreshToken);
      final user = await managedContext.fetchObjectWithID<User>(id);
      if (user!.refreshToken != refreshToken) {
        return Response.unauthorized(body: 'Token не валидный');
      }

      _updateTokens(id, managedContext);

      return Response.ok(ModelResponse(
          data: user.backing.contents, message: 'Token успешно обновлен'));
    } catch (e) {
      return AppResponse.serverError(e);
    }
  }

  void _updateTokens(int id, ManagedContext transaction) async {
    final Map<String, String> tokens = _getTokens(id);
    final qUpdateTokens = Query<User>(transaction)
      ..where((x) => x.id).equalTo(id)
      ..values.accessToken = tokens['access']
      ..values.refreshToken = tokens['refresh'];

    await qUpdateTokens.updateOne();
  }

  Map<String, String> _getTokens(int id) {
    final key = Platform.environment['SECRET_KEY'] ?? 'SECRET_KEY';
    final accessClaimSet =
        JwtClaim(maxAge: const Duration(hours: 1), otherClaims: {'id': id});
    final refreshClaimSet = JwtClaim(otherClaims: {'id': id});
    final tokens = <String, String>{};
    tokens['access'] = issueJwtHS256(accessClaimSet, key);
    tokens['refresh'] = issueJwtHS256(refreshClaimSet, key);

    return tokens;
  }
}
