import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../domain/entities/creature.dart';
import '../../domain/entities/player.dart';

class BackupRepository {
  static const _backupVersion = 1;

  // ─── EXPORT ───────────────────────────────────────────────────────────────

  /// Serialize semua data ke JSON dan simpan ke Downloads / temp
  static Future<String?> exportToJson({
    required Player? player,
    required List<Creature> creatures,
  }) async {
    try {
      final payload = {
        'version': _backupVersion,
        'exportedAt': DateTime.now().toIso8601String(),
        'player': player != null ? _playerToMap(player) : null,
        'creatures': creatures.map(_creatureToMap).toList(),
      };

      final json = const JsonEncoder.withIndent('  ').convert(payload);

      final directory = await getExternalStorageDirectory() ??
          await getApplicationDocumentsDirectory();
      final file = File(
        '${directory.path}/morphanimal_backup_${DateTime.now().millisecondsSinceEpoch}.json',
      );
      await file.writeAsString(json);

      return file.path;
    } catch (e) {
      debugPrint('Export error: $e');
      return null;
    }
  }

  /// Export + langsung share via share_plus
  static Future<void> exportAndShare({
    required BuildContext context,
    required Player? player,
    required List<Creature> creatures,
  }) async {
    final path = await exportToJson(player: player, creatures: creatures);
    if (path != null) {
      // ignore: deprecated_member_use
      await Share.shareXFiles(
        [XFile(path)],
        text: 'Backup koleksi Morphanimal saya 🐾',
      );
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal membuat backup.')),
        );
      }
    }
  }

  // ─── IMPORT ───────────────────────────────────────────────────────────────

  static BackupParseResult importFromJson(String jsonString) {
    try {
      final Map<String, dynamic> payload = jsonDecode(jsonString);

      // Validasi versi
      final version = payload['version'];
      if (version == null || version > _backupVersion) {
        return BackupParseResult.error('Versi backup tidak kompatibel ($version).');
      }

      // Parse player
      Player? player;
      if (payload['player'] != null) {
        player = _playerFromMap(payload['player'] as Map<String, dynamic>);
      }

      // Parse creatures
      final rawCreatures = payload['creatures'] as List? ?? [];
      final creatures = <Creature>[];
      for (final raw in rawCreatures) {
        try {
          creatures.add(_creatureFromMap(raw as Map<String, dynamic>));
        } catch (_) {
          // Skip entri rusak
        }
      }

      return BackupParseResult.success(player: player, creatures: creatures);
    } on FormatException {
      return BackupParseResult.error('File bukan JSON yang valid.');
    } catch (e) {
      return BackupParseResult.error('Kesalahan saat membaca backup: $e');
    }
  }

  // ─── SERIALIZERS ──────────────────────────────────────────────────────────

  static Map<String, dynamic> _playerToMap(Player p) => {
        'id': p.id,
        'name': p.name,
        'level': p.level,
        'xp': p.xp,
        'gold': p.gold,
        'streak': p.streak,
        'lastLogin': p.lastLogin.toIso8601String(),
        'achievements': p.achievements,
        'battleTeamIds': p.battleTeamIds,
      };

  static Player _playerFromMap(Map<String, dynamic> m) => Player(
        id: m['id'] as String,
        name: m['name'] as String,
        level: m['level'] as int,
        xp: m['xp'] as int,
        gold: m['gold'] as int? ?? 0,
        streak: m['streak'] as int? ?? 0,
        lastLogin: DateTime.parse(m['lastLogin'] as String),
        achievements: (m['achievements'] as List?)?.cast<String>() ?? [],
        battleTeamIds: (m['battleTeamIds'] as List?)?.cast<String>() ?? [],
      );

  static Map<String, dynamic> _creatureToMap(Creature c) => {
        'id': c.id,
        'species': c.species,
        'commonName': c.commonName,
        'creatureName': c.creatureName,
        'element': c.element,
        'rarity': c.rarity,
        'level': c.level,
        'xp': c.xp,
        'hp': c.hp,
        'atk': c.atk,
        'def': c.def,
        'spd': c.spd,
        'ivs': c.ivs,
        'skillIds': c.skillIds,
        'imagePath': c.imagePath,
        'rawImagePath': c.rawImagePath,
        'seed': c.seed,
        'capturedAt': c.capturedAt.toIso8601String(),
        'isFavorite': c.isFavorite,
      };

  static Creature _creatureFromMap(Map<String, dynamic> m) => Creature(
        id: m['id'] as String,
        species: m['species'] as String,
        commonName: m['commonName'] as String,
        creatureName: m['creatureName'] as String,
        element: m['element'] as String,
        rarity: m['rarity'] as String,
        level: m['level'] as int,
        xp: m['xp'] as int? ?? 0,
        hp: m['hp'] as int,
        atk: m['atk'] as int,
        def: m['def'] as int,
        spd: m['spd'] as int,
        ivs: Map<String, int>.from(
          (m['ivs'] as Map?)?.map((k, v) => MapEntry(k as String, v as int)) ?? {},
        ),
        skillIds: (m['skillIds'] as List?)?.cast<String>() ?? [],
        imagePath: m['imagePath'] as String? ?? '',
        rawImagePath: m['rawImagePath'] as String? ?? '',
        seed: m['seed'] as String? ?? '',
        capturedAt: DateTime.parse(m['capturedAt'] as String),
        isFavorite: m['isFavorite'] as bool? ?? false,
      );
}

// ─── Result Type ──────────────────────────────────────────────────────────────

class BackupParseResult {
  final bool success;
  final String? error;
  final Player? player;
  final List<Creature> creatures;

  const BackupParseResult._({
    required this.success,
    this.error,
    this.player,
    this.creatures = const [],
  });

  factory BackupParseResult.success({Player? player, required List<Creature> creatures}) =>
      BackupParseResult._(success: true, player: player, creatures: creatures);

  factory BackupParseResult.error(String message) =>
      BackupParseResult._(success: false, error: message);
}
