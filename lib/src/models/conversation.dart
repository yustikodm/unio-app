import '../models/chat.dart';
import '../models/user.dart';
import 'package:flutter/material.dart';

class Conversation {
  String id = UniqueKey().toString();
  List<Chat> chats;
  bool read;
  User user;

  Conversation(this.user, this.chats, this.read);
}

class ConversationsList {
  List<Conversation> _conversations;
  User _currentUser = new User.init().getCurrentUser();

  ConversationsList() {
    this._conversations = [
      new Conversation(
          new User.basic('Kelly R. Hart', 'img/user2.jpg', UserState.available),
          [
            new Chat(
                'Supports overlappi',
                '63min ago',
                new User.basic(
                    'Kelly R. Hart', 'img/user2.jpg', UserState.available)),
            new Chat(
                'Accepts one sliver as content.', '15min ago', _currentUser),
            new Chat(
                'Header can ov',
                '16min ago',
                new User.basic(
                    'Kelly R. Hart', 'img/user2.jpg', UserState.available))
          ],
          false),
    ];
  }

  List<Conversation> get conversations => _conversations;
}
