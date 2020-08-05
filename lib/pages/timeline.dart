import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/header.dart';
import '../widgets/progress.dart';

final userRef = Firestore.instance.collection('users');

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  void initState() {
    super.initState();
  }

  createUser() {
    userRef.document('sdasdasd').setData({
      'username': 'Maria',
      'postsCount': 0,
      'isAdmin': false,
    });
  }

  updateUser() async {
    final doc = await userRef.document('H6FoRKZRRJogez8EPge3').get();

    if (doc.exists)
      doc.reference.updateData({
        'username': 'BOB',
        'postsCount': 0,
        'isAdmin': false,
      });
  }

  deleteUser() async {
    final doc = await userRef.document('H6FoRKZRRJogez8EPge3').get();

    if (doc.exists) doc.reference.delete();
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context, isAppTitle: true),
      body: StreamBuilder<QuerySnapshot>(
        stream: userRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          final List<Text> children = snapshot.data.documents
              .map((doc) => Text(doc['username']))
              .toList();
          return Container(
            child: ListView(
              children: children,
            ),
          );
        },
      ),
    );
  }
}
