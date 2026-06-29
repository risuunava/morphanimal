/// Pure Dart entity — tidak ada import Flutter/Hive di layer ini
class Skill {
  final String id;
  final String name;
  final String element;
  final int power;
  final int accuracy;
  final int ppMax;
  final String? statusEffect; // "burn" | "paralyze" | "confuse" | null

  const Skill({
    required this.id,
    required this.name,
    required this.element,
    required this.power,
    required this.accuracy,
    required this.ppMax,
    this.statusEffect,
  });

  @override
  String toString() =>
      'Skill(id: $id, name: $name, element: $element, power: $power)';
}
