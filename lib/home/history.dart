import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animalbook/widgets/provider_widet.dart';
import 'package:barcode_widget/barcode_widget.dart';

class History extends StatelessWidget {
  const History({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(245, 48, 111, 1.0),
        title: Center(
            child: Text(
          'History',
          style: TextStyle(
            color: Colors.white,
          ),
        )),
      ),
      body: StreamBuilder(
          stream: getUsersTripsStreamSnapshots(context),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text("Loading...");
            return new ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) =>
                    buildTripCard(context, snapshot.data.documents[index]));
          }),
    );
  }

  Stream<QuerySnapshot> getUsersTripsStreamSnapshots(
      BuildContext context) async* {
    final uid = await Provider.of(context).auth.getCurrentUID();
    yield* Firestore.instance
        .collection('veterinarian')
        .document(uid)
        .collection('Bookings')
        .orderBy('date', descending: true)
        .snapshots();
  }

  Widget buildTripCard(BuildContext context, DocumentSnapshot payment) {
    return new GestureDetector(
      onTap: () {
        return showDialog(
          context: context,
          builder: (context) {
            return Center(
                child: Material(
              type: MaterialType.transparency,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                padding: EdgeInsets.all(14),
                width: MediaQuery.of(context).size.width * 0.7,
                height: 320,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BarcodeWidget(
                        barcode: Barcode.qrCode(),
                        color: Colors.black,
                        // data: "Start Staion - ${payment['petName']}\n"
                        //     "End Station - ${(payment['doctor'])}\n"
                        //     "Price - ${(payment['petType'])}\n"
                        //     "Class - ${(payment['selectTime'])}\n",
                        data: "Pjkhdvcjksdvbsdkbvjsdbkbndsbjk",
                        width: 200,
                        height: 200,
                      ),
                    ],
                  ),
                ),
              ),
            ));
          },
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                  child: Row(children: <Widget>[
                    Text(
                      payment['petName'],
                      style: new TextStyle(fontSize: 25.0),
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                  child: Row(children: <Widget>[
                    Text(
                      "Doctor - ${(payment['doctor'])} ",
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                  child: Row(children: <Widget>[
                    Text(
                      "Time - ${(payment['selectTime'])} ",
                      style: TextStyle(color: Colors.blue, fontSize: 20.00),
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Pet Type - ${(payment['petType'])} ",
                        style: new TextStyle(fontSize: 35.0),
                      ),
                      Spacer(),
                      Icon(Icons.train_rounded),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
