package io.github.Mahjoubech.clinicalink.config;


import io.github.Mahjoubech.clinicalink.service.MedcenService;
import io.github.Mahjoubech.clinicalink.service.PatientService;
import jakarta.persistence.EntityManagerFactory;
import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public class AppContext {
    private final EntityManagerFactory emf;
    private final MedcenService medcenService;
    private final PatientService patientService;

    public void close() {
        if (emf != null && emf.isOpen()) emf.close();
    }
}