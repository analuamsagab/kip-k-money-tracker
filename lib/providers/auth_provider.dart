import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../config/app_config.dart';

class AuthState {
  final GoogleSignInAccount? account;
  final bool isLoading;

  const AuthState({this.account, this.isLoading = false});

  bool get isSignedIn => account != null;
  String get displayName => account?.displayName ?? AppConfig.userName;
  String get email => account?.email ?? '';
  String? get photoUrl => account?.photoUrl;
}

class AuthNotifier extends StateNotifier<AuthState> {
  final GoogleSignIn _googleSignIn;

  AuthNotifier()
      : _googleSignIn = GoogleSignIn(
          serverClientId: AppConfig.googleClientId,
          scopes: ['https://www.googleapis.com/auth/drive.file'],
        ),
        super(const AuthState(isLoading: true)) {
    _init();
  }

  Future<void> _init() async {
    final account = await _googleSignIn.signInSilently();
    state = AuthState(account: account);
  }

  GoogleSignIn get googleSignIn => _googleSignIn;

  Future<void> signIn() async {
    state = AuthState(isLoading: true, account: state.account);
    try {
      final account = await _googleSignIn.signIn();
      state = AuthState(account: account);
    } catch (_) {
      state = AuthState(account: state.account);
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
