import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animalbook/widgets/provider_widet.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController value1 = new TextEditingController();
  TextEditingController value2 = new TextEditingController();
  TextEditingController value3 = new TextEditingController();
  TextEditingController value4 = new TextEditingController();
  String selectedUser;
  String selectTime;
  String selectType;
  String formattedDate1;

  @override
  Widget build(BuildContext context) {
    var now = new DateTime.now();
    var date = new DateFormat('yyyy-MM-dd');

    formattedDate1 = date.format(now);
    print(formattedDate1);

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Veterinarian Booking'),
        ),
        backgroundColor: Colors.red,
      ),
      body: Container(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.all(32),
                  child: Form(
                    child: Column(children: [
                      new DropdownButton<String>(
                          hint: Text('Select Doctor'),
                          dropdownColor: Colors.grey,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 36,
                          isExpanded: true,
                          items: <String>[
                            'Dr.Dimithra',
                            'Dr.Dimithra 2',
                            'Dr.Dimithra 3',
                            'Dr.Dimithra 4'
                          ].map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(
                                value,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                            );
                          }).toList(),
                          value: selectedUser,
                          onChanged: (newValue) {
                            setState(() {
                              selectedUser = newValue;
                            });
                          }),
                      SizedBox(
                        height: 10.0,
                      ),
                      new DropdownButton<String>(
                          hint: Text('Select Time'),
                          dropdownColor: Colors.grey,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 36,
                          isExpanded: true,
                          items: <String>[
                            '4pm - 5pm',
                            '5pm - 6pm',
                            '6pm - 7pm',
                            '7pm - 8pm'
                          ].map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(
                                value,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                            );
                          }).toList(),
                          value: selectTime,
                          onChanged: (newValue) {
                            setState(() {
                              selectTime = newValue;
                            });
                          }),
                      SizedBox(
                        height: 10.0,
                      ),
                      new DropdownButton<String>(
                          hint: Text('Pet Type'),
                          dropdownColor: Colors.grey,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 36,
                          isExpanded: true,
                          items: <String>['Dog', 'Cat', 'Bird', 'Rabit']
                              .map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(
                                value,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                            );
                          }).toList(),
                          value: selectType,
                          onChanged: (newValue) {
                            setState(() {
                              selectType = newValue;
                            });
                          }),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextField(
                        controller: value1,
                        decoration: InputDecoration(
                          labelText: "Pet Name",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextField(
                        controller: value2,
                        decoration: InputDecoration(
                          labelText: "Note",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: RawMaterialButton(
                          onPressed: () async {
                            final uid =
                                await Provider.of(context).auth.getCurrentUID();
                            final name = await Provider.of(context)
                                .auth
                                .getCurrentUser();

                            await Firestore.instance
                                .collection("veterinarian")
                                .document(uid)
                                .collection('Bookings')
                                .add({
                              'doctor': selectedUser,
                              'selectTime': selectTime,
                              'petType': selectType,
                              'petName': value1.text,
                              'note': value2.text,
                              'user': name.displayName,
                              'date': formattedDate1,
                              selectedUser: '',
                              selectTime: '',
                              selectType: '',
                              value1.text: '',
                              value2.text: ''
                            });
                          },
                          fillColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              "Book",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
