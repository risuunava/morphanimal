import 'package:hive_flutter/hive_flutter.dart';

part 'bestiary_model.g.dart';

@HiveType(typeId: 3)
class BestiaryModel extends HiveObject {
  @HiveField(0) late String species;
  @HiveField(1) late bool discovered;
  @HiveField(2) late int captureCount;
  @HiveField(3) DateTime? firstCaptured;
}
