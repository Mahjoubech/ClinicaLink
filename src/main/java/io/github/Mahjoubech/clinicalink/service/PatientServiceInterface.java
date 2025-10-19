package io.github.Mahjoubech.clinicalink.service;

import io.github.Mahjoubech.clinicalink.entity.Patient;
import io.github.Mahjoubech.clinicalink.entity.VitalSigns;

import java.util.List;
import java.util.Optional;

public interface PatientServiceInterface {
    Patient registerPatient(Patient patient, VitalSigns vitalSigns);
    Patient updatePatient(Patient patient);
    boolean deletePatient(String patientId);
    Optional<Patient> findPatientBySsn(String ssn);
    List<Patient> findPatientsByFullName(String fullName);
    List<Patient> getTodayPatients();
    List<Patient> getAllPatients();
    boolean emailExiste(String email);
    boolean teleExit(String tele);
    List<Patient> getQueuePatients();
    void addToQueue(String patientId);
    void removeFromQueue(String patientId);

    Patient addVitalSigns(String patientId, VitalSigns vitalSigns);

    Optional<Patient> findPatientById(String id);
}
