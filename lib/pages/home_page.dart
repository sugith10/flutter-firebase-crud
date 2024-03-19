import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final CollectionReference donor =
      FirebaseFirestore.instance.collection('donor');
  deletDonor(String id) {
    donor.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    print(donor);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'addUser');
        },
        elevation: 0,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: StreamBuilder(
          stream: donor.orderBy('name').snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              log('Error: ${snapshot.error}');
              return const Center(
                child: Text('Error fetching data.'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot donorSnap =
                        snapshot.data.docs[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(donorSnap['group']),
                      ),
                      title: Text(donorSnap['name']),
                      subtitle: Text(donorSnap['phone'].toString()),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                'addUser',
                                arguments: {
                                  'name': donorSnap['name'],
                                  'phone': donorSnap['phone'],
                                  'group': donorSnap['group'],
                                  'id': donorSnap.id,
                                },
                              );
                              print('Edit button pressed for item $index');
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              deletDonor(donorSnap.id);
                              print('Delete button pressed for item $index');
                            },
                          ),
                        ],
                      ),
                    );
                  });
            }
            return const Center(
              child: Text('No data found'),
            );
          }),
    );
  }
}
