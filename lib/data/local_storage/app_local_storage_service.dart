import 'package:get_storage/get_storage.dart';
import 'package:nextkick_admin/data/models/login_response.dart';

class AppLocalStorageService {
  final GetStorage _localBox;

  static const String _adminKey = 'admin';
  static const String _accessKey = 'access_token';
  static const String _refreshKey = 'refresh_token';
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userTypeKey = 'userType';

  AppLocalStorageService(this._localBox);

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _localBox.write('access_token', accessToken);
    await _localBox.write('refresh_token', refreshToken);
  }
  Future<void> saveAdminDetails(User admin) async {
    await _localBox.write(_adminKey, admin.toJson());
    await _localBox.write(_isLoggedInKey, true);
  }

  Future<void> saveUserType(String userType) async {
    await _localBox.write(_userTypeKey, userType);
  }

  User? getAdminDetails() {
    final adminData = _localBox.read(_adminKey);
    if (adminData != null) {
      return User.fromJson(Map<String, dynamic>.from(adminData));
    }
    return null;
  }

  String? getAccessToken() => _localBox.read(_accessKey);
  String? getRefreshToken() => _localBox.read(_refreshKey);
  String? getUserType() => _localBox.read(_userTypeKey);
  bool get isLoggedIn => _localBox.read(_isLoggedInKey) ?? false;

  Future<void> clearUser() async {
    await _localBox.remove(_adminKey);
    await _localBox.remove(_accessKey);
    await _localBox.remove(_refreshKey);
    await _localBox.remove(_isLoggedInKey);
    await _localBox.remove(_userTypeKey);
  }

  Future<void> completeLogout() async {
    await _localBox.erase();
  }
}
