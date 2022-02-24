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


/** This is an auto generated class representing the Location type in your schema. */
@immutable
class Location extends Model {
  static const classType = const _LocationModelType();
  final String id;
  final String? _BarName;
  final String? _Region;
  final String? _BarUsers;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String get BarName {
    try {
      return _BarName!;
    } catch(e) {
      throw new DataStoreException(
      DataStoreExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
      recoverySuggestion:
        DataStoreExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
      underlyingException: e.toString()
    );
    }
  }
  
  String get Region {
    try {
      return _Region!;
    } catch(e) {
      throw new DataStoreException(
      DataStoreExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
      recoverySuggestion:
        DataStoreExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
      underlyingException: e.toString()
    );
    }
  }
  
  String? get BarUsers {
    return _BarUsers;
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Location._internal({required this.id, required BarName, required Region, BarUsers, createdAt, updatedAt}): _BarName = BarName, _Region = Region, _BarUsers = BarUsers, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Location({String? id, required String BarName, required String Region, String? BarUsers}) {
    return Location._internal(
      id: id == null ? UUID.getUUID() : id,
      BarName: BarName,
      Region: Region,
      BarUsers: BarUsers);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Location &&
      id == other.id &&
      _BarName == other._BarName &&
      _Region == other._Region &&
      _BarUsers == other._BarUsers;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Location {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("BarName=" + "$_BarName" + ", ");
    buffer.write("Region=" + "$_Region" + ", ");
    buffer.write("BarUsers=" + "$_BarUsers" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Location copyWith({String? id, String? BarName, String? Region, String? BarUsers}) {
    return Location._internal(
      id: id ?? this.id,
      BarName: BarName ?? this.BarName,
      Region: Region ?? this.Region,
      BarUsers: BarUsers ?? this.BarUsers);
  }
  
  Location.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _BarName = json['BarName'],
      _Region = json['Region'],
      _BarUsers = json['BarUsers'],
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'BarName': _BarName, 'Region': _Region, 'BarUsers': _BarUsers, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };

  static final QueryField ID = QueryField(fieldName: "location.id");
  static final QueryField BARNAME = QueryField(fieldName: "BarName");
  static final QueryField REGION = QueryField(fieldName: "Region");
  static final QueryField BARUSERS = QueryField(fieldName: "BarUsers");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Location";
    modelSchemaDefinition.pluralName = "Locations";
    
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
      key: Location.BARNAME,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Location.REGION,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Location.BARUSERS,
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

class _LocationModelType extends ModelType<Location> {
  const _LocationModelType();
  
  @override
  Location fromJson(Map<String, dynamic> jsonData) {
    return Location.fromJson(jsonData);
  }
}