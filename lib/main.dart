import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FireStoreApp());
}

class FireStoreApp extends StatefulWidget {
  const FireStoreApp({Key? key}) : super(key: key);

  @override
  State<FireStoreApp> createState() => _FireStoreAppState();
}

class _FireStoreAppState extends State<FireStoreApp> {
  final textEditingController = TextEditingController();
  // final textEditingValue = TextEditingValue();

  @override
  Widget build(BuildContext context) {
    CollectionReference account =
        FirebaseFirestore.instance.collection('account');

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: textEditingController,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*TextField(
              controller: textEditingController,
            ),*/
          Expanded(
            child: Center(
              child: StreamBuilder(
                  stream: account.orderBy('name').snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView(
                      children: snapshot.data!.docs.map((acc) {
                        return Center(
                          child: ListTile(
                            subtitle: Text('${acc['money']}'),
                            title: Text(acc['name']),
                            onLongPress: () {
                              acc.reference.delete();
                            },
                          ),
                        );
                      }).toList(),
                    );
                  }),
            ),
          ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save),
          onPressed: () {
            account.add({
              'name': textEditingController.text,
              'money': textEditingController.text,
            });
            textEditingController.clear();
          },
        ),
      ),
    );
  }
}
