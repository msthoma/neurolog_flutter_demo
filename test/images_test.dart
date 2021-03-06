import 'dart:io';

import 'package:neurolog_flutter_demo/resources/resources.dart';
import 'package:test/test.dart';

void main() {
  test('images assets test', () {
    expect(true, File(Images.o).existsSync());
    expect(true, File(Images.cclabLogo).existsSync());
    expect(true, File(Images.mariSenseLogo).existsSync());
    expect(true, File(Images.empty).existsSync());
    expect(true, File(Images.oucLogo).existsSync());
    expect(true, File(Images.aiBrain).existsSync());
    expect(true, File(Images.x).existsSync());
  });
}
