import 'dart:io';
import 'package:path/path.dart' as path;

void main(List<String> args) {
  if (args.isEmpty) {
    print('请提供路径参数，例如: newgetx ./lib/test2');
    exit(1);
  }

  final String targetPath = args[0];
  final String folderName = path.basename(targetPath);
  final String className = _formatClassName(folderName);
  
  // 创建目录
  final Directory directory = Directory(targetPath);
  directory.createSync(recursive: true);

  // 创建 logic.dart
  final File logicFile = File('$targetPath/logic.dart');
  logicFile.writeAsStringSync('''
import 'package:get/get.dart';

import 'state.dart';

class ${className}Logic extends GetxController {
  final ${className}State state = ${className}State();
}
''');

  // 创建 state.dart
  final File stateFile = File('$targetPath/state.dart');
  stateFile.writeAsStringSync('''
class ${className}State {
  ${className}State() {
    ///Initialize variables
  }
}
''');

  // 创建 view.dart
  final File viewFile = File('$targetPath/view.dart');
  viewFile.writeAsStringSync('''
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';
import 'state.dart';

class ${className}Page extends StatelessWidget {
  ${className}Page({super.key});

  final ${className}Logic logic = Get.put(${className}Logic());
  final ${className}State state = Get.find<${className}Logic>().state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
''');

  print('成功创建 GetX 模板文件在: $targetPath');
}

String _formatClassName(String input) {
  // 将路径分割符转换为空格
  input = input.replaceAll(RegExp(r'[/\\]'), ' ');
  
  // 将下划线和连字符转换为空格
  input = input.replaceAll(RegExp(r'[_-]'), ' ');
  
  // 将每个单词首字母大写
  final words = input.split(' ');
  final capitalizedWords = words.map((word) {
    if (word.isEmpty) return '';
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  });
  
  // 合并所有单词
  return capitalizedWords.join();
}