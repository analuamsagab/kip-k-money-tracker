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
    case 'sports_esports': return Icons.sports_esports;
    case 'fitness_center': return Icons.fitness_center;
    case 'pets': return Icons.pets;
    case 'flight': return Icons.flight;
    case 'phone': return Icons.phone;
    case 'shopping_bag': return Icons.shopping_bag;
    case 'favorite': return Icons.favorite;
    case 'coffee': return Icons.coffee;
    case 'book': return Icons.book;
    case 'music_note': return Icons.music_note;
    case 'lightbulb': return Icons.lightbulb;
    case 'attach_money': return Icons.attach_money;
    case 'wallet': return Icons.wallet;
    case 'bolt': return Icons.bolt;
    default: return Icons.category;
  }
}

const List<String> categoryIconNames = [
  'restaurant', 'directions_car', 'shopping_cart', 'receipt_long', 'movie',
  'local_hospital', 'school', 'home', 'work', 'card_giftcard', 'laptop',
  'more_horiz', 'sports_esports', 'fitness_center', 'pets', 'flight',
  'phone', 'shopping_bag', 'favorite', 'coffee', 'book', 'music_note',
  'lightbulb', 'attach_money', 'wallet', 'bolt',
];

const List<int> categoryColorOptions = [
  0xFFE53935, 0xFFD81B60, 0xFF8E24AA, 0xFF5E35B1, 0xFF3949AB,
  0xFF1E88E5, 0xFF00ACC1, 0xFF00897B, 0xFF43A047, 0xFF7CB342,
  0xFFFB8C00, 0xFFF4511E, 0xFF6D4C41, 0xFF546E7A,
];
