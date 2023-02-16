import 'dart:async';
import 'package:conduit_core/conduit_core.dart';   

class Migration11 extends Migration { 
  @override
  Future upgrade() async {
   		database.alterColumn("_Note", "name", (c) {c.isIndexed = true;});
		database.alterColumn("_Note", "content", (c) {c.isIndexed = true;});
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    