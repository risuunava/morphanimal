import '../../core/constants/skill_database.dart';
import '../../core/utils/seed_generator.dart';

class SkillAssigner {
  /// Assign skill IDs sesuai rarity & element sesuai GDD 6.4
  static List<String> assign(
    String element,
    String animalGroup,
    String rarity,
    String seed,
  ) {
    final elementSkills = skillsByElement[element] ?? [];
    final skills = <String>[];

    // Skill 1: dari element (guaranteed)
    if (elementSkills.isNotEmpty) {
      skills.add(_pickSkill(elementSkills, seed, 'skill1', exclude: []));
    }

    // Skill 2: dari element jika Rare+
    if (rarity != 'common' && elementSkills.length > 1) {
      final skill2 = _pickSkill(elementSkills, seed, 'skill2', exclude: skills);
      if (skill2.isNotEmpty) skills.add(skill2);
    }

    // Skill 3: dari species (jika ada)
    final speciesSkill = speciesSkillMap[animalGroup];
    if (speciesSkill != null && !skills.contains(speciesSkill)) {
      skills.add(speciesSkill);
    }

    // Skill 4: random dari SEMUA skill, hanya Epic+
    if (rarity == 'epic' || rarity == 'legendary') {
      final allSkills = skillsByElement.values.expand((s) => s).toList();
      final randomSkill = _pickSkill(allSkills, seed, 'skill4', exclude: skills);
      if (randomSkill.isNotEmpty) skills.add(randomSkill);
    }

    return skills;
  }

  static String _pickSkill(
    List<SkillData> pool,
    String seed,
    String salt, {
    required List<String> exclude,
  }) {
    final available = pool.where((s) => !exclude.contains(s.id)).toList();
    if (available.isEmpty) return '';
    final idx = SeedGenerator.seededInt(seed, salt, 0, available.length);
    return available[idx].id;
  }
}
