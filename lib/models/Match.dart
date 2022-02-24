/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, file_names, unnecessary_new, prefer_if_null_operators, prefer_const_constructors, slash_for_doc_comments, annotate_overrides, non_constant_identifier_names, unnecessary_string_interpolations, prefer_adjacent_string_concatenation, unnecessary_const, dead_code

import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the Match type in your schema. */
@immutable
class Match extends Model {
  static const classType = const _MatchModelType();
  final String id;
  final String? _User1ID;
  final String? _User1Name;
  final String? _User2ID;
  final String? _User2Name;
  final String? _Location;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get User1ID {
    return _User1ID;
  }
  
  String? get User1Name {
    return _User1Name;
  }
  
  String? get User2ID {
    return _User2ID;
  }
  
  String? get User2Name {
    return _User2Name;
  }
  
  String? get Location {
    return _Location;
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Match._internal({required this.id, User1ID, User1Name, User2ID, User2Name, Location, createdAt, updatedAt}): _User1ID = User1ID, _User1Name = User1Name, _User2ID = User2ID, _User2Name = User2Name, _Location = Location, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Match({String? id, String? User1ID, String? User1Name, String? User2ID, String? User2Name, String? Location}) {
    return Match._internal(
      id: id == null ? UUID.getUUID() : id,
      User1ID: User1ID,
      User1Name: User1Name,
      User2ID: User2ID,
      User2Name: User2Name,
      Location: Location);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Match &&
      id == other.id &&
      _User1ID == other._User1ID &&
      _User1Name == other._User1Name &&
      _User2ID == other._User2ID &&
      _User2Name == other._User2Name &&
      _Location == other._Location;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Match {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("User1ID=" + "$_User1ID" + ", ");
    buffer.write("User1Name=" + "$_User1Name" + ", ");
    buffer.write("User2ID=" + "$_User2ID" + ", ");
    buffer.write("User2Name=" + "$_User2Name" + ", ");
    buffer.write("Location=" + "$_Location" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Match copyWith({String? id, String? User1ID, String? User1Name, String? User2ID, String? User2Name, String? Location}) {
    return Match._internal(
      id: id ?? this.id,
      User1ID: User1ID ?? this.User1ID,
      User1Name: User1Name ?? this.User1Name,
      User2ID: User2ID ?? this.User2ID,
      User2Name: User2Name ?? this.User2Name,
      Location: Location ?? this.Location);
  }
  
  Match.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _User1ID = json['User1ID'],
      _User1Name = json['User1Name'],
      _User2ID = json['User2ID'],
      _User2Name = json['User2Name'],
      _Location = json['Location'],
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'User1ID': _User1ID, 'User1Name': _User1Name, 'User2ID': _User2ID, 'User2Name': _User2Name, 'Location': _Location, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };

  static final QueryField ID = QueryField(fieldName: "match.id");
  static final QueryField USER1ID = QueryField(fieldName: "User1ID");
  static final QueryField USER1NAME = QueryField(fieldName: "User1Name");
  static final QueryField USER2ID = QueryField(fieldName: "User2ID");
  static final QueryField USER2NAME = QueryField(fieldName: "User2Name");
  static final QueryField LOCATION = QueryField(fieldName: "Location");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Match";
    modelSchemaDefinition.pluralName = "Matches";
    
    modelSchemaDefinition.authRules = [
      AuthRule(
        authStrategy: AuthStrategy.PUBLIC,
        operations: [
          ModelOperation.CREATE,
          ModelOperation.UPDATE,
          ModelOperation.DELETE,
          ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Match.USER1ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Match.USER1NAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Match.USER2ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Match.USER2NAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Match.LOCATION,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _MatchModelType extends ModelType<Match> {
  const _MatchModelType();
  
  @override
  Match fromJson(Map<String, dynamic> jsonData) {
    return Match.fromJson(jsonData);
  }
}