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

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/idea_model.dart';
import 'authentication_service.dart';

class DatabaseService {
  final AuthenticationService _authenticationService = AuthenticationService();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference ideas = FirebaseFirestore.instance.collection('ideas');

  Future<String> getDocID(String userID) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('ideas')
        .where('userID', isEqualTo: userID)
        .get();
    log('${result.docs.length.toString()}');
    return result.docs[0].reference.id.toString();
  }

  Future<Map<String, dynamic>> readData(String userID) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('ideas')
        .where('userID', isEqualTo: userID)
        .get();
    return result.docs.length > 0
        ? result.docs[0].data() as Map<String, dynamic>
        : <String, dynamic>{};
  }

  Future<void> addNewUserData() async {
    return ideas.add({
      'userID': _authenticationService.getUserID,
      'ideasList': <Map<String, dynamic>>[]
    }).then((value) {
      print('UserData Added');
      getDocID(_authenticationService.getUserID);
    });
  }

  Future updateData(List<Idea> ideasList) async {
    final list = <Map<String, dynamic>>[];
    ideasList.forEach((element) {
      list.add(element.toJson());
    });
    final docID = await getDocID(_authenticationService.getUserID);
    return ideas.doc(docID).update({'ideasList': list}).then<void>(
        (value) => print('Ideas Updated'));
  }
}
