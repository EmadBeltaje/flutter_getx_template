import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

import '../models/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyHive {
  // hive box to store user data
  static late Box<UserModel> _userBox;
  // box name its like table name
  static const String _userBoxName = 'user';
  // store current user as (key => value)
  static const String _currentUserKey = 'local_user';

  /// initialize local db (HIVE)
  static init({List<TypeAdapter>? adapters}) async {
    await Hive.initFlutter();
    adapters?.forEach((adapter) {
      Hive.registerAdapter(adapter);
    });
    await _initUserBox();
  }

  /// initialize user box
  static Future<void> _initUserBox() async {
    _userBox = await Hive.openBox(_userBoxName);
  }

  /// save user to database
  static Future<void> saveUserToHive(UserModel user) async {
    try {
      await _userBox.put(_currentUserKey, user);
    } catch (error) {
      Logger().e('Hive Error => ${error}');
    }
  }

  /// get current logged user
  static UserModel? getCurrentUser() {
    try {
      return _userBox.get(_currentUserKey);
    } catch (error) {
      return null;
    }
  }

  static Future<void> deleteCurrentUser() async {
    try {
      await _userBox.delete(_currentUserKey);
    } catch (error) {}
  }
}
