import 'package:flutter/foundation.dart';

import 'friend.dart';

class UserUid with ChangeNotifier{
  String? _uid;
  String? get uid => _uid;
  Friend? _friend;
  Friend? get friend=> _friend;

  void login(String uid) {
    _uid = uid;
    notifyListeners();
  }

  void logout() {
    _uid = null;
    notifyListeners();
  }

  void setFriend(Friend? friend) {
    _friend = friend;
    notifyListeners();
  }


}