import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brew_crew/models/user.dart';

class AuthService {

	// _ mean private
	final FirebaseAuth _auth = FirebaseAuth.instance;

	// create user obj based on FirebaseUser
	User _userFromFirebaseUser(FirebaseUser user){
		if (user != null){
			return User(uid: user.uid);
		}
		else{
			return null;
		}
	}

	// auth change user stream
	Stream<User> get user {
		return _auth.onAuthStateChanged.map((FirebaseUser user) => _userFromFirebaseUser(user));
		// or .map(_userFromFirebaseUser);
	}

	// sign in anon
	Future signInAnon() async{
		try{
			AuthResult result = await _auth.signInAnonymously();
			FirebaseUser user = result.user;
			return _userFromFirebaseUser(user);
		}
		catch(e){
			print(e.toString());
			return null;
		}
	}

	// sign in email & password
  Future signInWithEmailAndPassword(String email, String password) async{
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    }
    catch(e){
      print(e.toString());
			return null;
    }
  }

	// register email & password
  Future registerWithEmailAndPassword(String email, String password) async{
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      // create a new doc for the user with the uid
      await DatabaseService(uid: user.uid).updateUserData("0", "new crew member", 100);

      return _userFromFirebaseUser(user);
    }
    catch(e){
      print(e.toString());
			return null;
    }
  }

	// sigh out
	Future signOut() async{
		try{
			return await _auth.signOut();
		}
		catch(e){
			print(e.toString());
			return null;
		}
	}
}