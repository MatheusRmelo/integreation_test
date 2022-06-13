// ignore_for_file: lines_longer_than_80_chars

/*
Copyright (c) 2021 Razeware LLC

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
distribute, sublicense, create a derivative work, and/or sell copies of the
Software in any work that is designed, intended, or marketed for pedagogical or
instructional purposes related to programming, coding, application development,
or information technology.  Permission for such use, copying, modification,
merger, publication, distribution, sublicensing, creation of derivative works,
or sale is expressly withheld.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_screens/login_screen.dart';
import 'new_idea_screen.dart';
import '../model/idea_model.dart';
import '../services/authentication_service.dart';
import '../services/database_service.dart';

class HomeScreen extends StatefulWidget {
  final AuthenticationService? authenticationService;
  const HomeScreen({Key? key, @required this.authenticationService}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int i = 0;

  List<Idea> jsonToIdeasList(Map<String, dynamic> data) {
    final ideas = <Idea>[];
    if (data['ideasList'] != null)
      data['ideasList']!.forEach((Object? e) {
        ideas.add(Idea.fromJson(e as Map<String, dynamic>));
      });
    if (i == 0) {
      Provider.of<IdeasModel>(context, listen: false).initializeIdeas(ideas);
      i = 1;
    }
    return ideas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      floatingActionButton: FloatingActionButton(
        key: const ValueKey('addButton'),
        onPressed: () {
          Navigator.push<NewIdeaScreen>(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  ChangeNotifierProvider.value(value: Provider.of<IdeasModel>(context), child: const NewIdeaScreen()),
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green.shade800,
      ),
      appBar: AppBar(
        title: const Text('Ideas'),
        backgroundColor: Colors.green.shade900,
        actions: [
          IconButton(
            key: const ValueKey('LogoutKey'),
            onPressed: () {
              widget.authenticationService!.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<LoginScreen>(
                  builder: (_) => ChangeNotifierProvider.value(
                    value: Provider.of<IdeasModel>(context),
                    child: LoginScreen(
                      authenticationService: widget.authenticationService,
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.logout_outlined,
            ),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
          future: DatabaseService().readData(AuthenticationService().getUserID),
          builder: (ctx, data) {
            if (!data.hasData)
              return const Center(
                child: CircularProgressIndicator(),
              );
            jsonToIdeasList(data.data!);
            return Consumer<IdeasModel>(builder: (context, ideasModel, child) {
              final ideasList = ideasModel.getAllIdeas;
              return ideasList.length == 0
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Add New Idea by clicking add icon below',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: ideasList.length,
                      itemBuilder: (ctx, index) {
                        return Card(
                          key: ValueKey('${ideasList[index].title!}'),
                          elevation: 8,
                          color: Colors.grey.shade200,
                          child: Dismissible(
                            key: UniqueKey(),
                            onDismissed: (direction) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${ideasList[index].title!} dismissed'),
                                ),
                              );
                              Provider.of<IdeasModel>(context, listen: false).deleteIdea(ideasList[index]);
                            },
                            background: Container(color: Colors.redAccent),
                            child: ListTile(
                              title: Text(
                                ideasList[index].title!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                ideasList[index].inspiration!,
                              ),
                              isThreeLine: true,
                            ),
                          ),
                        );
                      },
                    );
            });
          }),
    );
  }
}
