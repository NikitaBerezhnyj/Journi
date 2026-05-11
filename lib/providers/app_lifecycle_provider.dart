import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/app_lifecycle_handler.dart';

final appLifecycleProvider = Provider((ref) {
  final handler = AppLifecycleHandler(ref);

  WidgetsBinding.instance.addObserver(handler);

  ref.onDispose(() {
    WidgetsBinding.instance.removeObserver(handler);
  });

  return handler;
});