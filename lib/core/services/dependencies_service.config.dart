// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;
import 'package:open_pass_test_oliva_patricio/core/services/dependencies_service.dart'
    as _i157;
import 'package:open_pass_test_oliva_patricio/core/services/http_service.dart'
    as _i355;
import 'package:open_pass_test_oliva_patricio/features/character/data/data_sources/character_remote_data_source.dart'
    as _i437;
import 'package:open_pass_test_oliva_patricio/features/character/data/repositories/character_repository.dart'
    as _i756;
import 'package:open_pass_test_oliva_patricio/features/character/domain/repositories/character_repository_base.dart'
    as _i701;
import 'package:open_pass_test_oliva_patricio/features/character/domain/use_cases/get_characters_use_case.dart'
    as _i518;
import 'package:open_pass_test_oliva_patricio/features/character/presentation/manager/character_bloc.dart'
    as _i932;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final injectableModule = _$InjectableModule();
    gh.lazySingleton<_i519.Client>(() => injectableModule.client);
    gh.factory<_i355.HttpServiceBase>(
        () => _i355.HttpService(http: gh<_i519.Client>()));
    gh.factory<_i437.CharacterRemoteDataSourceBase>(() =>
        _i437.CharacterRemoteDataSource(http: gh<_i355.HttpServiceBase>()));
    gh.factory<_i701.CharacterRepositoryBase>(() => _i756.CharacterRepository(
        remote: gh<_i437.CharacterRemoteDataSourceBase>()));
    gh.factory<_i518.GetCharactersUseCase>(() => _i518.GetCharactersUseCase(
        repository: gh<_i701.CharacterRepositoryBase>()));
    gh.factory<_i932.CharacterBloc>(() => _i932.CharacterBloc(
        getCharactersUseCase: gh<_i518.GetCharactersUseCase>()));
    return this;
  }
}

class _$InjectableModule extends _i157.InjectableModule {}
