import 'package:hive_flutter/hive_flutter.dart';

class Database {
  List expense = [];

  final _localBox = Hive.box('localBox');

  void createInitialData() {
    expense = [
      {
        'name': 'Rent',
        'price': 1470000,
        'category': 'Survival',
        'date': DateTime.now(),
      },
      {
        'name': 'Food',
        'price': 100000,
        'category': 'Survival',
        'date': DateTime.now(),
      },
      {
        'name': 'Bensin',
        'price': 100000,
        'category': 'Survival',
        'date': DateTime.now(),
      },
      {
        'name': 'Movie Tickets',
        'price': 45000,
        'category': 'Culture',
        'date': DateTime.now(),
      }
    ];
  }

  void loadData() {
    expense = _localBox.get('expense');
  }

  void updateDatabase() {
    _localBox.put('expense', expense);
  }
}
