import '../../domain/entities/player.dart';
import '../../domain/repositories/player_repository.dart';
import '../datasources/local/hive_datasource.dart';
import '../models/player_model.dart';

class PlayerRepositoryImpl implements PlayerRepository {
  final HiveLocalDatasource _datasource;

  PlayerRepositoryImpl(this._datasource);

  @override
  Future<void> save(Player player) async {
    final model = PlayerModel.fromEntity(player);
    await _datasource.savePlayer(model);
  }

  @override
  Future<Player?> get() async {
    final model = await _datasource.getPlayer();
    return model?.toEntity();
  }

  @override
  Future<void> update(Player player) async {
    final model = PlayerModel.fromEntity(player);
    await _datasource.savePlayer(model);
  }
}
