import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final TextEditingController _nameCntrlr = TextEditingController();
  final TextEditingController _phoneCntrlr = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameCntrlr;
    _phoneCntrlr;
    super.dispose();
  }

  final bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O-',
    'AB+',
    'AB-',
  ];
  String? selectedGroup;
  final CollectionReference donor =
      FirebaseFirestore.instance.collection('donor');

  void addDonor({
    required String name,
    required String group,
    required String phone,
  }) {
    final data = {
      'name': name,
      'phone': phone,
      'group': group,
    };
    donor.add(data);
  }

  String action = 'Submit';

  void updateDonor(
    String id, {
    required String name,
    required String group,
    required String phone,
  }) {
    final data = {
      'name': name,
      'phone': phone,
      'group': group,
    };
    donor.doc(id).update(data);
    log(id);
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      action = 'Update';
      _nameCntrlr.text = arguments['name'] ?? '';
      _phoneCntrlr.text = (arguments['phone'] ?? '').toString();
      selectedGroup = arguments['group'];
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Add User'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _nameCntrlr,
                decoration: const InputDecoration(
                  hintText: 'Name',
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _phoneCntrlr,
                decoration: const InputDecoration(
                  hintText: 'Phone Number',
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                value: selectedGroup,
                decoration: const InputDecoration(
                    label: Text('Select Blood Group'),
                    border: OutlineInputBorder()),
                items: bloodGroups
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (val) {
                  selectedGroup = val;
                },
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
                onPressed: () {
                  String blood = selectedGroup ?? '-';
                  arguments == null
                      ? addDonor(
                          group: blood,
                          name: _nameCntrlr.text,
                          phone: _phoneCntrlr.text,
                        )
                      : updateDonor(
                          arguments['id'],
                          group: blood,
                          name: _nameCntrlr.text,
                          phone: _phoneCntrlr.text,
                        );
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                    minimumSize:
                        MaterialStateProperty.all(Size(double.infinity, 50))),
                child: Text(action))
          ],
        ),
      ),
    );
  }
}
