import 'package:flutter_test/flutter_test.dart';
import 'package:audico/main.dart';

void main() {
  testWidgets('AudiCo smoke test shows brand and navigation', (tester) async {
    await tester.pumpWidget(const AudiCoApp());
    expect(find.text('AudiCo'), findsOneWidget);
    expect(find.text('Halo, Akmal 👋'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Marketplace'), findsOneWidget);
    expect(find.text('Riwayat'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
    expect(find.text('SCAN'), findsOneWidget);
  });

  testWidgets('scan opens permissions explanation', (tester) async {
    await tester.pumpWidget(const AudiCoApp());
    await tester.tap(find.text('SCAN'));
    await tester.pumpAndSettle();
    expect(find.text('Izin diperlukan'), findsOneWidget);
    expect(find.text('AKTIFKAN'), findsOneWidget);
  });
}
