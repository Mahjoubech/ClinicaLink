package io.github.Mahjoubech.clinicalink.utils;

import java.util.Random;
import java.util.UUID;

public class Helper {
    public static String generateInfirmierID() {
        String uuidPart = UUID.randomUUID().toString().replace("-", "").substring(0, 8);
        return "INF-" + uuidPart.toUpperCase();
    }
    public static String generateGeneralisteID() {
        String uuidPart = UUID.randomUUID().toString().replace("-", "").substring(0, 8);
        return "GEN-" + uuidPart.toUpperCase();
    }
    public static String generateSpecialisteID() {
        String uuidPart = UUID.randomUUID().toString().replace("-", "").substring(0, 8);
        return "SPE-" + uuidPart.toUpperCase();
    }

    // Generate consultation code
    public static String generateConsultationCode() {
        String datePart = java.time.LocalDate.now().toString().replace("-", "");
        String randomPart = UUID.randomUUID().toString().substring(0, 6).toUpperCase();
        return "CONS-" + datePart + "-" + randomPart;
    }

    // Generate patient ID
    public static String generatePatientID() {
        String uuidPart = UUID.randomUUID().toString().replace("-", "").substring(0, 10);
        return "PAT-" + uuidPart.toUpperCase();
    }

    // Generate expertise request ID
    public static String generateExpertiseRequestID() {
        String datePart = java.time.LocalDate.now().toString().replace("-", "");
        int number = new Random().nextInt(10000);
        return String.format("EXP-%s-%04d", datePart, number);
    }

    // Generate appointment ID
    public static String generateAppointmentID() {
        String datePart = java.time.LocalDate.now().toString().replace("-", "");
        String randomPart = UUID.randomUUID().toString().substring(0, 4).toUpperCase();
        return "APT-" + datePart + "-" + randomPart;
    }
}