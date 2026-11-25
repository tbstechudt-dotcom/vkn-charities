/// Build-time configuration.
///
/// Pass the API address when running or building, e.g.
///   flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8080
///   flutter build web --release --dart-define=API_BASE_URL=https://api.vkncharities.org
///
/// If the Node server also hosts the Flutter build, leave API_BASE_URL empty:
/// requests then go to the same origin ("/api/...").
class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: '');

  // ---- Organisation contact details (edit these) -------------------
  static const String orgName = 'VKN Charities';
  static const String email = 'info@vkncharities.org';
  static const String phone = '+91 00000 00000';
  static const String addressLine1 = 'Puravipalayam, Pollachi';
  static const String addressLine2 = 'Coimbatore District, Tamil Nadu 642005';
  static const String usAddress = 'Louisville, Kentucky, USA';
}
