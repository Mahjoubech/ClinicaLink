package io.github.Mahjoubech.clinicalink.dao;

import io.github.Mahjoubech.clinicalink.entity.ListAttente;
import io.github.Mahjoubech.clinicalink.entity.Patient;
import io.github.Mahjoubech.clinicalink.entity.VitalSigns;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;

import java.util.List;
import java.util.Optional;

public class PatientDAO implements PatientDaoInterface {
    private EntityManagerFactory emf;
    public PatientDAO(EntityManagerFactory emf) {
        this.emf = emf;
    }
    @Override
    public Patient save(Patient patient) {
        try (EntityManager em = emf.createEntityManager()) {
            em.getTransaction().begin();
            em.persist(patient);
            em.getTransaction().commit();
            return patient;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Erreur lors de l’enregistrement du patient : " + e.getMessage(), e);
        }
    }
    @Override
    public Patient update(Patient patient) {
        try (EntityManager em = emf.createEntityManager()) {
            em.getTransaction().begin();
            Patient updatedPatient = em.merge(patient);
            em.getTransaction().commit();
            return updatedPatient;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Erreur lors de la mise à jour du patient : " + e.getMessage(), e);
        }
    }
    @Override
    public void delete(String id) {
        try (EntityManager em = emf.createEntityManager()) {
            em.getTransaction().begin();

            Patient patient = em.find(Patient.class, id);
            if (patient != null) {
                // First, delete all related vital signs
                List<VitalSigns> vitalSigns = em.createQuery(
                                "SELECT vs FROM VitalSigns vs WHERE vs.patient.id = :patientId", VitalSigns.class)
                        .setParameter("patientId", id)
                        .getResultList();

                for (VitalSigns vs : vitalSigns) {
                    em.remove(vs);
                }

                // You should uncomment the code below or delete the related queue entry here if the ListAttente entity exists.
                /* try {
                    // Assuming ListAttente has a relationship that allows lookup by patient ID
                    TypedQuery<ListAttente> queueQuery = em.createQuery(
                        "SELECT l FROM ListAttente l WHERE l.patient.id = :pid", ListAttente.class);
                    queueQuery.setParameter("pid", id);
                    List<ListAttente> queueResults = queueQuery.getResultList();
                    for (ListAttente entry : queueResults) {
                        em.remove(entry);
                    }
                } catch (Exception ex) {
                    // Ignore if no queue entry exists
                    System.out.println("No queue entry found for patient: " + id);
                }
                */

                em.remove(patient);
            }

            em.getTransaction().commit();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Erreur lors de la suppression du patient : " + e.getMessage(), e);
        }
    }

    @Override
    public Optional<Patient> findById(String id) {
        try (EntityManager em = emf.createEntityManager()) {
            // Use a JPQL query to EAGERLY FETCH the vitalSigns collection
            TypedQuery<Patient> query = em.createQuery(
                    "SELECT p FROM Patient p LEFT JOIN FETCH p.vitalSigns vs WHERE p.id = :id", Patient.class);
            query.setParameter("id", id);

            // This handles the case where multiple vitalSigns exist and would return duplicates.
            // It fetches a list and checks for a single unique result.
            List<Patient> results = query.getResultList();

            if (results.isEmpty()) {
                return Optional.empty();
            }

            // Use the first (and only unique) result from the list
            Patient patient = results.get(0);

            // OPTIONAL: Manually trigger loading of other lazily fetched collections here
            // if you were also accessing them in the JSP.
            // patient.getOtherLazyCollection().size();

            return Optional.of(patient);
        } catch (Exception e) {
            e.printStackTrace();
            return Optional.empty();
        }
    }

    @Override
    public List<Patient> findAll() {
        try (EntityManager em = emf.createEntityManager()) {
            TypedQuery<Patient> query = em.createQuery(
                    "SELECT p FROM Patient p ORDER BY p.nameComplet", Patient.class);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Erreur lors de la récupération de tous les patients : " + e.getMessage(), e);
        }
    }
    @Override
    public Optional<Patient> trouverParNumeroSecuriteSociale(String numeroSecuriteSociale) {
        try (EntityManager em = emf.createEntityManager()) {
            String cleanSsn = numeroSecuriteSociale.trim().toUpperCase();
            System.out.println("DEBUG DAO: Searching SSN: '" + cleanSsn + "'");

            TypedQuery<Patient> query = em.createQuery(
                    "SELECT p FROM Patient p WHERE p.socialSecurityNumber = :ssn", Patient.class);
            query.setParameter("ssn", cleanSsn);
            Patient result = query.getSingleResult();
            System.out.println("DEBUG DAO: Found patient - ID: " + result.getId() + ", SSN: " + result.getSocialSecurityNumber());
            return Optional.of(result);
        } catch (NoResultException e) {
            System.out.println("DEBUG DAO: No patient found with SSN: " + numeroSecuriteSociale);
            return Optional.empty();
        } catch (Exception e) {
            System.out.println("DEBUG DAO: Error searching for SSN: " + e.getMessage());
            e.printStackTrace();
            return Optional.empty();
        }
    }    @Override
    public List<Patient> trouverParNomComplet(String nomComplet) {
        try (EntityManager em = emf.createEntityManager()) {
            TypedQuery<Patient> query = em.createQuery(
                    "SELECT p FROM Patient p WHERE LOWER(p.nameComplet) LIKE LOWER(:nom)", Patient.class);
            query.setParameter("nom", "%" + nomComplet + "%");
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Erreur lors de la recherche par nom complet : " + e.getMessage(), e);
        }
    }

    @Override
    public List<Patient> obtenirPatientsAujourdhui() {
        try (EntityManager em = emf.createEntityManager()) {
            TypedQuery<Patient> query = em.createQuery(
                    "SELECT DISTINCT p FROM Patient p JOIN p.vitalSigns v WHERE DATE(v.createdAt) = CURRENT_DATE",
                    Patient.class);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Erreur lors de la récupération des patients du jour : " + e.getMessage(), e);
        }
    }

    @Override
    public Patient ajouterSignesVitaux(String patientId, VitalSigns signesVitaux) {
        try (EntityManager em = emf.createEntityManager()) {
            em.getTransaction().begin();
            Patient patient = em.find(Patient.class, patientId);
            if (patient == null)
                throw new RuntimeException("Patient introuvable : " + patientId);
            signesVitaux.setPatient(patient);
            em.persist(signesVitaux);
            em.getTransaction().commit();
            return patient;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Erreur lors de l’ajout des signes vitaux : " + e.getMessage(), e);
        }
    }

    @Override
    public void ajouterFileAttente(String patientId) {
        try (EntityManager em = emf.createEntityManager()) {
            em.getTransaction().begin();
            Patient patient = em.find(Patient.class, patientId);
            if (patient != null) {
                TypedQuery<ListAttente> query = em.createQuery(
                        "SELECT l FROM ListAttente l WHERE l.patient.id = :pid", ListAttente.class);
                query.setParameter("pid", patientId);
                List<ListAttente> existing = query.getResultList();

                if (existing.isEmpty()) {
                    ListAttente attente = new ListAttente(patient);
                    em.persist(attente);
                } else {
                    System.out.println("Le patient est déjà dans la file d’attente.");
                }
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Erreur lors de l’ajout à la file d’attente : " + e.getMessage(), e);
        }
    }

    @Override
    public void retirerFileAttente(String patientId) {
        try (EntityManager em = emf.createEntityManager()) {
            em.getTransaction().begin();
            TypedQuery<ListAttente> query = em.createQuery(
                    "SELECT l FROM ListAttente l WHERE l.patient.id = :pid", ListAttente.class);
            query.setParameter("pid", patientId);
            List<ListAttente> results = query.getResultList();

            for (ListAttente attente : results) {
                em.remove(attente);
            }

            em.getTransaction().commit();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Erreur lors du retrait de la file d’attente : " + e.getMessage(), e);
        }
    }

    @Override
    public List<Patient> obtenirPatientsFileAttente() {
        try (EntityManager em = emf.createEntityManager()) {
            // NOTE: This query returns ListAttente objects, but the return type is List<Patient>.
            // It should be fixed to SELECT l.patient FROM ListAttente l
            TypedQuery<Patient> query = em.createQuery(
                    "SELECT l FROM ListAttente l ORDER BY l.arrivalTime ASC", Patient.class);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Erreur lors de la récupération des patients en file d’attente : " + e.getMessage(), e);
        }
    }
}