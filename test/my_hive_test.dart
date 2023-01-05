import 'package:flutter_test/flutter_test.dart';
import 'package:getx_skeleton/app/data/local/my_hive.dart';
import 'package:getx_skeleton/app/data/models/user_model.dart';


import 'dart:io';
import 'dart:math';

import 'package:path/path.dart' as path;

// temp path to initialize hive somewhere
String _tempPath = path.join(Directory.current.path, '.dart_tool', 'test', 'tmp');

/// Returns a temporary directory in which a Hive can be initialized
Future<Directory> getTempDir() async {
  var name = Random().nextInt(pow(2, 32) as int);
  var dir = Directory(path.join(_tempPath, '${name}_tmp'));

  if (await dir.exists()) await dir.delete(recursive: true);

  await dir.create(recursive: true);
  return dir;
}

main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  // temp path to initialize hive
  // !) in case you wonder why we need path with testing only
  // !) its because hive use path_provider which is platform plugin
  // !) but in test there is no platform (running device) so we must
  // !) use normal path
  String path = (await getTempDir()).path;

  // initialize hive
  await MyHive.init(
    registerAdapters: (hive) {
      hive.registerAdapter(UserModelAdapter());
    },
    testPath: path, // pass test path
  );


  group('hive save, read, and delete test', () {
    test('write on hive', () async {
      // save user
      bool saved = await MyHive.saveUserToHive(UserModel.fromData(age: 23, phoneNumber: '+972595195630', username: 'Emad Beltaje'));
      expect(saved, true);
    });

    test('read from hive', () async {
      // get user and test if saving worked fine
      UserModel? user = MyHive.getCurrentUser();
      expect(user, isNotNull,reason: 'user must not be null');
    });


    test('delete from hive', () async {
      // delete user and check if delete work fine
      bool deleted = await MyHive.deleteCurrentUser();
      expect(deleted, true);

      // load user after delete and check (ofc it should be deleted)
      UserModel? userAfterDelete = MyHive.getCurrentUser();
      expect(userAfterDelete, isNull,reason: 'user must be null bcz we deleted it');
    });
  });
}