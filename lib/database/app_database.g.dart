// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    icon,
    color,
    type,
    isDefault,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String name;
  final String icon;
  final int color;
  final String type;
  final bool isDefault;
  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
    required this.isDefault,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['icon'] = Variable<String>(icon);
    map['color'] = Variable<int>(color);
    map['type'] = Variable<String>(type);
    map['is_default'] = Variable<bool>(isDefault);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      icon: Value(icon),
      color: Value(color),
      type: Value(type),
      isDefault: Value(isDefault),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String>(json['icon']),
      color: serializer.fromJson<int>(json['color']),
      type: serializer.fromJson<String>(json['type']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String>(icon),
      'color': serializer.toJson<int>(color),
      'type': serializer.toJson<String>(type),
      'isDefault': serializer.toJson<bool>(isDefault),
    };
  }

  Category copyWith({
    int? id,
    String? name,
    String? icon,
    int? color,
    String? type,
    bool? isDefault,
  }) => Category(
    id: id ?? this.id,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    color: color ?? this.color,
    type: type ?? this.type,
    isDefault: isDefault ?? this.isDefault,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      type: data.type.present ? data.type.value : this.type,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('type: $type, ')
          ..write('isDefault: $isDefault')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, icon, color, type, isDefault);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.type == this.type &&
          other.isDefault == this.isDefault);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> icon;
  final Value<int> color;
  final Value<String> type;
  final Value<bool> isDefault;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.type = const Value.absent(),
    this.isDefault = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String icon,
    required int color,
    required String type,
    this.isDefault = const Value.absent(),
  }) : name = Value(name),
       icon = Value(icon),
       color = Value(color),
       type = Value(type);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<int>? color,
    Expression<String>? type,
    Expression<bool>? isDefault,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (type != null) 'type': type,
      if (isDefault != null) 'is_default': isDefault,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? icon,
    Value<int>? color,
    Value<String>? type,
    Value<bool>? isDefault,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      type: type ?? this.type,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('type: $type, ')
          ..write('isDefault: $isDefault')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isAutoImportedMeta = const VerificationMeta(
    'isAutoImported',
  );
  @override
  late final GeneratedColumn<bool> isAutoImported = GeneratedColumn<bool>(
    'is_auto_imported',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_auto_imported" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _emailMessageIdMeta = const VerificationMeta(
    'emailMessageId',
  );
  @override
  late final GeneratedColumn<String> emailMessageId = GeneratedColumn<String>(
    'email_message_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _integratedToBudgetMeta =
      const VerificationMeta('integratedToBudget');
  @override
  late final GeneratedColumn<bool> integratedToBudget = GeneratedColumn<bool>(
    'integrated_to_budget',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("integrated_to_budget" IN (0, 1))',
    ),
  );
  static const VerificationMeta _budgetIntegrationTypeMeta =
      const VerificationMeta('budgetIntegrationType');
  @override
  late final GeneratedColumn<String> budgetIntegrationType =
      GeneratedColumn<String>(
        'budget_integration_type',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _targetSemesterIdMeta = const VerificationMeta(
    'targetSemesterId',
  );
  @override
  late final GeneratedColumn<int> targetSemesterId = GeneratedColumn<int>(
    'target_semester_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    amount,
    type,
    categoryId,
    description,
    date,
    isAutoImported,
    emailMessageId,
    integratedToBudget,
    budgetIntegrationType,
    targetSemesterId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Transaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('is_auto_imported')) {
      context.handle(
        _isAutoImportedMeta,
        isAutoImported.isAcceptableOrUnknown(
          data['is_auto_imported']!,
          _isAutoImportedMeta,
        ),
      );
    }
    if (data.containsKey('email_message_id')) {
      context.handle(
        _emailMessageIdMeta,
        emailMessageId.isAcceptableOrUnknown(
          data['email_message_id']!,
          _emailMessageIdMeta,
        ),
      );
    }
    if (data.containsKey('integrated_to_budget')) {
      context.handle(
        _integratedToBudgetMeta,
        integratedToBudget.isAcceptableOrUnknown(
          data['integrated_to_budget']!,
          _integratedToBudgetMeta,
        ),
      );
    }
    if (data.containsKey('budget_integration_type')) {
      context.handle(
        _budgetIntegrationTypeMeta,
        budgetIntegrationType.isAcceptableOrUnknown(
          data['budget_integration_type']!,
          _budgetIntegrationTypeMeta,
        ),
      );
    }
    if (data.containsKey('target_semester_id')) {
      context.handle(
        _targetSemesterIdMeta,
        targetSemesterId.isAcceptableOrUnknown(
          data['target_semester_id']!,
          _targetSemesterIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      isAutoImported: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_auto_imported'],
      )!,
      emailMessageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email_message_id'],
      ),
      integratedToBudget: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}integrated_to_budget'],
      ),
      budgetIntegrationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_integration_type'],
      ),
      targetSemesterId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_semester_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final int id;
  final double amount;
  final String type;
  final int categoryId;
  final String description;
  final DateTime date;
  final bool isAutoImported;
  final String? emailMessageId;
  final bool? integratedToBudget;
  final String? budgetIntegrationType;
  final int? targetSemesterId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.description,
    required this.date,
    required this.isAutoImported,
    this.emailMessageId,
    this.integratedToBudget,
    this.budgetIntegrationType,
    this.targetSemesterId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['amount'] = Variable<double>(amount);
    map['type'] = Variable<String>(type);
    map['category_id'] = Variable<int>(categoryId);
    map['description'] = Variable<String>(description);
    map['date'] = Variable<DateTime>(date);
    map['is_auto_imported'] = Variable<bool>(isAutoImported);
    if (!nullToAbsent || emailMessageId != null) {
      map['email_message_id'] = Variable<String>(emailMessageId);
    }
    if (!nullToAbsent || integratedToBudget != null) {
      map['integrated_to_budget'] = Variable<bool>(integratedToBudget);
    }
    if (!nullToAbsent || budgetIntegrationType != null) {
      map['budget_integration_type'] = Variable<String>(budgetIntegrationType);
    }
    if (!nullToAbsent || targetSemesterId != null) {
      map['target_semester_id'] = Variable<int>(targetSemesterId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      amount: Value(amount),
      type: Value(type),
      categoryId: Value(categoryId),
      description: Value(description),
      date: Value(date),
      isAutoImported: Value(isAutoImported),
      emailMessageId: emailMessageId == null && nullToAbsent
          ? const Value.absent()
          : Value(emailMessageId),
      integratedToBudget: integratedToBudget == null && nullToAbsent
          ? const Value.absent()
          : Value(integratedToBudget),
      budgetIntegrationType: budgetIntegrationType == null && nullToAbsent
          ? const Value.absent()
          : Value(budgetIntegrationType),
      targetSemesterId: targetSemesterId == null && nullToAbsent
          ? const Value.absent()
          : Value(targetSemesterId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Transaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<int>(json['id']),
      amount: serializer.fromJson<double>(json['amount']),
      type: serializer.fromJson<String>(json['type']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      description: serializer.fromJson<String>(json['description']),
      date: serializer.fromJson<DateTime>(json['date']),
      isAutoImported: serializer.fromJson<bool>(json['isAutoImported']),
      emailMessageId: serializer.fromJson<String?>(json['emailMessageId']),
      integratedToBudget: serializer.fromJson<bool?>(
        json['integratedToBudget'],
      ),
      budgetIntegrationType: serializer.fromJson<String?>(
        json['budgetIntegrationType'],
      ),
      targetSemesterId: serializer.fromJson<int?>(json['targetSemesterId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amount': serializer.toJson<double>(amount),
      'type': serializer.toJson<String>(type),
      'categoryId': serializer.toJson<int>(categoryId),
      'description': serializer.toJson<String>(description),
      'date': serializer.toJson<DateTime>(date),
      'isAutoImported': serializer.toJson<bool>(isAutoImported),
      'emailMessageId': serializer.toJson<String?>(emailMessageId),
      'integratedToBudget': serializer.toJson<bool?>(integratedToBudget),
      'budgetIntegrationType': serializer.toJson<String?>(
        budgetIntegrationType,
      ),
      'targetSemesterId': serializer.toJson<int?>(targetSemesterId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Transaction copyWith({
    int? id,
    double? amount,
    String? type,
    int? categoryId,
    String? description,
    DateTime? date,
    bool? isAutoImported,
    Value<String?> emailMessageId = const Value.absent(),
    Value<bool?> integratedToBudget = const Value.absent(),
    Value<String?> budgetIntegrationType = const Value.absent(),
    Value<int?> targetSemesterId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Transaction(
    id: id ?? this.id,
    amount: amount ?? this.amount,
    type: type ?? this.type,
    categoryId: categoryId ?? this.categoryId,
    description: description ?? this.description,
    date: date ?? this.date,
    isAutoImported: isAutoImported ?? this.isAutoImported,
    emailMessageId: emailMessageId.present
        ? emailMessageId.value
        : this.emailMessageId,
    integratedToBudget: integratedToBudget.present
        ? integratedToBudget.value
        : this.integratedToBudget,
    budgetIntegrationType: budgetIntegrationType.present
        ? budgetIntegrationType.value
        : this.budgetIntegrationType,
    targetSemesterId: targetSemesterId.present
        ? targetSemesterId.value
        : this.targetSemesterId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      amount: data.amount.present ? data.amount.value : this.amount,
      type: data.type.present ? data.type.value : this.type,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      description: data.description.present
          ? data.description.value
          : this.description,
      date: data.date.present ? data.date.value : this.date,
      isAutoImported: data.isAutoImported.present
          ? data.isAutoImported.value
          : this.isAutoImported,
      emailMessageId: data.emailMessageId.present
          ? data.emailMessageId.value
          : this.emailMessageId,
      integratedToBudget: data.integratedToBudget.present
          ? data.integratedToBudget.value
          : this.integratedToBudget,
      budgetIntegrationType: data.budgetIntegrationType.present
          ? data.budgetIntegrationType.value
          : this.budgetIntegrationType,
      targetSemesterId: data.targetSemesterId.present
          ? data.targetSemesterId.value
          : this.targetSemesterId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('categoryId: $categoryId, ')
          ..write('description: $description, ')
          ..write('date: $date, ')
          ..write('isAutoImported: $isAutoImported, ')
          ..write('emailMessageId: $emailMessageId, ')
          ..write('integratedToBudget: $integratedToBudget, ')
          ..write('budgetIntegrationType: $budgetIntegrationType, ')
          ..write('targetSemesterId: $targetSemesterId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    amount,
    type,
    categoryId,
    description,
    date,
    isAutoImported,
    emailMessageId,
    integratedToBudget,
    budgetIntegrationType,
    targetSemesterId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.type == this.type &&
          other.categoryId == this.categoryId &&
          other.description == this.description &&
          other.date == this.date &&
          other.isAutoImported == this.isAutoImported &&
          other.emailMessageId == this.emailMessageId &&
          other.integratedToBudget == this.integratedToBudget &&
          other.budgetIntegrationType == this.budgetIntegrationType &&
          other.targetSemesterId == this.targetSemesterId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> id;
  final Value<double> amount;
  final Value<String> type;
  final Value<int> categoryId;
  final Value<String> description;
  final Value<DateTime> date;
  final Value<bool> isAutoImported;
  final Value<String?> emailMessageId;
  final Value<bool?> integratedToBudget;
  final Value<String?> budgetIntegrationType;
  final Value<int?> targetSemesterId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.type = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.description = const Value.absent(),
    this.date = const Value.absent(),
    this.isAutoImported = const Value.absent(),
    this.emailMessageId = const Value.absent(),
    this.integratedToBudget = const Value.absent(),
    this.budgetIntegrationType = const Value.absent(),
    this.targetSemesterId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required double amount,
    required String type,
    required int categoryId,
    required String description,
    required DateTime date,
    this.isAutoImported = const Value.absent(),
    this.emailMessageId = const Value.absent(),
    this.integratedToBudget = const Value.absent(),
    this.budgetIntegrationType = const Value.absent(),
    this.targetSemesterId = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : amount = Value(amount),
       type = Value(type),
       categoryId = Value(categoryId),
       description = Value(description),
       date = Value(date),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Transaction> custom({
    Expression<int>? id,
    Expression<double>? amount,
    Expression<String>? type,
    Expression<int>? categoryId,
    Expression<String>? description,
    Expression<DateTime>? date,
    Expression<bool>? isAutoImported,
    Expression<String>? emailMessageId,
    Expression<bool>? integratedToBudget,
    Expression<String>? budgetIntegrationType,
    Expression<int>? targetSemesterId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (type != null) 'type': type,
      if (categoryId != null) 'category_id': categoryId,
      if (description != null) 'description': description,
      if (date != null) 'date': date,
      if (isAutoImported != null) 'is_auto_imported': isAutoImported,
      if (emailMessageId != null) 'email_message_id': emailMessageId,
      if (integratedToBudget != null)
        'integrated_to_budget': integratedToBudget,
      if (budgetIntegrationType != null)
        'budget_integration_type': budgetIntegrationType,
      if (targetSemesterId != null) 'target_semester_id': targetSemesterId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TransactionsCompanion copyWith({
    Value<int>? id,
    Value<double>? amount,
    Value<String>? type,
    Value<int>? categoryId,
    Value<String>? description,
    Value<DateTime>? date,
    Value<bool>? isAutoImported,
    Value<String?>? emailMessageId,
    Value<bool?>? integratedToBudget,
    Value<String?>? budgetIntegrationType,
    Value<int?>? targetSemesterId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
      date: date ?? this.date,
      isAutoImported: isAutoImported ?? this.isAutoImported,
      emailMessageId: emailMessageId ?? this.emailMessageId,
      integratedToBudget: integratedToBudget ?? this.integratedToBudget,
      budgetIntegrationType:
          budgetIntegrationType ?? this.budgetIntegrationType,
      targetSemesterId: targetSemesterId ?? this.targetSemesterId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (isAutoImported.present) {
      map['is_auto_imported'] = Variable<bool>(isAutoImported.value);
    }
    if (emailMessageId.present) {
      map['email_message_id'] = Variable<String>(emailMessageId.value);
    }
    if (integratedToBudget.present) {
      map['integrated_to_budget'] = Variable<bool>(integratedToBudget.value);
    }
    if (budgetIntegrationType.present) {
      map['budget_integration_type'] = Variable<String>(
        budgetIntegrationType.value,
      );
    }
    if (targetSemesterId.present) {
      map['target_semester_id'] = Variable<int>(targetSemesterId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('categoryId: $categoryId, ')
          ..write('description: $description, ')
          ..write('date: $date, ')
          ..write('isAutoImported: $isAutoImported, ')
          ..write('emailMessageId: $emailMessageId, ')
          ..write('integratedToBudget: $integratedToBudget, ')
          ..write('budgetIntegrationType: $budgetIntegrationType, ')
          ..write('targetSemesterId: $targetSemesterId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTable extends Budgets with TableInfo<$BudgetsTable, Budget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, categoryId, amount, month, year];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Budget> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Budget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Budget(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}month'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
    );
  }

  @override
  $BudgetsTable createAlias(String alias) {
    return $BudgetsTable(attachedDatabase, alias);
  }
}

class Budget extends DataClass implements Insertable<Budget> {
  final int id;
  final int categoryId;
  final double amount;
  final int month;
  final int year;
  const Budget({
    required this.id,
    required this.categoryId,
    required this.amount,
    required this.month,
    required this.year,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category_id'] = Variable<int>(categoryId);
    map['amount'] = Variable<double>(amount);
    map['month'] = Variable<int>(month);
    map['year'] = Variable<int>(year);
    return map;
  }

  BudgetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetsCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      amount: Value(amount),
      month: Value(month),
      year: Value(year),
    );
  }

  factory Budget.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Budget(
      id: serializer.fromJson<int>(json['id']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      amount: serializer.fromJson<double>(json['amount']),
      month: serializer.fromJson<int>(json['month']),
      year: serializer.fromJson<int>(json['year']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoryId': serializer.toJson<int>(categoryId),
      'amount': serializer.toJson<double>(amount),
      'month': serializer.toJson<int>(month),
      'year': serializer.toJson<int>(year),
    };
  }

  Budget copyWith({
    int? id,
    int? categoryId,
    double? amount,
    int? month,
    int? year,
  }) => Budget(
    id: id ?? this.id,
    categoryId: categoryId ?? this.categoryId,
    amount: amount ?? this.amount,
    month: month ?? this.month,
    year: year ?? this.year,
  );
  Budget copyWithCompanion(BudgetsCompanion data) {
    return Budget(
      id: data.id.present ? data.id.value : this.id,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      amount: data.amount.present ? data.amount.value : this.amount,
      month: data.month.present ? data.month.value : this.month,
      year: data.year.present ? data.year.value : this.year,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Budget(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('amount: $amount, ')
          ..write('month: $month, ')
          ..write('year: $year')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, categoryId, amount, month, year);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Budget &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.amount == this.amount &&
          other.month == this.month &&
          other.year == this.year);
}

class BudgetsCompanion extends UpdateCompanion<Budget> {
  final Value<int> id;
  final Value<int> categoryId;
  final Value<double> amount;
  final Value<int> month;
  final Value<int> year;
  const BudgetsCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.amount = const Value.absent(),
    this.month = const Value.absent(),
    this.year = const Value.absent(),
  });
  BudgetsCompanion.insert({
    this.id = const Value.absent(),
    required int categoryId,
    required double amount,
    required int month,
    required int year,
  }) : categoryId = Value(categoryId),
       amount = Value(amount),
       month = Value(month),
       year = Value(year);
  static Insertable<Budget> custom({
    Expression<int>? id,
    Expression<int>? categoryId,
    Expression<double>? amount,
    Expression<int>? month,
    Expression<int>? year,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (amount != null) 'amount': amount,
      if (month != null) 'month': month,
      if (year != null) 'year': year,
    });
  }

  BudgetsCompanion copyWith({
    Value<int>? id,
    Value<int>? categoryId,
    Value<double>? amount,
    Value<int>? month,
    Value<int>? year,
  }) {
    return BudgetsCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('amount: $amount, ')
          ..write('month: $month, ')
          ..write('year: $year')
          ..write(')'))
        .toString();
  }
}

class $SemesterSettingsTable extends SemesterSettings
    with TableInfo<$SemesterSettingsTable, SemesterSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SemesterSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startMonthMeta = const VerificationMeta(
    'startMonth',
  );
  @override
  late final GeneratedColumn<int> startMonth = GeneratedColumn<int>(
    'start_month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startYearMeta = const VerificationMeta(
    'startYear',
  );
  @override
  late final GeneratedColumn<int> startYear = GeneratedColumn<int>(
    'start_year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMonthsMeta = const VerificationMeta(
    'durationMonths',
  );
  @override
  late final GeneratedColumn<int> durationMonths = GeneratedColumn<int>(
    'duration_months',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(6),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    totalAmount,
    startMonth,
    startYear,
    durationMonths,
    isActive,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'semester_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SemesterSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('start_month')) {
      context.handle(
        _startMonthMeta,
        startMonth.isAcceptableOrUnknown(data['start_month']!, _startMonthMeta),
      );
    } else if (isInserting) {
      context.missing(_startMonthMeta);
    }
    if (data.containsKey('start_year')) {
      context.handle(
        _startYearMeta,
        startYear.isAcceptableOrUnknown(data['start_year']!, _startYearMeta),
      );
    } else if (isInserting) {
      context.missing(_startYearMeta);
    }
    if (data.containsKey('duration_months')) {
      context.handle(
        _durationMonthsMeta,
        durationMonths.isAcceptableOrUnknown(
          data['duration_months']!,
          _durationMonthsMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SemesterSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SemesterSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_amount'],
      )!,
      startMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_month'],
      )!,
      startYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_year'],
      )!,
      durationMonths: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_months'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SemesterSettingsTable createAlias(String alias) {
    return $SemesterSettingsTable(attachedDatabase, alias);
  }
}

class SemesterSetting extends DataClass implements Insertable<SemesterSetting> {
  final int id;
  final double totalAmount;
  final int startMonth;
  final int startYear;
  final int durationMonths;
  final bool isActive;
  final DateTime createdAt;
  const SemesterSetting({
    required this.id,
    required this.totalAmount,
    required this.startMonth,
    required this.startYear,
    required this.durationMonths,
    required this.isActive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['total_amount'] = Variable<double>(totalAmount);
    map['start_month'] = Variable<int>(startMonth);
    map['start_year'] = Variable<int>(startYear);
    map['duration_months'] = Variable<int>(durationMonths);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SemesterSettingsCompanion toCompanion(bool nullToAbsent) {
    return SemesterSettingsCompanion(
      id: Value(id),
      totalAmount: Value(totalAmount),
      startMonth: Value(startMonth),
      startYear: Value(startYear),
      durationMonths: Value(durationMonths),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory SemesterSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SemesterSetting(
      id: serializer.fromJson<int>(json['id']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      startMonth: serializer.fromJson<int>(json['startMonth']),
      startYear: serializer.fromJson<int>(json['startYear']),
      durationMonths: serializer.fromJson<int>(json['durationMonths']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'startMonth': serializer.toJson<int>(startMonth),
      'startYear': serializer.toJson<int>(startYear),
      'durationMonths': serializer.toJson<int>(durationMonths),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SemesterSetting copyWith({
    int? id,
    double? totalAmount,
    int? startMonth,
    int? startYear,
    int? durationMonths,
    bool? isActive,
    DateTime? createdAt,
  }) => SemesterSetting(
    id: id ?? this.id,
    totalAmount: totalAmount ?? this.totalAmount,
    startMonth: startMonth ?? this.startMonth,
    startYear: startYear ?? this.startYear,
    durationMonths: durationMonths ?? this.durationMonths,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
  SemesterSetting copyWithCompanion(SemesterSettingsCompanion data) {
    return SemesterSetting(
      id: data.id.present ? data.id.value : this.id,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      startMonth: data.startMonth.present
          ? data.startMonth.value
          : this.startMonth,
      startYear: data.startYear.present ? data.startYear.value : this.startYear,
      durationMonths: data.durationMonths.present
          ? data.durationMonths.value
          : this.durationMonths,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SemesterSetting(')
          ..write('id: $id, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('startMonth: $startMonth, ')
          ..write('startYear: $startYear, ')
          ..write('durationMonths: $durationMonths, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    totalAmount,
    startMonth,
    startYear,
    durationMonths,
    isActive,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SemesterSetting &&
          other.id == this.id &&
          other.totalAmount == this.totalAmount &&
          other.startMonth == this.startMonth &&
          other.startYear == this.startYear &&
          other.durationMonths == this.durationMonths &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class SemesterSettingsCompanion extends UpdateCompanion<SemesterSetting> {
  final Value<int> id;
  final Value<double> totalAmount;
  final Value<int> startMonth;
  final Value<int> startYear;
  final Value<int> durationMonths;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  const SemesterSettingsCompanion({
    this.id = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.startMonth = const Value.absent(),
    this.startYear = const Value.absent(),
    this.durationMonths = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SemesterSettingsCompanion.insert({
    this.id = const Value.absent(),
    required double totalAmount,
    required int startMonth,
    required int startYear,
    this.durationMonths = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime createdAt,
  }) : totalAmount = Value(totalAmount),
       startMonth = Value(startMonth),
       startYear = Value(startYear),
       createdAt = Value(createdAt);
  static Insertable<SemesterSetting> custom({
    Expression<int>? id,
    Expression<double>? totalAmount,
    Expression<int>? startMonth,
    Expression<int>? startYear,
    Expression<int>? durationMonths,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (startMonth != null) 'start_month': startMonth,
      if (startYear != null) 'start_year': startYear,
      if (durationMonths != null) 'duration_months': durationMonths,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SemesterSettingsCompanion copyWith({
    Value<int>? id,
    Value<double>? totalAmount,
    Value<int>? startMonth,
    Value<int>? startYear,
    Value<int>? durationMonths,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
  }) {
    return SemesterSettingsCompanion(
      id: id ?? this.id,
      totalAmount: totalAmount ?? this.totalAmount,
      startMonth: startMonth ?? this.startMonth,
      startYear: startYear ?? this.startYear,
      durationMonths: durationMonths ?? this.durationMonths,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (startMonth.present) {
      map['start_month'] = Variable<int>(startMonth.value);
    }
    if (startYear.present) {
      map['start_year'] = Variable<int>(startYear.value);
    }
    if (durationMonths.present) {
      map['duration_months'] = Variable<int>(durationMonths.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SemesterSettingsCompanion(')
          ..write('id: $id, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('startMonth: $startMonth, ')
          ..write('startYear: $startYear, ')
          ..write('durationMonths: $durationMonths, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MonthlyAllocationsTable extends MonthlyAllocations
    with TableInfo<$MonthlyAllocationsTable, MonthlyAllocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MonthlyAllocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _semesterIdMeta = const VerificationMeta(
    'semesterId',
  );
  @override
  late final GeneratedColumn<int> semesterId = GeneratedColumn<int>(
    'semester_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES semester_settings (id)',
    ),
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthlyAmountMeta = const VerificationMeta(
    'monthlyAmount',
  );
  @override
  late final GeneratedColumn<double> monthlyAmount = GeneratedColumn<double>(
    'monthly_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalJatahJajanMeta = const VerificationMeta(
    'totalJatahJajan',
  );
  @override
  late final GeneratedColumn<double> totalJatahJajan = GeneratedColumn<double>(
    'total_jatah_jajan',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    semesterId,
    month,
    year,
    monthlyAmount,
    totalJatahJajan,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'monthly_allocations';
  @override
  VerificationContext validateIntegrity(
    Insertable<MonthlyAllocation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('semester_id')) {
      context.handle(
        _semesterIdMeta,
        semesterId.isAcceptableOrUnknown(data['semester_id']!, _semesterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_semesterIdMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('monthly_amount')) {
      context.handle(
        _monthlyAmountMeta,
        monthlyAmount.isAcceptableOrUnknown(
          data['monthly_amount']!,
          _monthlyAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_monthlyAmountMeta);
    }
    if (data.containsKey('total_jatah_jajan')) {
      context.handle(
        _totalJatahJajanMeta,
        totalJatahJajan.isAcceptableOrUnknown(
          data['total_jatah_jajan']!,
          _totalJatahJajanMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MonthlyAllocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MonthlyAllocation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      semesterId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}semester_id'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}month'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      monthlyAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monthly_amount'],
      )!,
      totalJatahJajan: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_jatah_jajan'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $MonthlyAllocationsTable createAlias(String alias) {
    return $MonthlyAllocationsTable(attachedDatabase, alias);
  }
}

class MonthlyAllocation extends DataClass
    implements Insertable<MonthlyAllocation> {
  final int id;
  final int semesterId;
  final int month;
  final int year;
  final double monthlyAmount;
  final double totalJatahJajan;
  final bool isActive;
  const MonthlyAllocation({
    required this.id,
    required this.semesterId,
    required this.month,
    required this.year,
    required this.monthlyAmount,
    required this.totalJatahJajan,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['semester_id'] = Variable<int>(semesterId);
    map['month'] = Variable<int>(month);
    map['year'] = Variable<int>(year);
    map['monthly_amount'] = Variable<double>(monthlyAmount);
    map['total_jatah_jajan'] = Variable<double>(totalJatahJajan);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  MonthlyAllocationsCompanion toCompanion(bool nullToAbsent) {
    return MonthlyAllocationsCompanion(
      id: Value(id),
      semesterId: Value(semesterId),
      month: Value(month),
      year: Value(year),
      monthlyAmount: Value(monthlyAmount),
      totalJatahJajan: Value(totalJatahJajan),
      isActive: Value(isActive),
    );
  }

  factory MonthlyAllocation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MonthlyAllocation(
      id: serializer.fromJson<int>(json['id']),
      semesterId: serializer.fromJson<int>(json['semesterId']),
      month: serializer.fromJson<int>(json['month']),
      year: serializer.fromJson<int>(json['year']),
      monthlyAmount: serializer.fromJson<double>(json['monthlyAmount']),
      totalJatahJajan: serializer.fromJson<double>(json['totalJatahJajan']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'semesterId': serializer.toJson<int>(semesterId),
      'month': serializer.toJson<int>(month),
      'year': serializer.toJson<int>(year),
      'monthlyAmount': serializer.toJson<double>(monthlyAmount),
      'totalJatahJajan': serializer.toJson<double>(totalJatahJajan),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  MonthlyAllocation copyWith({
    int? id,
    int? semesterId,
    int? month,
    int? year,
    double? monthlyAmount,
    double? totalJatahJajan,
    bool? isActive,
  }) => MonthlyAllocation(
    id: id ?? this.id,
    semesterId: semesterId ?? this.semesterId,
    month: month ?? this.month,
    year: year ?? this.year,
    monthlyAmount: monthlyAmount ?? this.monthlyAmount,
    totalJatahJajan: totalJatahJajan ?? this.totalJatahJajan,
    isActive: isActive ?? this.isActive,
  );
  MonthlyAllocation copyWithCompanion(MonthlyAllocationsCompanion data) {
    return MonthlyAllocation(
      id: data.id.present ? data.id.value : this.id,
      semesterId: data.semesterId.present
          ? data.semesterId.value
          : this.semesterId,
      month: data.month.present ? data.month.value : this.month,
      year: data.year.present ? data.year.value : this.year,
      monthlyAmount: data.monthlyAmount.present
          ? data.monthlyAmount.value
          : this.monthlyAmount,
      totalJatahJajan: data.totalJatahJajan.present
          ? data.totalJatahJajan.value
          : this.totalJatahJajan,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MonthlyAllocation(')
          ..write('id: $id, ')
          ..write('semesterId: $semesterId, ')
          ..write('month: $month, ')
          ..write('year: $year, ')
          ..write('monthlyAmount: $monthlyAmount, ')
          ..write('totalJatahJajan: $totalJatahJajan, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    semesterId,
    month,
    year,
    monthlyAmount,
    totalJatahJajan,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MonthlyAllocation &&
          other.id == this.id &&
          other.semesterId == this.semesterId &&
          other.month == this.month &&
          other.year == this.year &&
          other.monthlyAmount == this.monthlyAmount &&
          other.totalJatahJajan == this.totalJatahJajan &&
          other.isActive == this.isActive);
}

class MonthlyAllocationsCompanion extends UpdateCompanion<MonthlyAllocation> {
  final Value<int> id;
  final Value<int> semesterId;
  final Value<int> month;
  final Value<int> year;
  final Value<double> monthlyAmount;
  final Value<double> totalJatahJajan;
  final Value<bool> isActive;
  const MonthlyAllocationsCompanion({
    this.id = const Value.absent(),
    this.semesterId = const Value.absent(),
    this.month = const Value.absent(),
    this.year = const Value.absent(),
    this.monthlyAmount = const Value.absent(),
    this.totalJatahJajan = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  MonthlyAllocationsCompanion.insert({
    this.id = const Value.absent(),
    required int semesterId,
    required int month,
    required int year,
    required double monthlyAmount,
    this.totalJatahJajan = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : semesterId = Value(semesterId),
       month = Value(month),
       year = Value(year),
       monthlyAmount = Value(monthlyAmount);
  static Insertable<MonthlyAllocation> custom({
    Expression<int>? id,
    Expression<int>? semesterId,
    Expression<int>? month,
    Expression<int>? year,
    Expression<double>? monthlyAmount,
    Expression<double>? totalJatahJajan,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (semesterId != null) 'semester_id': semesterId,
      if (month != null) 'month': month,
      if (year != null) 'year': year,
      if (monthlyAmount != null) 'monthly_amount': monthlyAmount,
      if (totalJatahJajan != null) 'total_jatah_jajan': totalJatahJajan,
      if (isActive != null) 'is_active': isActive,
    });
  }

  MonthlyAllocationsCompanion copyWith({
    Value<int>? id,
    Value<int>? semesterId,
    Value<int>? month,
    Value<int>? year,
    Value<double>? monthlyAmount,
    Value<double>? totalJatahJajan,
    Value<bool>? isActive,
  }) {
    return MonthlyAllocationsCompanion(
      id: id ?? this.id,
      semesterId: semesterId ?? this.semesterId,
      month: month ?? this.month,
      year: year ?? this.year,
      monthlyAmount: monthlyAmount ?? this.monthlyAmount,
      totalJatahJajan: totalJatahJajan ?? this.totalJatahJajan,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (semesterId.present) {
      map['semester_id'] = Variable<int>(semesterId.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (monthlyAmount.present) {
      map['monthly_amount'] = Variable<double>(monthlyAmount.value);
    }
    if (totalJatahJajan.present) {
      map['total_jatah_jajan'] = Variable<double>(totalJatahJajan.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MonthlyAllocationsCompanion(')
          ..write('id: $id, ')
          ..write('semesterId: $semesterId, ')
          ..write('month: $month, ')
          ..write('year: $year, ')
          ..write('monthlyAmount: $monthlyAmount, ')
          ..write('totalJatahJajan: $totalJatahJajan, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $MonthlyNeedsTable extends MonthlyNeeds
    with TableInfo<$MonthlyNeedsTable, MonthlyNeed> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MonthlyNeedsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _allocationIdMeta = const VerificationMeta(
    'allocationId',
  );
  @override
  late final GeneratedColumn<int> allocationId = GeneratedColumn<int>(
    'allocation_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES monthly_allocations (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetedAmountMeta = const VerificationMeta(
    'budgetedAmount',
  );
  @override
  late final GeneratedColumn<double> budgetedAmount = GeneratedColumn<double>(
    'budgeted_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualAmountMeta = const VerificationMeta(
    'actualAmount',
  );
  @override
  late final GeneratedColumn<double> actualAmount = GeneratedColumn<double>(
    'actual_amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _completedDateMeta = const VerificationMeta(
    'completedDate',
  );
  @override
  late final GeneratedColumn<DateTime> completedDate =
      GeneratedColumn<DateTime>(
        'completed_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    allocationId,
    name,
    budgetedAmount,
    actualAmount,
    isCompleted,
    completedDate,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'monthly_needs';
  @override
  VerificationContext validateIntegrity(
    Insertable<MonthlyNeed> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('allocation_id')) {
      context.handle(
        _allocationIdMeta,
        allocationId.isAcceptableOrUnknown(
          data['allocation_id']!,
          _allocationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_allocationIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('budgeted_amount')) {
      context.handle(
        _budgetedAmountMeta,
        budgetedAmount.isAcceptableOrUnknown(
          data['budgeted_amount']!,
          _budgetedAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_budgetedAmountMeta);
    }
    if (data.containsKey('actual_amount')) {
      context.handle(
        _actualAmountMeta,
        actualAmount.isAcceptableOrUnknown(
          data['actual_amount']!,
          _actualAmountMeta,
        ),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('completed_date')) {
      context.handle(
        _completedDateMeta,
        completedDate.isAcceptableOrUnknown(
          data['completed_date']!,
          _completedDateMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MonthlyNeed map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MonthlyNeed(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      allocationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}allocation_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      budgetedAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}budgeted_amount'],
      )!,
      actualAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}actual_amount'],
      ),
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      completedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_date'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MonthlyNeedsTable createAlias(String alias) {
    return $MonthlyNeedsTable(attachedDatabase, alias);
  }
}

class MonthlyNeed extends DataClass implements Insertable<MonthlyNeed> {
  final int id;
  final int allocationId;
  final String name;
  final double budgetedAmount;
  final double? actualAmount;
  final bool isCompleted;
  final DateTime? completedDate;
  final DateTime createdAt;
  const MonthlyNeed({
    required this.id,
    required this.allocationId,
    required this.name,
    required this.budgetedAmount,
    this.actualAmount,
    required this.isCompleted,
    this.completedDate,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['allocation_id'] = Variable<int>(allocationId);
    map['name'] = Variable<String>(name);
    map['budgeted_amount'] = Variable<double>(budgetedAmount);
    if (!nullToAbsent || actualAmount != null) {
      map['actual_amount'] = Variable<double>(actualAmount);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || completedDate != null) {
      map['completed_date'] = Variable<DateTime>(completedDate);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MonthlyNeedsCompanion toCompanion(bool nullToAbsent) {
    return MonthlyNeedsCompanion(
      id: Value(id),
      allocationId: Value(allocationId),
      name: Value(name),
      budgetedAmount: Value(budgetedAmount),
      actualAmount: actualAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(actualAmount),
      isCompleted: Value(isCompleted),
      completedDate: completedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(completedDate),
      createdAt: Value(createdAt),
    );
  }

  factory MonthlyNeed.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MonthlyNeed(
      id: serializer.fromJson<int>(json['id']),
      allocationId: serializer.fromJson<int>(json['allocationId']),
      name: serializer.fromJson<String>(json['name']),
      budgetedAmount: serializer.fromJson<double>(json['budgetedAmount']),
      actualAmount: serializer.fromJson<double?>(json['actualAmount']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      completedDate: serializer.fromJson<DateTime?>(json['completedDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'allocationId': serializer.toJson<int>(allocationId),
      'name': serializer.toJson<String>(name),
      'budgetedAmount': serializer.toJson<double>(budgetedAmount),
      'actualAmount': serializer.toJson<double?>(actualAmount),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'completedDate': serializer.toJson<DateTime?>(completedDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MonthlyNeed copyWith({
    int? id,
    int? allocationId,
    String? name,
    double? budgetedAmount,
    Value<double?> actualAmount = const Value.absent(),
    bool? isCompleted,
    Value<DateTime?> completedDate = const Value.absent(),
    DateTime? createdAt,
  }) => MonthlyNeed(
    id: id ?? this.id,
    allocationId: allocationId ?? this.allocationId,
    name: name ?? this.name,
    budgetedAmount: budgetedAmount ?? this.budgetedAmount,
    actualAmount: actualAmount.present ? actualAmount.value : this.actualAmount,
    isCompleted: isCompleted ?? this.isCompleted,
    completedDate: completedDate.present
        ? completedDate.value
        : this.completedDate,
    createdAt: createdAt ?? this.createdAt,
  );
  MonthlyNeed copyWithCompanion(MonthlyNeedsCompanion data) {
    return MonthlyNeed(
      id: data.id.present ? data.id.value : this.id,
      allocationId: data.allocationId.present
          ? data.allocationId.value
          : this.allocationId,
      name: data.name.present ? data.name.value : this.name,
      budgetedAmount: data.budgetedAmount.present
          ? data.budgetedAmount.value
          : this.budgetedAmount,
      actualAmount: data.actualAmount.present
          ? data.actualAmount.value
          : this.actualAmount,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      completedDate: data.completedDate.present
          ? data.completedDate.value
          : this.completedDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MonthlyNeed(')
          ..write('id: $id, ')
          ..write('allocationId: $allocationId, ')
          ..write('name: $name, ')
          ..write('budgetedAmount: $budgetedAmount, ')
          ..write('actualAmount: $actualAmount, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedDate: $completedDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    allocationId,
    name,
    budgetedAmount,
    actualAmount,
    isCompleted,
    completedDate,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MonthlyNeed &&
          other.id == this.id &&
          other.allocationId == this.allocationId &&
          other.name == this.name &&
          other.budgetedAmount == this.budgetedAmount &&
          other.actualAmount == this.actualAmount &&
          other.isCompleted == this.isCompleted &&
          other.completedDate == this.completedDate &&
          other.createdAt == this.createdAt);
}

class MonthlyNeedsCompanion extends UpdateCompanion<MonthlyNeed> {
  final Value<int> id;
  final Value<int> allocationId;
  final Value<String> name;
  final Value<double> budgetedAmount;
  final Value<double?> actualAmount;
  final Value<bool> isCompleted;
  final Value<DateTime?> completedDate;
  final Value<DateTime> createdAt;
  const MonthlyNeedsCompanion({
    this.id = const Value.absent(),
    this.allocationId = const Value.absent(),
    this.name = const Value.absent(),
    this.budgetedAmount = const Value.absent(),
    this.actualAmount = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.completedDate = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MonthlyNeedsCompanion.insert({
    this.id = const Value.absent(),
    required int allocationId,
    required String name,
    required double budgetedAmount,
    this.actualAmount = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.completedDate = const Value.absent(),
    required DateTime createdAt,
  }) : allocationId = Value(allocationId),
       name = Value(name),
       budgetedAmount = Value(budgetedAmount),
       createdAt = Value(createdAt);
  static Insertable<MonthlyNeed> custom({
    Expression<int>? id,
    Expression<int>? allocationId,
    Expression<String>? name,
    Expression<double>? budgetedAmount,
    Expression<double>? actualAmount,
    Expression<bool>? isCompleted,
    Expression<DateTime>? completedDate,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (allocationId != null) 'allocation_id': allocationId,
      if (name != null) 'name': name,
      if (budgetedAmount != null) 'budgeted_amount': budgetedAmount,
      if (actualAmount != null) 'actual_amount': actualAmount,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (completedDate != null) 'completed_date': completedDate,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MonthlyNeedsCompanion copyWith({
    Value<int>? id,
    Value<int>? allocationId,
    Value<String>? name,
    Value<double>? budgetedAmount,
    Value<double?>? actualAmount,
    Value<bool>? isCompleted,
    Value<DateTime?>? completedDate,
    Value<DateTime>? createdAt,
  }) {
    return MonthlyNeedsCompanion(
      id: id ?? this.id,
      allocationId: allocationId ?? this.allocationId,
      name: name ?? this.name,
      budgetedAmount: budgetedAmount ?? this.budgetedAmount,
      actualAmount: actualAmount ?? this.actualAmount,
      isCompleted: isCompleted ?? this.isCompleted,
      completedDate: completedDate ?? this.completedDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (allocationId.present) {
      map['allocation_id'] = Variable<int>(allocationId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (budgetedAmount.present) {
      map['budgeted_amount'] = Variable<double>(budgetedAmount.value);
    }
    if (actualAmount.present) {
      map['actual_amount'] = Variable<double>(actualAmount.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (completedDate.present) {
      map['completed_date'] = Variable<DateTime>(completedDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MonthlyNeedsCompanion(')
          ..write('id: $id, ')
          ..write('allocationId: $allocationId, ')
          ..write('name: $name, ')
          ..write('budgetedAmount: $budgetedAmount, ')
          ..write('actualAmount: $actualAmount, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedDate: $completedDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $BudgetsTable budgets = $BudgetsTable(this);
  late final $SemesterSettingsTable semesterSettings = $SemesterSettingsTable(
    this,
  );
  late final $MonthlyAllocationsTable monthlyAllocations =
      $MonthlyAllocationsTable(this);
  late final $MonthlyNeedsTable monthlyNeeds = $MonthlyNeedsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categories,
    transactions,
    budgets,
    semesterSettings,
    monthlyAllocations,
    monthlyNeeds,
  ];
}

typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      required String name,
      required String icon,
      required int color,
      required String type,
      Value<bool> isDefault,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> icon,
      Value<int> color,
      Value<String> type,
      Value<bool> isDefault,
    });

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
  _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: 'categories__id__transactions__category_id',
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BudgetsTable, List<Budget>> _budgetsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.budgets,
    aliasName: 'categories__id__budgets__category_id',
  );

  $$BudgetsTableProcessedTableManager get budgetsRefs {
    final manager = $$BudgetsTableTableManager(
      $_db,
      $_db.budgets,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_budgetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> budgetsRefs(
    Expression<bool> Function($$BudgetsTableFilterComposer f) f,
  ) {
    final $$BudgetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgets,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetsTableFilterComposer(
            $db: $db,
            $table: $db.budgets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> budgetsRefs<T extends Object>(
    Expression<T> Function($$BudgetsTableAnnotationComposer a) f,
  ) {
    final $$BudgetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgets,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetsTableAnnotationComposer(
            $db: $db,
            $table: $db.budgets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, $$CategoriesTableReferences),
          Category,
          PrefetchHooks Function({bool transactionsRefs, bool budgetsRefs})
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                icon: icon,
                color: color,
                type: type,
                isDefault: isDefault,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String icon,
                required int color,
                required String type,
                Value<bool> isDefault = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                icon: icon,
                color: color,
                type: type,
                isDefault: isDefault,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({transactionsRefs = false, budgetsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (transactionsRefs) db.transactions,
                    if (budgetsRefs) db.budgets,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transactionsRefs)
                        await $_getPrefetchedData<
                          Category,
                          $CategoriesTable,
                          Transaction
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._transactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (budgetsRefs)
                        await $_getPrefetchedData<
                          Category,
                          $CategoriesTable,
                          Budget
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._budgetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).budgetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, $$CategoriesTableReferences),
      Category,
      PrefetchHooks Function({bool transactionsRefs, bool budgetsRefs})
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      required double amount,
      required String type,
      required int categoryId,
      required String description,
      required DateTime date,
      Value<bool> isAutoImported,
      Value<String?> emailMessageId,
      Value<bool?> integratedToBudget,
      Value<String?> budgetIntegrationType,
      Value<int?> targetSemesterId,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      Value<double> amount,
      Value<String> type,
      Value<int> categoryId,
      Value<String> description,
      Value<DateTime> date,
      Value<bool> isAutoImported,
      Value<String?> emailMessageId,
      Value<bool?> integratedToBudget,
      Value<String?> budgetIntegrationType,
      Value<int?> targetSemesterId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$TransactionsTableReferences
    extends BaseReferences<_$AppDatabase, $TransactionsTable, Transaction> {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('transactions__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAutoImported => $composableBuilder(
    column: $table.isAutoImported,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emailMessageId => $composableBuilder(
    column: $table.emailMessageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get integratedToBudget => $composableBuilder(
    column: $table.integratedToBudget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get budgetIntegrationType => $composableBuilder(
    column: $table.budgetIntegrationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetSemesterId => $composableBuilder(
    column: $table.targetSemesterId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAutoImported => $composableBuilder(
    column: $table.isAutoImported,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emailMessageId => $composableBuilder(
    column: $table.emailMessageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get integratedToBudget => $composableBuilder(
    column: $table.integratedToBudget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get budgetIntegrationType => $composableBuilder(
    column: $table.budgetIntegrationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetSemesterId => $composableBuilder(
    column: $table.targetSemesterId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<bool> get isAutoImported => $composableBuilder(
    column: $table.isAutoImported,
    builder: (column) => column,
  );

  GeneratedColumn<String> get emailMessageId => $composableBuilder(
    column: $table.emailMessageId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get integratedToBudget => $composableBuilder(
    column: $table.integratedToBudget,
    builder: (column) => column,
  );

  GeneratedColumn<String> get budgetIntegrationType => $composableBuilder(
    column: $table.budgetIntegrationType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetSemesterId => $composableBuilder(
    column: $table.targetSemesterId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          Transaction,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (Transaction, $$TransactionsTableReferences),
          Transaction,
          PrefetchHooks Function({bool categoryId})
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<bool> isAutoImported = const Value.absent(),
                Value<String?> emailMessageId = const Value.absent(),
                Value<bool?> integratedToBudget = const Value.absent(),
                Value<String?> budgetIntegrationType = const Value.absent(),
                Value<int?> targetSemesterId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                amount: amount,
                type: type,
                categoryId: categoryId,
                description: description,
                date: date,
                isAutoImported: isAutoImported,
                emailMessageId: emailMessageId,
                integratedToBudget: integratedToBudget,
                budgetIntegrationType: budgetIntegrationType,
                targetSemesterId: targetSemesterId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required double amount,
                required String type,
                required int categoryId,
                required String description,
                required DateTime date,
                Value<bool> isAutoImported = const Value.absent(),
                Value<String?> emailMessageId = const Value.absent(),
                Value<bool?> integratedToBudget = const Value.absent(),
                Value<String?> budgetIntegrationType = const Value.absent(),
                Value<int?> targetSemesterId = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => TransactionsCompanion.insert(
                id: id,
                amount: amount,
                type: type,
                categoryId: categoryId,
                description: description,
                date: date,
                isAutoImported: isAutoImported,
                emailMessageId: emailMessageId,
                integratedToBudget: integratedToBudget,
                budgetIntegrationType: budgetIntegrationType,
                targetSemesterId: targetSemesterId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TransactionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.categoryId,
                                referencedTable: $$TransactionsTableReferences
                                    ._categoryIdTable(db),
                                referencedColumn: $$TransactionsTableReferences
                                    ._categoryIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      Transaction,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (Transaction, $$TransactionsTableReferences),
      Transaction,
      PrefetchHooks Function({bool categoryId})
    >;
typedef $$BudgetsTableCreateCompanionBuilder =
    BudgetsCompanion Function({
      Value<int> id,
      required int categoryId,
      required double amount,
      required int month,
      required int year,
    });
typedef $$BudgetsTableUpdateCompanionBuilder =
    BudgetsCompanion Function({
      Value<int> id,
      Value<int> categoryId,
      Value<double> amount,
      Value<int> month,
      Value<int> year,
    });

final class $$BudgetsTableReferences
    extends BaseReferences<_$AppDatabase, $BudgetsTable, Budget> {
  $$BudgetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('budgets__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BudgetsTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetsTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetsTable,
          Budget,
          $$BudgetsTableFilterComposer,
          $$BudgetsTableOrderingComposer,
          $$BudgetsTableAnnotationComposer,
          $$BudgetsTableCreateCompanionBuilder,
          $$BudgetsTableUpdateCompanionBuilder,
          (Budget, $$BudgetsTableReferences),
          Budget,
          PrefetchHooks Function({bool categoryId})
        > {
  $$BudgetsTableTableManager(_$AppDatabase db, $BudgetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<int> month = const Value.absent(),
                Value<int> year = const Value.absent(),
              }) => BudgetsCompanion(
                id: id,
                categoryId: categoryId,
                amount: amount,
                month: month,
                year: year,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int categoryId,
                required double amount,
                required int month,
                required int year,
              }) => BudgetsCompanion.insert(
                id: id,
                categoryId: categoryId,
                amount: amount,
                month: month,
                year: year,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BudgetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.categoryId,
                                referencedTable: $$BudgetsTableReferences
                                    ._categoryIdTable(db),
                                referencedColumn: $$BudgetsTableReferences
                                    ._categoryIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BudgetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetsTable,
      Budget,
      $$BudgetsTableFilterComposer,
      $$BudgetsTableOrderingComposer,
      $$BudgetsTableAnnotationComposer,
      $$BudgetsTableCreateCompanionBuilder,
      $$BudgetsTableUpdateCompanionBuilder,
      (Budget, $$BudgetsTableReferences),
      Budget,
      PrefetchHooks Function({bool categoryId})
    >;
typedef $$SemesterSettingsTableCreateCompanionBuilder =
    SemesterSettingsCompanion Function({
      Value<int> id,
      required double totalAmount,
      required int startMonth,
      required int startYear,
      Value<int> durationMonths,
      Value<bool> isActive,
      required DateTime createdAt,
    });
typedef $$SemesterSettingsTableUpdateCompanionBuilder =
    SemesterSettingsCompanion Function({
      Value<int> id,
      Value<double> totalAmount,
      Value<int> startMonth,
      Value<int> startYear,
      Value<int> durationMonths,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });

final class $$SemesterSettingsTableReferences
    extends
        BaseReferences<_$AppDatabase, $SemesterSettingsTable, SemesterSetting> {
  $$SemesterSettingsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$MonthlyAllocationsTable, List<MonthlyAllocation>>
  _monthlyAllocationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.monthlyAllocations,
        aliasName: 'semester_settings__id__monthly_allocations__semester_id',
      );

  $$MonthlyAllocationsTableProcessedTableManager get monthlyAllocationsRefs {
    final manager = $$MonthlyAllocationsTableTableManager(
      $_db,
      $_db.monthlyAllocations,
    ).filter((f) => f.semesterId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _monthlyAllocationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SemesterSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SemesterSettingsTable> {
  $$SemesterSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMonth => $composableBuilder(
    column: $table.startMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startYear => $composableBuilder(
    column: $table.startYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMonths => $composableBuilder(
    column: $table.durationMonths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> monthlyAllocationsRefs(
    Expression<bool> Function($$MonthlyAllocationsTableFilterComposer f) f,
  ) {
    final $$MonthlyAllocationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.monthlyAllocations,
      getReferencedColumn: (t) => t.semesterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MonthlyAllocationsTableFilterComposer(
            $db: $db,
            $table: $db.monthlyAllocations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SemesterSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SemesterSettingsTable> {
  $$SemesterSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMonth => $composableBuilder(
    column: $table.startMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startYear => $composableBuilder(
    column: $table.startYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMonths => $composableBuilder(
    column: $table.durationMonths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SemesterSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SemesterSettingsTable> {
  $$SemesterSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startMonth => $composableBuilder(
    column: $table.startMonth,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startYear =>
      $composableBuilder(column: $table.startYear, builder: (column) => column);

  GeneratedColumn<int> get durationMonths => $composableBuilder(
    column: $table.durationMonths,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> monthlyAllocationsRefs<T extends Object>(
    Expression<T> Function($$MonthlyAllocationsTableAnnotationComposer a) f,
  ) {
    final $$MonthlyAllocationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.monthlyAllocations,
          getReferencedColumn: (t) => t.semesterId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MonthlyAllocationsTableAnnotationComposer(
                $db: $db,
                $table: $db.monthlyAllocations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$SemesterSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SemesterSettingsTable,
          SemesterSetting,
          $$SemesterSettingsTableFilterComposer,
          $$SemesterSettingsTableOrderingComposer,
          $$SemesterSettingsTableAnnotationComposer,
          $$SemesterSettingsTableCreateCompanionBuilder,
          $$SemesterSettingsTableUpdateCompanionBuilder,
          (SemesterSetting, $$SemesterSettingsTableReferences),
          SemesterSetting,
          PrefetchHooks Function({bool monthlyAllocationsRefs})
        > {
  $$SemesterSettingsTableTableManager(
    _$AppDatabase db,
    $SemesterSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SemesterSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SemesterSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SemesterSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<int> startMonth = const Value.absent(),
                Value<int> startYear = const Value.absent(),
                Value<int> durationMonths = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SemesterSettingsCompanion(
                id: id,
                totalAmount: totalAmount,
                startMonth: startMonth,
                startYear: startYear,
                durationMonths: durationMonths,
                isActive: isActive,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required double totalAmount,
                required int startMonth,
                required int startYear,
                Value<int> durationMonths = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                required DateTime createdAt,
              }) => SemesterSettingsCompanion.insert(
                id: id,
                totalAmount: totalAmount,
                startMonth: startMonth,
                startYear: startYear,
                durationMonths: durationMonths,
                isActive: isActive,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SemesterSettingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({monthlyAllocationsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (monthlyAllocationsRefs) db.monthlyAllocations,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (monthlyAllocationsRefs)
                    await $_getPrefetchedData<
                      SemesterSetting,
                      $SemesterSettingsTable,
                      MonthlyAllocation
                    >(
                      currentTable: table,
                      referencedTable: $$SemesterSettingsTableReferences
                          ._monthlyAllocationsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SemesterSettingsTableReferences(
                            db,
                            table,
                            p0,
                          ).monthlyAllocationsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.semesterId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SemesterSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SemesterSettingsTable,
      SemesterSetting,
      $$SemesterSettingsTableFilterComposer,
      $$SemesterSettingsTableOrderingComposer,
      $$SemesterSettingsTableAnnotationComposer,
      $$SemesterSettingsTableCreateCompanionBuilder,
      $$SemesterSettingsTableUpdateCompanionBuilder,
      (SemesterSetting, $$SemesterSettingsTableReferences),
      SemesterSetting,
      PrefetchHooks Function({bool monthlyAllocationsRefs})
    >;
typedef $$MonthlyAllocationsTableCreateCompanionBuilder =
    MonthlyAllocationsCompanion Function({
      Value<int> id,
      required int semesterId,
      required int month,
      required int year,
      required double monthlyAmount,
      Value<double> totalJatahJajan,
      Value<bool> isActive,
    });
typedef $$MonthlyAllocationsTableUpdateCompanionBuilder =
    MonthlyAllocationsCompanion Function({
      Value<int> id,
      Value<int> semesterId,
      Value<int> month,
      Value<int> year,
      Value<double> monthlyAmount,
      Value<double> totalJatahJajan,
      Value<bool> isActive,
    });

final class $$MonthlyAllocationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MonthlyAllocationsTable,
          MonthlyAllocation
        > {
  $$MonthlyAllocationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SemesterSettingsTable _semesterIdTable(_$AppDatabase db) => db
      .semesterSettings
      .createAlias('monthly_allocations__semester_id__semester_settings__id');

  $$SemesterSettingsTableProcessedTableManager get semesterId {
    final $_column = $_itemColumn<int>('semester_id')!;

    final manager = $$SemesterSettingsTableTableManager(
      $_db,
      $_db.semesterSettings,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_semesterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MonthlyNeedsTable, List<MonthlyNeed>>
  _monthlyNeedsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.monthlyNeeds,
    aliasName: 'monthly_allocations__id__monthly_needs__allocation_id',
  );

  $$MonthlyNeedsTableProcessedTableManager get monthlyNeedsRefs {
    final manager = $$MonthlyNeedsTableTableManager(
      $_db,
      $_db.monthlyNeeds,
    ).filter((f) => f.allocationId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_monthlyNeedsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MonthlyAllocationsTableFilterComposer
    extends Composer<_$AppDatabase, $MonthlyAllocationsTable> {
  $$MonthlyAllocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get monthlyAmount => $composableBuilder(
    column: $table.monthlyAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalJatahJajan => $composableBuilder(
    column: $table.totalJatahJajan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  $$SemesterSettingsTableFilterComposer get semesterId {
    final $$SemesterSettingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.semesterId,
      referencedTable: $db.semesterSettings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SemesterSettingsTableFilterComposer(
            $db: $db,
            $table: $db.semesterSettings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> monthlyNeedsRefs(
    Expression<bool> Function($$MonthlyNeedsTableFilterComposer f) f,
  ) {
    final $$MonthlyNeedsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.monthlyNeeds,
      getReferencedColumn: (t) => t.allocationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MonthlyNeedsTableFilterComposer(
            $db: $db,
            $table: $db.monthlyNeeds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MonthlyAllocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $MonthlyAllocationsTable> {
  $$MonthlyAllocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get monthlyAmount => $composableBuilder(
    column: $table.monthlyAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalJatahJajan => $composableBuilder(
    column: $table.totalJatahJajan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  $$SemesterSettingsTableOrderingComposer get semesterId {
    final $$SemesterSettingsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.semesterId,
      referencedTable: $db.semesterSettings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SemesterSettingsTableOrderingComposer(
            $db: $db,
            $table: $db.semesterSettings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MonthlyAllocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MonthlyAllocationsTable> {
  $$MonthlyAllocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<double> get monthlyAmount => $composableBuilder(
    column: $table.monthlyAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalJatahJajan => $composableBuilder(
    column: $table.totalJatahJajan,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$SemesterSettingsTableAnnotationComposer get semesterId {
    final $$SemesterSettingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.semesterId,
      referencedTable: $db.semesterSettings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SemesterSettingsTableAnnotationComposer(
            $db: $db,
            $table: $db.semesterSettings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> monthlyNeedsRefs<T extends Object>(
    Expression<T> Function($$MonthlyNeedsTableAnnotationComposer a) f,
  ) {
    final $$MonthlyNeedsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.monthlyNeeds,
      getReferencedColumn: (t) => t.allocationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MonthlyNeedsTableAnnotationComposer(
            $db: $db,
            $table: $db.monthlyNeeds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MonthlyAllocationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MonthlyAllocationsTable,
          MonthlyAllocation,
          $$MonthlyAllocationsTableFilterComposer,
          $$MonthlyAllocationsTableOrderingComposer,
          $$MonthlyAllocationsTableAnnotationComposer,
          $$MonthlyAllocationsTableCreateCompanionBuilder,
          $$MonthlyAllocationsTableUpdateCompanionBuilder,
          (MonthlyAllocation, $$MonthlyAllocationsTableReferences),
          MonthlyAllocation,
          PrefetchHooks Function({bool semesterId, bool monthlyNeedsRefs})
        > {
  $$MonthlyAllocationsTableTableManager(
    _$AppDatabase db,
    $MonthlyAllocationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MonthlyAllocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MonthlyAllocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MonthlyAllocationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> semesterId = const Value.absent(),
                Value<int> month = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<double> monthlyAmount = const Value.absent(),
                Value<double> totalJatahJajan = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => MonthlyAllocationsCompanion(
                id: id,
                semesterId: semesterId,
                month: month,
                year: year,
                monthlyAmount: monthlyAmount,
                totalJatahJajan: totalJatahJajan,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int semesterId,
                required int month,
                required int year,
                required double monthlyAmount,
                Value<double> totalJatahJajan = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => MonthlyAllocationsCompanion.insert(
                id: id,
                semesterId: semesterId,
                month: month,
                year: year,
                monthlyAmount: monthlyAmount,
                totalJatahJajan: totalJatahJajan,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MonthlyAllocationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({semesterId = false, monthlyNeedsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (monthlyNeedsRefs) db.monthlyNeeds,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (semesterId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.semesterId,
                                    referencedTable:
                                        $$MonthlyAllocationsTableReferences
                                            ._semesterIdTable(db),
                                    referencedColumn:
                                        $$MonthlyAllocationsTableReferences
                                            ._semesterIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (monthlyNeedsRefs)
                        await $_getPrefetchedData<
                          MonthlyAllocation,
                          $MonthlyAllocationsTable,
                          MonthlyNeed
                        >(
                          currentTable: table,
                          referencedTable: $$MonthlyAllocationsTableReferences
                              ._monthlyNeedsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MonthlyAllocationsTableReferences(
                                db,
                                table,
                                p0,
                              ).monthlyNeedsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.allocationId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MonthlyAllocationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MonthlyAllocationsTable,
      MonthlyAllocation,
      $$MonthlyAllocationsTableFilterComposer,
      $$MonthlyAllocationsTableOrderingComposer,
      $$MonthlyAllocationsTableAnnotationComposer,
      $$MonthlyAllocationsTableCreateCompanionBuilder,
      $$MonthlyAllocationsTableUpdateCompanionBuilder,
      (MonthlyAllocation, $$MonthlyAllocationsTableReferences),
      MonthlyAllocation,
      PrefetchHooks Function({bool semesterId, bool monthlyNeedsRefs})
    >;
typedef $$MonthlyNeedsTableCreateCompanionBuilder =
    MonthlyNeedsCompanion Function({
      Value<int> id,
      required int allocationId,
      required String name,
      required double budgetedAmount,
      Value<double?> actualAmount,
      Value<bool> isCompleted,
      Value<DateTime?> completedDate,
      required DateTime createdAt,
    });
typedef $$MonthlyNeedsTableUpdateCompanionBuilder =
    MonthlyNeedsCompanion Function({
      Value<int> id,
      Value<int> allocationId,
      Value<String> name,
      Value<double> budgetedAmount,
      Value<double?> actualAmount,
      Value<bool> isCompleted,
      Value<DateTime?> completedDate,
      Value<DateTime> createdAt,
    });

final class $$MonthlyNeedsTableReferences
    extends BaseReferences<_$AppDatabase, $MonthlyNeedsTable, MonthlyNeed> {
  $$MonthlyNeedsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MonthlyAllocationsTable _allocationIdTable(_$AppDatabase db) => db
      .monthlyAllocations
      .createAlias('monthly_needs__allocation_id__monthly_allocations__id');

  $$MonthlyAllocationsTableProcessedTableManager get allocationId {
    final $_column = $_itemColumn<int>('allocation_id')!;

    final manager = $$MonthlyAllocationsTableTableManager(
      $_db,
      $_db.monthlyAllocations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_allocationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MonthlyNeedsTableFilterComposer
    extends Composer<_$AppDatabase, $MonthlyNeedsTable> {
  $$MonthlyNeedsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get budgetedAmount => $composableBuilder(
    column: $table.budgetedAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get actualAmount => $composableBuilder(
    column: $table.actualAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedDate => $composableBuilder(
    column: $table.completedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MonthlyAllocationsTableFilterComposer get allocationId {
    final $$MonthlyAllocationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.allocationId,
      referencedTable: $db.monthlyAllocations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MonthlyAllocationsTableFilterComposer(
            $db: $db,
            $table: $db.monthlyAllocations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MonthlyNeedsTableOrderingComposer
    extends Composer<_$AppDatabase, $MonthlyNeedsTable> {
  $$MonthlyNeedsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get budgetedAmount => $composableBuilder(
    column: $table.budgetedAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get actualAmount => $composableBuilder(
    column: $table.actualAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedDate => $composableBuilder(
    column: $table.completedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MonthlyAllocationsTableOrderingComposer get allocationId {
    final $$MonthlyAllocationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.allocationId,
      referencedTable: $db.monthlyAllocations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MonthlyAllocationsTableOrderingComposer(
            $db: $db,
            $table: $db.monthlyAllocations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MonthlyNeedsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MonthlyNeedsTable> {
  $$MonthlyNeedsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get budgetedAmount => $composableBuilder(
    column: $table.budgetedAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get actualAmount => $composableBuilder(
    column: $table.actualAmount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedDate => $composableBuilder(
    column: $table.completedDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MonthlyAllocationsTableAnnotationComposer get allocationId {
    final $$MonthlyAllocationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.allocationId,
          referencedTable: $db.monthlyAllocations,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MonthlyAllocationsTableAnnotationComposer(
                $db: $db,
                $table: $db.monthlyAllocations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$MonthlyNeedsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MonthlyNeedsTable,
          MonthlyNeed,
          $$MonthlyNeedsTableFilterComposer,
          $$MonthlyNeedsTableOrderingComposer,
          $$MonthlyNeedsTableAnnotationComposer,
          $$MonthlyNeedsTableCreateCompanionBuilder,
          $$MonthlyNeedsTableUpdateCompanionBuilder,
          (MonthlyNeed, $$MonthlyNeedsTableReferences),
          MonthlyNeed,
          PrefetchHooks Function({bool allocationId})
        > {
  $$MonthlyNeedsTableTableManager(_$AppDatabase db, $MonthlyNeedsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MonthlyNeedsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MonthlyNeedsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MonthlyNeedsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> allocationId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> budgetedAmount = const Value.absent(),
                Value<double?> actualAmount = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime?> completedDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MonthlyNeedsCompanion(
                id: id,
                allocationId: allocationId,
                name: name,
                budgetedAmount: budgetedAmount,
                actualAmount: actualAmount,
                isCompleted: isCompleted,
                completedDate: completedDate,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int allocationId,
                required String name,
                required double budgetedAmount,
                Value<double?> actualAmount = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime?> completedDate = const Value.absent(),
                required DateTime createdAt,
              }) => MonthlyNeedsCompanion.insert(
                id: id,
                allocationId: allocationId,
                name: name,
                budgetedAmount: budgetedAmount,
                actualAmount: actualAmount,
                isCompleted: isCompleted,
                completedDate: completedDate,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MonthlyNeedsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({allocationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (allocationId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.allocationId,
                                referencedTable: $$MonthlyNeedsTableReferences
                                    ._allocationIdTable(db),
                                referencedColumn: $$MonthlyNeedsTableReferences
                                    ._allocationIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MonthlyNeedsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MonthlyNeedsTable,
      MonthlyNeed,
      $$MonthlyNeedsTableFilterComposer,
      $$MonthlyNeedsTableOrderingComposer,
      $$MonthlyNeedsTableAnnotationComposer,
      $$MonthlyNeedsTableCreateCompanionBuilder,
      $$MonthlyNeedsTableUpdateCompanionBuilder,
      (MonthlyNeed, $$MonthlyNeedsTableReferences),
      MonthlyNeed,
      PrefetchHooks Function({bool allocationId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db, _db.budgets);
  $$SemesterSettingsTableTableManager get semesterSettings =>
      $$SemesterSettingsTableTableManager(_db, _db.semesterSettings);
  $$MonthlyAllocationsTableTableManager get monthlyAllocations =>
      $$MonthlyAllocationsTableTableManager(_db, _db.monthlyAllocations);
  $$MonthlyNeedsTableTableManager get monthlyNeeds =>
      $$MonthlyNeedsTableTableManager(_db, _db.monthlyNeeds);
}
