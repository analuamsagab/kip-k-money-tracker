import 'package:flutter/material.dart';

IconData getCategoryIcon(String iconName) {
  switch (iconName) {
    case 'restaurant': return Icons.restaurant;
    case 'directions_car': return Icons.directions_car;
    case 'shopping_cart': return Icons.shopping_cart;
    case 'receipt_long': return Icons.receipt_long;
    case 'movie': return Icons.movie;
    case 'local_hospital': return Icons.local_hospital;
    case 'school': return Icons.school;
    case 'home': return Icons.home;
    case 'work': return Icons.work;
    case 'card_giftcard': return Icons.card_giftcard;
    case 'laptop': return Icons.laptop;
    case 'more_horiz': return Icons.more_horiz;
    default: return Icons.category;
  }
}
