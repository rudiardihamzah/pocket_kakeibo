import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocket_kakeibo/components/dialog_modal.dart';
import 'package:pocket_kakeibo/components/expense_card.dart';
import 'package:pocket_kakeibo/data/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _localBox = Hive.box('localBox');
  Database db = Database();
  int _selectedIndex = 0;

  @override
  void initState() {
    _localBox.clear();
    if (_localBox.get('expense') == null) {
      db.createInitialData();
    } else {
      db.loadData();
      print(db.expense);
    }
    super.initState();
  }

  final _controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  void editExpense(int index) {
    showDialog(
      context: context,
      builder: (context) {
        _controllers[0].text = db.expense[index]['name'];
        _controllers[1].text = db.expense[index]['price'];
        _controllers[2].text = db.expense[index]['category'];
        _controllers[3].text = db.expense[index]['date'];
        return DialogModal(
          controllers: _controllers,
          onSave: () {
            db.expense[index]['name'] = _controllers[0].text;
            db.expense[index]['price'] = _controllers[1].text;
            db.expense[index]['category'] = _controllers[2].text;
            db.expense[index]['date'] = _controllers[3].text;
            db.updateDatabase();
            Navigator.pop(context);
            setState(() {});
          },
          onCancel: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void createNewExpense() {
    _controllers[0].text = '';
    _controllers[1].text = '';
    _controllers[2].text = '';
    _controllers[3].text = '';
    showDialog(
        context: context,
        builder: (context) {
          return DialogModal(
            controllers: _controllers,
            onSave: saveNewExpense,
            onCancel: () => Navigator.of(context).pop(),
          );
        });
    db.updateDatabase();
  }

  void deleteExpense(int index) {
    setState(() {
      db.expense.removeAt(index);
    });
    db.updateDatabase();
  }

  void saveNewExpense() {
    setState(() {
      db.expense.add({
        "name": _controllers[0].text,
        "price": int.parse(_controllers[1].text),
        "category":
            _controllers[2].text.isEmpty ? "Survival" : _controllers[2].text,
        "date": _controllers[3].text.isEmpty
            ? DateTime.now()
            : DateTime.parse(_controllers[3].text)
      });
      Navigator.of(context).pop();
    });
    db.updateDatabase();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orange[200],
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Pocket Kakeibo',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          elevation: 0,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewExpense,
          child: Icon(Icons.add),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on),
              label: 'Income',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Report',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
        body: ListView.builder(
          padding: EdgeInsets.only(bottom: 100),
          itemCount: db.expense.length,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Expanded(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Image.asset(
                          'assets/cat.png',
                          width: 300,
                        ),
                        Text(
                          'Good Morning!',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.orange,
                            fontSize: 30.0,
                          ),
                        ),
                        SizedBox(height: 24),
                      ],
                    ),
                    ExpenseCard(
                      name: db.expense[index]['name'],
                      price: db.expense[index]['price'],
                      category: db.expense[index]['category'],
                      date: db.expense[index]['date'],
                      onDelete: (context) => deleteExpense(index),
                      onEdit: (context) => editExpense(index),
                    ),
                  ],
                ),
              );
            } else {
              return ExpenseCard(
                name: db.expense[index]['name'],
                price: db.expense[index]['price'],
                category: db.expense[index]['category'],
                date: db.expense[index]['date'],
                onDelete: (context) => deleteExpense(index),
                onEdit: (context) => editExpense(index),
              );
            }
          },
        ));
  }
}
