import 'dart:async';
import 'package:conduit_core/conduit_core.dart';   

class Migration13 extends Migration { 
  @override
  Future upgrade() async {
   		database.addColumn("_Note", SchemaColumn.relationship("user", ManagedPropertyType.bigInteger, relatedTableName: "_User", relatedColumnName: "id", rule: DeleteRule.nullify, isNullable: true, isUnique: false));
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    