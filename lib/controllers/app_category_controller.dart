import 'package:api_conduit/model/category.dart';
import 'package:api_conduit/model/model_response.dart';
import 'package:api_conduit/utils/app_response.dart';
import 'package:conduit/conduit.dart';

class AppCategoryController extends ResourceController {
  AppCategoryController(this.managedContext);

  final ManagedContext managedContext;

  @Operation.post()
  Future<Response> createCategory(@Bind.body() Category category) async {
    try {
      final qCreateCategory = Query<Category>(managedContext)
        ..values.name = category.name;
      await qCreateCategory.insert();
      return AppResponse.ok(message: "Успешное создание категории");
    } catch (e) {
      return AppResponse.serverError(e, message: "Ошибка создания категории");
    }
  }

  @Operation.get()
  Future<Response> getCategories() async {
    try {
      final qCreateCategory = Query<Category>(managedContext)
        ..join(set: (x) => x.noteList);
      final categories = await qCreateCategory.fetch();
      if (categories.isEmpty) {
        return Response.notFound(
            body: ModelResponse(data: [], message: "Категорий не найдено"));
      }

      return Response.ok(categories);
    } catch (e) {
      return AppResponse.serverError(e);
    }
  }

  @Operation.put("id")
  Future<Response> updateCategory(
      @Bind.path("id") int id, @Bind.body() Category bodyCategory) async {
    try {
      final category = await managedContext.fetchObjectWithID<Category>(id);
      if (category == null) {
        return AppResponse.ok(message: "Категория не найдена");
      }
      final qUpdateCategory = Query<Category>(managedContext)
        ..where((x) => x.id).equalTo(id)
        ..values.name = bodyCategory.name;

      await qUpdateCategory.update();

      return AppResponse.ok(message: "Категория изменена");
    } catch (e) {
      return AppResponse.serverError(e);
    }
  }

  @Operation.delete("id")
  Future<Response> deleteCategory(@Bind.path("id") int id) async {
    try {
      final category = await managedContext.fetchObjectWithID<Category>(id);
      if (category == null) {
        return AppResponse.ok(message: "Категория не найдена");
      }
      final qDeleteCategory = Query<Category>(managedContext)
        ..where((x) => x.id).equalTo(id);
      await qDeleteCategory.delete();

      return AppResponse.ok(message: "Успешное удаление категории");
    } catch (e) {
      return AppResponse.serverError(e);
    }
  }
}
