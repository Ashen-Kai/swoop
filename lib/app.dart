import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'state/app_state.dart';
import 'screens/main_shell.dart';

/// Root application widget.
class SwoopApp extends StatefulWidget {
  const SwoopApp({super.key});

  @override
  State<SwoopApp> createState() => _SwoopAppState();
}

class _SwoopAppState extends State<SwoopApp> {
  late final AppState _appState;

  @override
  void initState() {
    super.initState();
    _appState = AppState();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateProvider(
      state: _appState,
      child: MaterialApp(
        title: 'Swoop',
        debugShowCheckedModeBanner: false,
        theme: SwoopTheme.lightTheme,
        home: const MainShell(),
      ),
    );
  }
}

/// InheritedWidget to provide AppState down the tree.
class AppStateProvider extends InheritedNotifier<AppState> {
  const AppStateProvider({
    super.key,
    required AppState state,
    required super.child,
  }) : super(notifier: state);

  static AppState of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<AppStateProvider>();
    return provider!.notifier!;
  }
}
