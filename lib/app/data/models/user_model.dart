// note you have to hardcode this part
// for example => (part 'classname.g.dart');
// class name must be in lower case
import 'package:hive/hive.dart';

// this line must be written by you
// for example => ( part 'filename.g.dart'; )
// FILENAME not class name and also all in lower case
part 'user_model.g.dart';

@HiveType(typeId: 1) // id must be unique
class UserModel {
  @HiveField(0)
  late final String username;
  @HiveField(1)
  late final int age;
  @HiveField(2)
  late final String phoneNumber;

  // you must provide empty constructor
  // so hive can generate(serializable) object
  // so you u can store this object in local db (hive)
  UserModel();

  UserModel.fromData({required this.age, required this.phoneNumber,required this.username});

  @override
  String toString(){
    return 'Username => $username\nAge => $age\nPhone number => $phoneNumber';
  }
}