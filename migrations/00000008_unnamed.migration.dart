import 'dart:async';
import 'package:conduit_core/conduit_core.dart';   

class Migration8 extends Migration { 
  @override
  Future upgrade() async {
   		database.addColumn("_Note", SchemaColumn("createdAt", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false));
		database.deleteColumn("_Note", "created_at");
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    