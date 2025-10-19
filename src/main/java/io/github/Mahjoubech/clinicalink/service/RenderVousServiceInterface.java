package io.github.Mahjoubech.clinicalink.service;

import io.github.Mahjoubech.clinicalink.entity.Consultation;
import io.github.Mahjoubech.clinicalink.enums.StatusRendezVous;

import java.util.List;
import java.util.Optional;

public interface RenderVousServiceInterface {
    Consultation createConsultation(String patientId, String generalistId, String motive, String observations);

    List<Consultation> getAllConsultations();
    List<Consultation> getConsultationsGeneralistId(String generalistId);

    Optional<Consultation> getConsultationById(String id);
    Consultation updateStatus(String consultationId, StatusRendezVous status);

    Consultation updateDiagnosis(String consultationId,String diagnosis);
    Consultation updateTreatment(String consultationId,String treatment);
}
