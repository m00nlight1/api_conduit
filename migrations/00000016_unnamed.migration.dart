import 'dart:async';
import 'package:conduit_core/conduit_core.dart';   

class Migration16 extends Migration { 
  @override
  Future upgrade() async {
   		database.deleteTable("_NoteHistory");
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    