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


/** This is an auto generated class representing the UserModel type in your schema. */
@immutable
class UserModel extends Model {
  static const classType = const _UserModelModelType();
  final String id;
  final String? _Name;
  final String? _Email;
  final String? _PhoneNumber;
  final String? _Gender;
  final String? _Birthday;
  final int? _Age;
  final String? _Bio;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get Name {
    return _Name;
  }
  
  String? get Email {
    return _Email;
  }
  
  String? get PhoneNumber {
    return _PhoneNumber;
  }
  
  String? get Gender {
    return _Gender;
  }
  
  String? get Birthday {
    return _Birthday;
  }
  
  int? get Age {
    return _Age;
  }
  
  String? get Bio {
    return _Bio;
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const UserModel._internal({required this.id, Name, Email, PhoneNumber, Gender, Birthday, Age, Bio, createdAt, updatedAt}): _Name = Name, _Email = Email, _PhoneNumber = PhoneNumber, _Gender = Gender, _Birthday = Birthday, _Age = Age, _Bio = Bio, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory UserModel({String? id, String? Name, String? Email, String? PhoneNumber, String? Gender, String? Birthday, int? Age, String? Bio}) {
    return UserModel._internal(
      id: id == null ? UUID.getUUID() : id,
      Name: Name,
      Email: Email,
      PhoneNumber: PhoneNumber,
      Gender: Gender,
      Birthday: Birthday,
      Age: Age,
      Bio: Bio);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserModel &&
      id == other.id &&
      _Name == other._Name &&
      _Email == other._Email &&
      _PhoneNumber == other._PhoneNumber &&
      _Gender == other._Gender &&
      _Birthday == other._Birthday &&
      _Age == other._Age &&
      _Bio == other._Bio;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("UserModel {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("Name=" + "$_Name" + ", ");
    buffer.write("Email=" + "$_Email" + ", ");
    buffer.write("PhoneNumber=" + "$_PhoneNumber" + ", ");
    buffer.write("Gender=" + "$_Gender" + ", ");
    buffer.write("Birthday=" + "$_Birthday" + ", ");
    buffer.write("Age=" + (_Age != null ? _Age!.toString() : "null") + ", ");
    buffer.write("Bio=" + "$_Bio" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  UserModel copyWith({String? id, String? Name, String? Email, String? PhoneNumber, String? Gender, String? Birthday, int? Age, String? Bio}) {
    return UserModel._internal(
      id: id ?? this.id,
      Name: Name ?? this.Name,
      Email: Email ?? this.Email,
      PhoneNumber: PhoneNumber ?? this.PhoneNumber,
      Gender: Gender ?? this.Gender,
      Birthday: Birthday ?? this.Birthday,
      Age: Age ?? this.Age,
      Bio: Bio ?? this.Bio);
  }
  
  UserModel.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _Name = json['Name'],
      _Email = json['Email'],
      _PhoneNumber = json['PhoneNumber'],
      _Gender = json['Gender'],
      _Birthday = json['Birthday'],
      _Age = (json['Age'] as num?)?.toInt(),
      _Bio = json['Bio'],
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'Name': _Name, 'Email': _Email, 'PhoneNumber': _PhoneNumber, 'Gender': _Gender, 'Birthday': _Birthday, 'Age': _Age, 'Bio': _Bio, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };

  static final QueryField ID = QueryField(fieldName: "userModel.id");
  static final QueryField NAME = QueryField(fieldName: "Name");
  static final QueryField EMAIL = QueryField(fieldName: "Email");
  static final QueryField PHONENUMBER = QueryField(fieldName: "PhoneNumber");
  static final QueryField GENDER = QueryField(fieldName: "Gender");
  static final QueryField BIRTHDAY = QueryField(fieldName: "Birthday");
  static final QueryField AGE = QueryField(fieldName: "Age");
  static final QueryField BIO = QueryField(fieldName: "Bio");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "UserModel";
    modelSchemaDefinition.pluralName = "UserModels";
    
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
      key: UserModel.NAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: UserModel.EMAIL,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: UserModel.PHONENUMBER,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: UserModel.GENDER,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: UserModel.BIRTHDAY,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: UserModel.AGE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: UserModel.BIO,
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

class _UserModelModelType extends ModelType<UserModel> {
  const _UserModelModelType();
  
  @override
  UserModel fromJson(Map<String, dynamic> jsonData) {
    return UserModel.fromJson(jsonData);
  }
}