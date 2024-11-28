import 'package:core_encode/core_encode.dart';
import 'package:dartz/dartz.dart';
import 'package:open_pass_test_oliva_patricio/features/character/data/data_sources/character_remote_data_source.dart';
import 'package:open_pass_test_oliva_patricio/core/entities/filter.dart';
import 'package:open_pass_test_oliva_patricio/features/character/domain/entities/characters_response.dart';

abstract class CharacterRepositoryBase {
  final CharacterRemoteDataSourceBase remote;

  CharacterRepositoryBase({
    required this.remote,
  });

  Future<Either<Failure, CharactersResponse>> getCharacters(Filter filter);
}