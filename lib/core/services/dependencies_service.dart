import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:open_pass_test_oliva_patricio/core/services/dependencies_service.config.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<GetIt> configureDependencies(String env) async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetIt.instance.init(environment: env);
  getIt.allowReassignment = true;
  return getIt;
}

@module
abstract class InjectableModule {
  @lazySingleton
  Client get client => Client();

  @preResolve
  @lazySingleton
  Future<SharedPreferences> get sharedPreferences async =>
      await SharedPreferences.getInstance();
}
