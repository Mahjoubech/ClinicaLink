package io.github.Mahjoubech.clinicalink.service;

import io.github.Mahjoubech.clinicalink.dao.MedcenDaoInterface;
import io.github.Mahjoubech.clinicalink.dao.PatientDaoInterface;
import io.github.Mahjoubech.clinicalink.dao.RenderVousDaoInterface;
import io.github.Mahjoubech.clinicalink.entity.Consultation;
import io.github.Mahjoubech.clinicalink.entity.Generaliste;
import io.github.Mahjoubech.clinicalink.entity.Medcen;
import io.github.Mahjoubech.clinicalink.entity.Patient;
import io.github.Mahjoubech.clinicalink.enums.Role;
import io.github.Mahjoubech.clinicalink.enums.StatusRendezVous;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

public class RenderVousService implements RenderVousServiceInterface {
    private final RenderVousDaoInterface rendeVousDao;
    private final PatientDaoInterface patientDao;
    private final MedcenDaoInterface medcenDao;

    public RenderVousService(RenderVousDaoInterface rendeVousDao,PatientDaoInterface patientDao,MedcenDaoInterface medcenDao){
        this.rendeVousDao = rendeVousDao;
        this.patientDao = patientDao;
        this.medcenDao = medcenDao;
    }

    @Override
    public  Consultation createConsultation(String patientId, String generalistId, String motive, String observations){
        try {
            Optional<Medcen> optUser = medcenDao.findById(generalistId);
            if (optUser.isEmpty()) {
                throw new RuntimeException("Generalist with such id not found: " + generalistId);
            }
            Medcen user = optUser.get();
            if (user.getRole() != Role.GENERALISTE) {
                throw new RuntimeException("User found is not a generalist " + generalistId);
            }
            Optional<Patient> optPatient = patientDao.findById(patientId);
            if (optPatient.isEmpty()) {
                throw new RuntimeException("Patient with such id not found: " + patientId);
            }
            Patient patient = optPatient.get();
            Generaliste generalist = (Generaliste) user;
            Consultation consultation = new Consultation(patient,generalist,motive,observations);
            patientDao.retirerFileAttente(patientId);
            return rendeVousDao.save(consultation);
        }catch(Exception e){
            throw e;
        }
    }
    @Override
    public List<Consultation> getAllConsultations(){
        return rendeVousDao.findAll();
    }
    @Override
    public Optional<Consultation> getConsultationById(String id){
        return rendeVousDao.findById(id);
    }
    @Override
    public Consultation updateStatus(String consultationId, StatusRendezVous status){
        Optional<Consultation> optConsultation = rendeVousDao.findById(consultationId);
        if(optConsultation.isEmpty()){
            throw new IllegalArgumentException("Consultation not found with id : " + consultationId);
        }
        Consultation consultation = optConsultation.get();
        consultation.setStatus(status);
        return rendeVousDao.save(consultation);
    }
    @Override
    public Consultation updateDiagnosis(String consultationId,String diagnosis){
        Optional<Consultation> optionalConsultation = rendeVousDao.findById(consultationId);
        if(optionalConsultation.isEmpty()){
            throw new RuntimeException("Consultation not found with id: " + consultationId);
        }
        Consultation consultation = optionalConsultation.get();
        consultation.setDiagnosis(diagnosis);
        return rendeVousDao.save(consultation);
    }
    @Override
    public Consultation updateTreatment(String consultationId,String treatment){
        Optional<Consultation> optionalConsultation = rendeVousDao.findById(consultationId);
        if(optionalConsultation.isEmpty()){
            throw new RuntimeException("Consultation not found with id: " + consultationId);
        }
        Consultation consultation = optionalConsultation.get();
        consultation.setTreatment(treatment);
        return rendeVousDao.save(consultation);
    }
    @Override
    public List<Consultation> getConsultationsGeneralistId(String generalistId){
        return getAllConsultations().stream().filter(c -> c.getGeneralist().getId().equals(generalistId)).collect(Collectors.toList());
    }


}
