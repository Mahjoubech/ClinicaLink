package io.github.Mahjoubech.clinicalink.service;

import io.github.Mahjoubech.clinicalink.dao.PatientDAO;
import io.github.Mahjoubech.clinicalink.dao.PatientDaoInterface;
import io.github.Mahjoubech.clinicalink.entity.Patient;
import io.github.Mahjoubech.clinicalink.entity.VitalSigns;

import java.util.List;
import java.util.Optional;

public class PatientService implements PatientServiceInterface {

    private final PatientDaoInterface patientDAO;

    public PatientService(PatientDaoInterface patientDao) {
        this.patientDAO = patientDao;
    }

    // ... (Other methods remain unchanged)

    @Override
    public Optional<Patient> findPatientBySsn(String ssn) {
        try {
            String standardizedSsn = ssn.trim().toUpperCase();
            System.out.println("DEBUG: Searching for SSN: " + standardizedSsn);
            return patientDAO.trouverParNumeroSecuriteSociale(standardizedSsn);
        } catch (Exception e) {
            e.printStackTrace();
            return Optional.empty();
        }
    }

    // ... (The rest of the class is unchanged)

    @Override
    public Patient registerPatient(Patient patient, VitalSigns vitalSigns) {
        try {
            // It's crucial here that patient.getSocialSecurityNumber() is already uppercase/trimmed
            // from the InfirmierServlet before being saved.
            Patient savedPatient = patientDAO.save(patient);
            if (vitalSigns != null) {
                patientDAO.ajouterSignesVitaux(savedPatient.getId(), vitalSigns);
            }
            return savedPatient;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Erreur lors de l’enregistrement du patient : " + e.getMessage(), e);
        }
    }

    // ... (Rest of the original PatientService class)
    @Override
    public Patient updatePatient(Patient patient) {
        try {
            return patientDAO.update(patient);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Erreur lors de la mise à jour du patient : " + e.getMessage(), e);
        }
    }
    @Override
    public boolean deletePatient(String patientId) {
        try {
            patientDAO.delete(patientId);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Erreur lors de la suppression du patient : " + e.getMessage(), e);
        }
    }
    // ... (The rest of the class)
    @Override
    public List<Patient> findPatientsByFullName(String fullName) {
        try {
            return patientDAO.trouverParNomComplet(fullName);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Erreur lors de la recherche par nom complet : " + e.getMessage(), e);
        }
    }

    @Override
    public List<Patient> getTodayPatients() {
        try {
            return patientDAO.obtenirPatientsAujourdhui();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Erreur lors de la récupération des patients du jour : " + e.getMessage(), e);
        }
    }

    @Override
    public List<Patient> getAllPatients() {
        try {
            return patientDAO.findAll();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Erreur lors de la récupération de tous les patients : " + e.getMessage(), e);
        }
    }

    @Override
    public List<Patient> getQueuePatients() {
        try {
            return patientDAO.obtenirPatientsFileAttente();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Erreur lors de la récupération des patients en file d’attente : " + e.getMessage(), e);
        }
    }

    @Override
    public void addToQueue(String patientId) {
        try {
            patientDAO.ajouterFileAttente(patientId);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Erreur lors de l’ajout à la file d’attente : " + e.getMessage(), e);
        }
    }

    @Override
    public void removeFromQueue(String patientId) {
        try {
            patientDAO.retirerFileAttente(patientId);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Erreur lors du retrait de la file d’attente : " + e.getMessage(), e);
        }
    }

    @Override
    public Patient addVitalSigns(String patientId, VitalSigns vitalSigns) {
        try {
            return patientDAO.ajouterSignesVitaux(patientId, vitalSigns);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Erreur lors de l’ajout des signes vitaux : " + e.getMessage(), e);
        }
    }

    @Override
    public Optional<Patient> findPatientById(String id) {
        try {
            return patientDAO.findById(id);
        } catch (Exception e) {
            e.printStackTrace();
            return Optional.empty();
        }
    }
    @Override
    public boolean teleExit(String tele) {
        try {
            return patientDAO.findAll().stream()
                    .anyMatch(patient -> patient.getPhone().equals(tele));
        }catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Erreur lors de la vérification du téléphone : " + e.getMessage(), e);
        }
    }
    @Override
    public boolean emailExiste(String email) {
        try {
            return patientDAO.findAll().stream()
                    .anyMatch(patient -> patient.getEmail().equals(email));
        }catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Erreur lors de la vérification de l'email : " + e.getMessage(), e);
        }
    }
}