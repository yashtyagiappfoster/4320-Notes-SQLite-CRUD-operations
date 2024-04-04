import 'package:flutter/material.dart';
import 'package:sqlite_notes_app/models/notes_model.dart';
import 'package:sqlite_notes_app/services/db_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBHandler? dbHandler;
  late Future<List<NotesModel>> notesList;

  @override
  void initState() {
    super.initState();
    dbHandler = DBHandler();
    loadData();
  }

  loadData() async {
    notesList = dbHandler!.getNotesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes App'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: notesList,
              builder: (context, AsyncSnapshot<List<NotesModel>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    reverse: true,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          dbHandler?.updateItems(
                            NotesModel(
                                id: snapshot.data![index].id,
                                title: 'Updated Item',
                                description:
                                    'This is the Updated Item in the list',
                                email: 'yashtyagi@google.com'),
                          );
                          setState(() {
                            notesList = dbHandler!.getNotesList();
                          });
                        },
                        child: Dismissible(
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            child: const Icon(Icons.delete_forever),
                          ),
                          onDismissed: (DismissDirection direction) {
                            setState(() {
                              dbHandler!.deleteItem(snapshot.data![index].id);
                              notesList = dbHandler!.getNotesList();
                              snapshot.data!.remove(snapshot.data![index]);
                            });
                          },
                          key: ValueKey<int>(snapshot.data![index].id),
                          child: Card(
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(10),
                              title:
                                  Text(snapshot.data![index].title.toString()),
                              subtitle: Text(
                                  snapshot.data![index].description.toString()),
                              trailing:
                                  Text(snapshot.data![index].id.toString()),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  throw Exception('${snapshot.hasError}');
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dbHandler!
              .insert(
            NotesModel(
                id: 4,
                title: 'Fourth Task',
                description: 'This is my first task of the day',
                email: 'yashtyagixyz@google.com'),
          )
              .then((value) {
            print('task added');
            setState(() {
              notesList = dbHandler!.getNotesList();
            });
          }).onError((error, stackTrace) {
            print(error.toString());
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
