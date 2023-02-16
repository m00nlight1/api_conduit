import 'package:api_conduit/model/model_response.dart';
import 'package:api_conduit/model/note.dart';
import 'package:api_conduit/utils/app_response.dart';
import 'package:conduit/conduit.dart';

class AppNotesHistoryController extends ResourceController {
  AppNotesHistoryController(this.managedContext);

  final ManagedContext managedContext;

  @Operation.get()
  Future<Response> getNoteHistory() async {
    try {
      final qNoteHistory = Query<NoteHistory>(managedContext);
      final List<NoteHistory> list = await qNoteHistory.fetch();

      if (list.isEmpty) {
        return Response.notFound(
            body: ModelResponse(data: [], message: "История действий пуста"));
      }

      return Response.ok(list);
    } catch (e) {
      return AppResponse.serverError(e);
    }
  }
}
