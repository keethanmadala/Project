import 'package:Project/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthBloc {
  final authService = AuthService();
  final googleSignIn = GoogleSignIn(scopes: ['email']);
  Stream<User> get currentUser => authService.currentUser;
  String username = '';

  loginGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      //Firebase SignIn
      final result = await authService.signInWithCredential(credential);
      print(result.user.displayName);
      username = result.user.displayName;
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  logout() {
    authService.logOut();
  }
}
