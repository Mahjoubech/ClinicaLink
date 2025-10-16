package io.github.Mahjoubech.clinicalink.utils;

public class Validateur {
    public static boolean isValidTele(String tele) {
        String teleRegex = "^(\\+212|0)([5-7])[0-9]{8}$";
        return tele != null && tele.matches(teleRegex);
    }
    public static boolean isValidEmail(String email) {
        String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
        return email != null && email.matches(emailRegex);
    }
    public static boolean isValidSSN(String ssn) {
        if (ssn == null || ssn.trim().isEmpty()) {
            return false;
        }
        ssn = ssn.trim();
        return ssn.matches("^\\d{5,8}$");
    }

}
