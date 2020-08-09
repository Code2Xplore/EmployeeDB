import 'package:flutter/material.dart';
import 'Employee.dart';
import 'DBHelper.dart';

void main() => runApp(MaterialApp(
      home: HomeScreen(),
    ));

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DBHelper dbHelper = new DBHelper();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _locationController = TextEditingController();

  Employee employee;

  List<Employee> empList;
  int updateIndex;

  void initState() {
    super.initState();
    refreshList();
  }

  refreshList() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Records'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () {
                openDialogueBox(context);
              },
              child: Icon(
                Icons.add,
                size: 27.0,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: dbHelper.getEmployeeList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            empList = snapshot.data;
            return ListView.builder(
                shrinkWrap: true,
                itemCount: empList == null ? 0 : empList.length,
                itemBuilder: (BuildContext context, int index) {
                  Employee emp = empList[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: width * 0.6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Name : ${emp.name}',
                                  style: TextStyle(fontSize: 15),
                                ),
                                Text(
                                  'Location : ${emp.location}',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              openDialogueBox(context);
                              employee = emp;
                              updateIndex = index;
                            },
                            icon: Icon(Icons.edit, color: Colors.blueAccent),
                          ),
                          IconButton(
                            onPressed: () {
                              dbHelper.deleteEmployee(emp.id); 
                              setState(() {
                                empList.removeAt(index);
                              });
                            },
                            icon: Icon(Icons.delete_sweep,
                                color: Colors.redAccent),
                          )
                        ],
                      ),
                    ),
                  );
                });
          }
          return new CircularProgressIndicator();
        },
      ),
    );
  }

  openDialogueBox(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Employee Details'),
            content: Container(
              height: 150,
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(hintText: 'Name'),
                  ),
                  TextField(
                    controller: _locationController,
                    decoration: InputDecoration(hintText: 'Location'),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  submitAction(context);
                  refreshList();
                  Navigator.pop(context);
                },
                child: Text('Submit'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              )
            ],
          );
        });
  }

  submitAction(BuildContext context) {
    if (employee == null) {
      Employee st = new Employee(
          name: _nameController.text, location: _locationController.text);
      dbHelper.insertEmployee(st).then((value) => {
            _nameController.clear(),
            _locationController.clear(),
            print("Employee record added to db $value")
          });
    } else {
      employee.name = _nameController.text;
      employee.location = _locationController.text;

      dbHelper.updateEmployee(employee).then((value) => {
            _nameController.clear(),
            _locationController.clear(),
            setState(() {
              empList[updateIndex].name = _nameController.text;
              empList[updateIndex].location = _locationController.text;
            }),
            employee = null
          });
    }
  }
}
