import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../game/mission_generator.dart';

const _missionBoxKey = 'mission_settings';

class MissionNotifier extends StateNotifier<List<DailyMission>> {
  MissionNotifier() : super([]) {
    _load();
  }

  void _load() {
    final box = Hive.box<String>(_missionBoxKey);
    final today = _dateKey(DateTime.now());
    final savedDate = box.get('date');

    if (savedDate == today) {
      // Load dari Hive cache
      final raw = box.get('missions');
      if (raw != null) {
        final list = (jsonDecode(raw) as List).map((m) => _fromMap(m)).toList();
        state = list;
        return;
      }
    }

    // Generate baru
    final missions = MissionGenerator.generate(DateTime.now());
    state = missions;
    _save(today);
  }

  Future<void> incrementProgress(String defId) async {
    final updated = state.map((m) {
      if (m.defId != defId || m.completed) return m;
      final newProgress = m.progress + 1;
      return m.copyWith(
        progress: newProgress,
        completed: newProgress >= m.target,
      );
    }).toList();
    state = updated;
    _save(_dateKey(DateTime.now()));
  }

  Future<void> claimMission(String missionId) async {
    final updated = state.map((m) {
      if (m.id != missionId || m.claimed || !m.completed) return m;
      return m.copyWith(claimed: true);
    }).toList();
    state = updated;
    _save(_dateKey(DateTime.now()));
  }

  void _save(String today) {
    final box = Hive.box<String>(_missionBoxKey);
    box.put('date', today);
    box.put('missions', jsonEncode(state.map(_toMap).toList()));
  }

  String _dateKey(DateTime d) => '${d.year}-${d.month}-${d.day}';

  Map<String, dynamic> _toMap(DailyMission m) => {
        'id': m.id,
        'defId': m.defId,
        'title': m.title,
        'description': m.description,
        'icon': m.icon,
        'target': m.target,
        'progress': m.progress,
        'completed': m.completed,
        'claimed': m.claimed,
        'xpReward': m.xpReward,
        'goldReward': m.goldReward,
      };

  DailyMission _fromMap(Map<String, dynamic> m) => DailyMission(
        id: m['id'],
        defId: m['defId'],
        title: m['title'],
        description: m['description'],
        icon: m['icon'],
        target: m['target'],
        progress: m['progress'],
        completed: m['completed'],
        claimed: m['claimed'],
        xpReward: m['xpReward'],
        goldReward: m['goldReward'],
      );
}

final missionProvider = StateNotifierProvider<MissionNotifier, List<DailyMission>>(
  (ref) => MissionNotifier(),
);
