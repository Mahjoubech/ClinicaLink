package io.github.Mahjoubech.clinicalink.dao;

import io.github.Mahjoubech.clinicalink.entity.Patient;
import io.github.Mahjoubech.clinicalink.entity.VitalSigns;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface PatientDaoInterface extends CrudInterface<Patient> {
    Optional<Patient> trouverParNumeroSecuriteSociale(String numeroSecuriteSociale);
    List<Patient> trouverParNomComplet(String nomComplet);
    List<Patient> obtenirPatientsAujourdhui();

    Patient ajouterSignesVitaux(String patientId, VitalSigns signesVitaux);

    void ajouterFileAttente(String patientId);
    void retirerFileAttente(String patientId);
    List<Patient> obtenirPatientsFileAttente();
    }


