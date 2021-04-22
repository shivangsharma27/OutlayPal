import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/global.dart' as globals;


class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;
  String _category;
  String _selectedCategory = '';

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty ||
        enteredAmount <= 0 ||
        _selectedDate == null ||
        _category == null) {
      return;
    }

    widget.addTx(
      enteredTitle,
      enteredAmount,
      _selectedDate,
      _category,
    );

    Navigator.of(context).pop();
  }

  final List<Map<String, Object>> icons = [
    {
      'Icon': Icon(
        Icons.restaurant,
        color: Colors.orange[800],
      ),
      'name': 'Food'
    },
    {'Icon': Icon(Icons.train, color: Colors.pink[300]), 'name': 'Transport'},
    {
      'Icon': Icon(
        Icons.healing,
        color: Colors.orange[200],
      ),
      'name': 'Health'
    },
    {
      'Icon': Icon(
        Icons.local_gas_station,
        color: Colors.yellow[800],
      ),
      'name': 'Fuel'
    },
    {
      'Icon': Icon(
        Icons.list_alt,
        color: Colors.lightGreen,
      ),
      'name': 'Bills'
    },
    {
      'Icon': Icon(
        Icons.attractions,
        color: Colors.limeAccent[400],
      ),
      'name': 'Entertainment'
    },
    {
      'Icon': Icon(Icons.dry_cleaning, color: Colors.blue[400]),
      'name': 'Fashion'
    },
    {
      'Icon': Icon(
        Icons.local_grocery_store,
        color: Colors.red,
      ),
      'name': 'Groceries'
    },
    {
      'Icon': Icon(
        Icons.add_circle,
      ),
      'name': 'Others'
    },
  ];

  void _presentDatePicker() {
    showDatePicker(
      initialEntryMode: DatePickerEntryMode.input,
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
    print('...');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OutlayPlanner'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: globals.themeColor[200],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 6,
                            offset: Offset(1, 7), // changes position of shadow
                          )
                        ]),
                    width: MediaQuery.of(context).size.width - 20,
                    child: TextField(
                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        hintText: 'Title',
                      ),
                      controller: _titleController,
                      onSubmitted: (_) => _submitData(),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: globals.themeColor[200],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 6,
                            offset: Offset(1, 7), // changes position of shadow
                          )
                        ]),
                    width: MediaQuery.of(context).size.width - 20,
                    child: TextField(
                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration(hintText: 'Amount'),
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      onSubmitted: (_) => _submitData(),
                      // onChanged: (val) => amountInput = val,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    //decoration: BoxDecoration(),
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      'Category$_selectedCategory',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: globals.themeColor[200],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 6,
                              offset:
                                  Offset(1, 7), // changes position of shadow
                            )
                          ]),
                      width: MediaQuery.of(context).size.width - 20,
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      height: MediaQuery.of(context).size.height / 2.7,
                      child: GridView.count(
                        crossAxisCount: 4,
                        children: List.generate(9, (index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: globals.themeColor[900]),
                                child: IconButton(
                                    color: globals.themeColor[200],
                                    highlightColor: Colors.limeAccent,
                                    onPressed: () {
                                      setState(() {
                                        _selectedCategory =
                                            ' : ' + icons[index]['name'];
                                      });
                                      _category = icons[index]['name'];
                                    },
                                    icon: icons[index]['Icon']),
                              ),
                              Text(icons[index]['name']),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    // height: 70,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            _selectedDate == null
                                ? 'No Date Chosen!'
                                : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                            child: Text(
                              'Choose Date',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                                // backgroundColor: Colors.blue,
                              ),
                            ),
                            onPressed: _presentDatePicker,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: Text(
                      'Add Transaction',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).textTheme.button.color,
                      ),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius:BorderRadius.circular(10))),
                      padding: MaterialStateProperty.all(EdgeInsets.all(13)),
                      elevation: MaterialStateProperty.all(10),
                      backgroundColor:
                          MaterialStateProperty.all(globals.themeColor[900]),
                    ),
                    onPressed: _submitData,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
