/// Texto para el usuario ante un error de la API. El mensaje del back se
/// muestra sólo si es un 400/409 de negocio escrito en castellano y sin
/// identificadores internos; todo lo demás usa un texto propio por código.
class ApiErrorText {
  ApiErrorText._();

  static const String offline = 'Sin conexión. Revisá tu internet.';
  static const String sessionExpired =
      'Tu sesión venció. Volvé a iniciar sesión.';
  static const String forbidden = 'No tenés permiso para hacer esto.';
  static const String notFound = 'No encontramos lo que buscabas.';
  static const String tooMany =
      'Hiciste demasiados intentos. Esperá un momento y probá de nuevo.';
  static const String server =
      'Tuvimos un problema en el servidor. Probá de nuevo en unos minutos.';
  static const String inProgress =
      'Ya estamos procesando tu pedido. Esperá un momento.';
  static const String generic =
      'No pudimos completar la acción. Probá de nuevo.';

  /// Mensaje de negocio del back, o null si no corresponde mostrarlo.
  static String? businessMessage(int? status, dynamic data) {
    if (status != 400 && status != 409) return null;
    if (isInProgress(status, data)) return null;
    final text = _messageOf(data);
    if (text == null || !_isSpanish(text)) return null;
    return text;
  }

  /// 409 técnico de idempotencia (`code: IDEMPOTENCY_IN_PROGRESS`): la primera
  /// llamada con la misma `Idempotency-Key` todavía se está procesando. Si el
  /// back no manda `code`, se reconoce por el texto (inglés o castellano).
  static bool isInProgress(int? status, dynamic data) {
    if (status != 409) return false;
    if (data is Map && data['code'] == 'IDEMPOTENCY_IN_PROGRESS') return true;
    final text = (_messageOf(data) ?? '').toLowerCase();
    return text.contains('idempotency') || text.contains('idempotencia');
  }

  /// El texto a mostrar para una respuesta [status] con cuerpo [data]
  /// (`status` null = no hubo respuesta).
  static String of(int? status, dynamic data) {
    if (status == null) return offline;
    if (isInProgress(status, data)) return inProgress;
    final business = businessMessage(status, data);
    if (business != null) return business;
    return switch (status) {
      401 => sessionExpired,
      403 => forbidden,
      404 => notFound,
      429 => tooMany,
      >= 500 => server,
      _ => generic,
    };
  }

  /// Si volver a intentar tiene sentido (red caída, 429, 5xx).
  static bool isRetryable(int? status) =>
      status == null || status == 429 || status >= 500;

  static String? _messageOf(dynamic data) {
    if (data is! Map) return null;
    final m = data['message'];
    final text = switch (m) {
      String s => s,
      List l => l.whereType<String>().join('\n'),
      _ => null,
    };
    final trimmed = text?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }

  static final _uuid = RegExp(
      r'[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}',
      caseSensitive: false);
  static final _accents = RegExp(r'[áéíóúñüÁÉÍÓÚÑ¿¡]');
  static final _word = RegExp(r"[a-záéíóúñü']+");

  static const _es = {
    'el',
    'la',
    'los',
    'las',
    'de',
    'del',
    'no',
    'ya',
    'un',
    'una',
    'su',
    'se',
    'con',
    'para',
    'por',
    'que',
    'pedido',
    'está',
    'es',
    'en',
    'al',
    'puede',
    'debe',
    'tiene',
    'contacte',
    'cancelar',
    'finalizado',
  };
  static const _en = {
    'the',
    'must',
    'should',
    'is',
    'are',
    'not',
    'cannot',
    'can',
    'invalid',
    'already',
    'forbidden',
    'resource',
    'unauthorized',
    'found',
    'error',
    'internal',
    'server',
    'bad',
    'request',
    'be',
    'to',
    'of',
    'a',
    'an',
    'with',
    'for',
    'and',
    'or',
    'order',
    'user',
    'id',
    'uuid',
    'value',
  };

  static bool _isSpanish(String text) {
    if (_uuid.hasMatch(text)) return false;
    final words = _word.allMatches(text.toLowerCase()).map((m) => m.group(0)!);
    var es = 0, en = 0;
    for (final w in words) {
      if (_es.contains(w)) es++;
      if (_en.contains(w)) en++;
    }
    if (_accents.hasMatch(text)) es += 2;
    return es > en;
  }
}
