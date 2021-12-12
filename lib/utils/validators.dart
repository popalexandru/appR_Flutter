class Validator{

  String? validateEmail(String email){
    if(email.isEmpty){
      return "Can't be empty";
    }

    if(!email.contains("@") || !email.contains(".")){
      return "Invalid email";
    }

    if(email.length < 8){
      return "Email is too short";
    }

    String substring = email.substring(email.indexOf("@") + 1, email.indexOf("."));
    bool substringAfterDot = email.indexOf(".") == email.length - 1;

    if(substring.isEmpty || substringAfterDot){
      return "Invalid email";
    }

    return null;
  }

  String? validatePassword(String password){
    if(password.length < 6){
      return "Password is too short";
    }

    bool passValid = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$').hasMatch(password);

/*    bool containsUpper = RegExp(r'^(?=.*[A-Z])$').hasMatch(password);
    bool containsLower = RegExp(r'^(?=.*[a-z])$').hasMatch(password);*/

/*    if(!containsUpper){
      return "Password has to contain atleast one upper letter";
    }*/

/*    if(!containsLower){
      return "Password has to contain one lower letter";
    }*/

    if(!passValid) return "Invalid password";

    return null;
  }

  String? validateName(String name){
    if(name.length < 2){
      return "Name too short";
    }

    return null;
  }

  String? validateSurname(String name){
    if(name.length < 2){
      return "Surname too short";
    }

    return null;
  }
}