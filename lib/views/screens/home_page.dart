import 'package:adv_11am_firebase_app/helpers/firebase_auth_helper.dart';
import 'package:adv_11am_firebase_app/helpers/firestore_helper.dart';
import 'package:adv_11am_firebase_app/views/components/my_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> insertFormKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController courseController = TextEditingController();

  String? name;
  int? age;
  String? course;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: const Text("HomePage"),
        actions: [
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () async {
              await FirebaseAuthHelper.firebaseAuthHelper.logOut();

              Navigator.of(context)
                  .pushNamedAndRemoveUntil('login_page', (route) => false);
            },
          ),
        ],
      ),
      drawer: MyDrawer(user: data['user']),
      body: StreamBuilder(
        // stream: FirestoreHelper.firestoreHelper.fetchAllRecords(),
        stream: FirebaseFirestore.instance.collection("students").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("ERROR: ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            QuerySnapshot<Map<String, dynamic>>? data = snapshot.data;

            if (data == null) {
              return const Center(
                child: Text("No any data available..."),
              );
            } else {
              List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs =
                  data.docs;

              return ListView.builder(
                itemCount: allDocs.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    isThreeLine: true,
                    leading: Text("${allDocs[i].id}"),
                    title: Text("${allDocs[i].data()['name']}"),
                    subtitle: Text(
                        "${allDocs[i].data()['course']}\nAge: ${allDocs[i].data()['age']}"),
                    trailing: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () async {
                            Map<String, dynamic> updatedRecord = {
                              "name": "Umang",
                              "age": 23,
                              "course": "Flutter",
                            };

                            await FirestoreHelper.firestoreHelper.updateRecord(
                                id: allDocs[i].id, data: updatedRecord);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await FirestoreHelper.firestoreHelper
                                .deleteRecord(id: allDocs[i].id);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: validateAndInsert,
      ),
    );
  }

  void validateAndInsert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(
          child: Text("Add Record"),
        ),
        content: Form(
          key: insertFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Enter name first...";
                  }
                  return null;
                },
                onSaved: (val) {
                  name = val;
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter name here...",
                    labelText: "Name"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: ageController,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Enter age first...";
                  } else if (val.length > 2) {
                    return "Enter valid age...";
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onSaved: (val) {
                  age = int.parse(val!);
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter age here...",
                    labelText: "Age"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: courseController,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Enter course first...";
                  }
                  return null;
                },
                onSaved: (val) {
                  course = val;
                },
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter course here...",
                    labelText: "Course"),
              ),
            ],
          ),
        ),
        actions: [
          OutlinedButton(
            child: Text("Add"),
            onPressed: () async {
              if (insertFormKey.currentState!.validate()) {
                insertFormKey.currentState!.save();

                Map<String, dynamic> record = {
                  "name": name,
                  "age": age,
                  "course": course,
                };

                await FirestoreHelper.firestoreHelper
                    .insertRecord(data: record);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Record inserted successfully..."),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );

                nameController.clear();
                ageController.clear();
                courseController.clear();

                setState(() {
                  name = null;
                  age = null;
                  course = null;
                });

                Navigator.of(context).pop();
              }
            },
          ),
          OutlinedButton(
            child: Text("Cancel"),
            onPressed: () {
              nameController.clear();
              ageController.clear();
              courseController.clear();

              setState(() {
                name = null;
                age = null;
                course = null;
              });

              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
