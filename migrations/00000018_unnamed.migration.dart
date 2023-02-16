import 'dart:async';
import 'package:conduit_core/conduit_core.dart';   

class Migration18 extends Migration { 
  @override
  Future upgrade() async {
   		database.deleteTable("_Note");
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    