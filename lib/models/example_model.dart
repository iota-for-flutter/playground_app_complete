import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ExampleModel {
  ExampleModel({
    required this.id,
    required this.title,
    required this.library,
    required this.category,
    required this.level,
    required this.description,
    required this.shortDescription,
    required this.getExample,
    // Currently not used:
    required this.additionalTextField,
    required this.arrayOfDoubles,
  });

  final int id;
  final String title;
  final String library;
  final Category category;
  final String level;
  final String description;
  final String shortDescription;
  final Function getExample;
  // Currently not used:
  final String additionalTextField;
  final List<double> arrayOfDoubles;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExampleModel &&
        other.id == id &&
        other.title == title &&
        other.library == library &&
        other.level == level &&
        other.description == description &&
        other.shortDescription == shortDescription &&
        other.category == category &&
        listEquals(other.arrayOfDoubles, arrayOfDoubles) &&
        other.additionalTextField == additionalTextField;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        id.hashCode ^
        library.hashCode ^
        level.hashCode ^
        description.hashCode ^
        shortDescription.hashCode ^
        category.hashCode ^
        arrayOfDoubles.hashCode ^
        additionalTextField.hashCode;
  }
}

/// Categories: Basics, Identity, Wallet, Tokens, Smart Contracts
class Category {
  Category({
    required this.name,
    required this.iconPath,
    required this.icon,
    this.backgroundColor,
  });

  final String name;
  final String iconPath;
  final IconData icon;
  final Color? backgroundColor;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Category &&
        other.name == name &&
        other.iconPath == iconPath &&
        other.icon == icon;
  }

  @override
  int get hashCode => name.hashCode ^ iconPath.hashCode ^ icon.hashCode;
}
