import 'dart:async';
import 'package:conduit_core/conduit_core.dart';   

class Migration15 extends Migration { 
  @override
  Future upgrade() async {
   		database.createTable(SchemaTable("_NoteHistory", [SchemaColumn("dateOfAction", ManagedPropertyType.datetime, isPrimaryKey: true, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),SchemaColumn("contentOfAction", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: true, isNullable: false, isUnique: false)]));
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    