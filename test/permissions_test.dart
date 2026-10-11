import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:splg_lib/splg_lib.dart';

class FakeGateway implements PermissionGateway {
  FakeGateway(this.initial, [List<PermissionOutcome>? responses])
      : responses = [...?responses];

  PermissionOutcome initial;
  final List<PermissionOutcome> responses;
  int requests = 0;
  int settingsOpened = 0;
  bool throws = false;

  @override
  Future<PermissionOutcome> status(AppPermission permission) async {
    if (throws) throw StateError('sin plugin');
    return initial;
  }

  @override
  Future<PermissionOutcome> request(AppPermission permission) async {
    requests++;
    return responses.isEmpty ? PermissionOutcome.denied : responses.removeAt(0);
  }

  @override
  Future<bool> openSettings() async {
    settingsOpened++;
    return true;
  }
}

class FakePrompter implements PermissionPrompter {
  FakePrompter(
      {this.explainAnswer = true, this.retry = true, this.settings = true});

  final bool explainAnswer;
  final bool retry;
  final bool settings;
  int explained = 0;
  int deniedShown = 0;
  int settingsShown = 0;

  @override
  Future<bool> explain(AppPermission p, PermissionCopy c) async {
    explained++;
    return explainAnswer;
  }

  @override
  Future<bool> denied(AppPermission p, PermissionCopy c) async {
    deniedShown++;
    return retry;
  }

  @override
  Future<bool> openSettings(AppPermission p, PermissionCopy c) async {
    settingsShown++;
    return settings;
  }
}

void main() {
  const granted = PermissionOutcome.granted;
  const denied = PermissionOutcome.denied;
  const forever = PermissionOutcome.permanentlyDenied;

  PermissionsService svc(FakeGateway g, FakePrompter p) =>
      PermissionsService(gateway: g, prompter: p);

  test('ya concedido: no explica ni pide', () async {
    final g = FakeGateway(granted);
    final p = FakePrompter();
    expect(await svc(g, p).ensure(AppPermission.camera), granted);
    expect(p.explained, 0);
    expect(g.requests, 0);
  });

  test('denegado: explica, pide y concede', () async {
    final g = FakeGateway(denied, [granted]);
    final p = FakePrompter();
    expect(await svc(g, p).ensure(AppPermission.location), granted);
    expect(p.explained, 1);
    expect(g.requests, 1);
  });

  test('si el usuario rechaza la explicación no se llega al pedido del sistema',
      () async {
    final g = FakeGateway(denied, [granted]);
    final p = FakePrompter(explainAnswer: false);
    expect(await svc(g, p).ensure(AppPermission.location), denied);
    expect(g.requests, 0);
  });

  test('sin explicación (explain: false) pide directo', () async {
    final g = FakeGateway(denied, [granted]);
    final p = FakePrompter();
    await svc(g, p).ensure(AppPermission.notifications, explain: false);
    expect(p.explained, 0);
    expect(g.requests, 1);
  });

  test('denegado: ofrece reintentar y vuelve a pedir una vez más', () async {
    final g = FakeGateway(denied, [denied, granted]);
    final p = FakePrompter();
    expect(await svc(g, p).ensure(AppPermission.camera), granted);
    expect(g.requests, 2);
    expect(p.explained, 1, reason: 'la explicación se muestra una sola vez');
    expect(p.deniedShown, 1);
  });

  test('denegado dos veces: se rinde sin colgarse', () async {
    final g = FakeGateway(denied, [denied, denied, denied]);
    final p = FakePrompter();
    expect(await svc(g, p).ensure(AppPermission.camera), denied);
    expect(g.requests, PermissionsService.maxRequests);
  });

  test('denegado y el usuario no quiere reintentar', () async {
    final g = FakeGateway(denied, [denied, granted]);
    final p = FakePrompter(retry: false);
    expect(await svc(g, p).ensure(AppPermission.camera), denied);
    expect(g.requests, 1);
  });

  test('denegado para siempre: ofrece Ajustes y los abre', () async {
    final g = FakeGateway(forever);
    final p = FakePrompter();
    expect(await svc(g, p).ensure(AppPermission.photos), forever);
    expect(p.settingsShown, 1);
    expect(g.settingsOpened, 1);
    expect(g.requests, 0);
  });

  test('denegado para siempre y el usuario dice "ahora no": no abre Ajustes',
      () async {
    final g = FakeGateway(forever);
    final p = FakePrompter(settings: false);
    expect(await svc(g, p).ensure(AppPermission.photos), forever);
    expect(g.settingsOpened, 0);
  });

  test('iOS: el pedido devuelve "para siempre" -> camino a Ajustes', () async {
    final g = FakeGateway(denied, [forever]);
    final p = FakePrompter();
    expect(await svc(g, p).ensure(AppPermission.location), forever);
    expect(p.settingsShown, 1);
    expect(g.settingsOpened, 1);
  });

  test('restringido: unavailable, sin avisos', () async {
    final g = FakeGateway(PermissionOutcome.unavailable);
    final p = FakePrompter();
    expect(await svc(g, p).ensure(AppPermission.camera),
        PermissionOutcome.unavailable);
    expect(p.explained + p.settingsShown + p.deniedShown, 0);
  });

  test('interactive: false sólo consulta', () async {
    final g = FakeGateway(denied, [granted]);
    final p = FakePrompter();
    expect(
        await svc(g, p).ensure(AppPermission.notifications, interactive: false),
        denied);
    expect(g.requests, 0);
    expect(p.explained, 0);
  });

  test('si el plugin falla no lanza', () async {
    final g = FakeGateway(denied)..throws = true;
    final s = svc(g, FakePrompter());
    expect(await s.ensure(AppPermission.camera), PermissionOutcome.unavailable);
    expect(await s.status(AppPermission.camera), PermissionOutcome.unavailable);
  });

  group('PermissionHandlerGateway.outcomeOf', () {
    test('mapea los estados de permission_handler', () {
      PermissionOutcome m(PermissionStatus s) =>
          PermissionHandlerGateway.outcomeOf(s);
      expect(m(PermissionStatus.granted), granted);
      expect(m(PermissionStatus.limited), granted);
      expect(m(PermissionStatus.provisional), granted);
      expect(m(PermissionStatus.denied), denied);
      expect(m(PermissionStatus.permanentlyDenied), forever);
      expect(m(PermissionStatus.restricted), PermissionOutcome.unavailable);
    });
  });

  test('hay texto en castellano con SPLG para cada permiso', () {
    for (final p in AppPermission.values) {
      final c = defaultPermissionCopy[p]!;
      expect(c.rationale, contains('SPLG'));
      expect(c.settingsMessage, contains('Ajustes'));
    }
  });
}
