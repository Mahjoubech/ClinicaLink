package io.github.Mahjoubech.clinicalink.utils;

public class AdminAuth {
    private static final String ADMIN_EMAIL = "admin@clinicalink.com";
    private static final String ADMIN_PASSWORD = "admin123";
    public static boolean authenticate(String email, String password) {
        return ADMIN_EMAIL.equals(email) && ADMIN_PASSWORD.equals(password);
    }
}