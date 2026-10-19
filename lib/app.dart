import 'package:flutter/material.dart';

import 'screens/audico_shell.dart';
import 'theme/app_theme.dart';

class AudiCoApp extends StatelessWidget {
  const AudiCoApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AudiCo',
        theme: AppTheme.dark,
        home: const AudiCoShell(),
      );
}
