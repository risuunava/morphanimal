import '../../domain/entities/player.dart';

abstract class PlayerRepository {
  Future<void> save(Player player);
  Future<Player?> get();
  Future<void> update(Player player);
}
