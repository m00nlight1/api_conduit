import 'dart:async';
import 'package:conduit_core/conduit_core.dart';   

class Migration10 extends Migration { 
  @override
  Future upgrade() async {
   		database.alterColumn("_Note", "createdAt", (c) {c.isIndexed = true;});
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    