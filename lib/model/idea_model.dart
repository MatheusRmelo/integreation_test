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

import 'package:flutter/foundation.dart';

import '../services/database_service.dart';

class Idea {
  String? title;
  String? inspiration;
  String? date;
  Idea({this.title, this.inspiration, this.date});
  Idea.fromJson(Map<String, dynamic> json)
      : this(
          title: json['title']! as String,
          inspiration: json['inspiration']! as String,
          date: json['date']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'title': title,
      'inspiration': inspiration,
      'date': date,
    };
  }
}

class IdeasModel extends ChangeNotifier {
  List<Idea> _ideasList = [];

  List<Idea> get getAllIdeas => _ideasList;

  void initializeIdeas(List<Idea> ideasList) {
    _ideasList = ideasList;
  }

  void addIdea(Idea ideaItem) {
    _ideasList.add(ideaItem);
    DatabaseService().updateData(getAllIdeas);
    notifyListeners();
  }

  void deleteIdea(Idea ideaItem) {
    _ideasList.remove(ideaItem);
    DatabaseService().updateData(getAllIdeas);
    notifyListeners();
  }
}
