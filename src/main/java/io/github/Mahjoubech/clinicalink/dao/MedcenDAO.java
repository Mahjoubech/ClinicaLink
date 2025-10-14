package io.github.Mahjoubech.clinicalink.dao;

import io.github.Mahjoubech.clinicalink.entity.Medcen;
import io.github.Mahjoubech.clinicalink.enums.Role;
import io.github.Mahjoubech.clinicalink.utils.PasswordUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;

import java.util.List;
import java.util.Optional;

public class MedcenDAO implements MedcenDaoInterface {
    private EntityManagerFactory emf;

    public MedcenDAO(EntityManagerFactory emf) {
        this.emf = emf;
    }
    @Override
    public void save(Medcen med) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            if (med.getPassword() != null && !PasswordUtil.isHashed(med.getPassword())) {
                String hashedPassword = PasswordUtil.hashPassword(med.getPassword());
                med.setPassword(hashedPassword);
            }
            em.persist(med);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            throw new RuntimeException("Error saving Medcen: " + e.getMessage(), e);
        }
    }

    @Override
    public void update(Medcen med) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(med);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            throw new RuntimeException("Error updating Medcen: " + e.getMessage(), e);
        }
    }

    @Override
    public void delete(Medcen med) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            Medcen managedMed = em.merge(med); // Ensure the entity is managed
            em.remove(managedMed);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            throw new RuntimeException("Error deleting Medcen: " + e.getMessage(), e);
        }
    }

    @Override
    public Optional<Medcen> findById(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            Medcen medcen = em.find(Medcen.class, id);
            return Optional.ofNullable(medcen);
        } catch (Exception e) {
            e.printStackTrace();
            return Optional.empty();
        }
    }

    @Override
    public Optional<Medcen> findByEmail(String email) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Medcen> query = em.createQuery(
                    "SELECT m FROM Medcen m WHERE m.email = :email", Medcen.class);
            query.setParameter("email", email);
            Medcen medcen = query.getSingleResult();
            return Optional.of(medcen);
        } catch (NoResultException e) {
            return Optional.empty();
        } catch (Exception e) {
            e.printStackTrace();
            return Optional.empty();
        }
    }

    @Override
    public List<Medcen> findAll() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Medcen> query = em.createQuery(
                    "SELECT m FROM Medcen m ORDER BY m.nomComplet", Medcen.class);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error finding all Medcens: " + e.getMessage(), e);
        }
    }

    @Override
    public List<Medcen> findByRole(Role role) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Medcen> query = em.createQuery(
                    "SELECT m FROM Medcen m WHERE m.role = :role ORDER BY m.nomComplet", Medcen.class);
            query.setParameter("role", role);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error finding Medcens by role: " + e.getMessage(), e);
        }
    }

    @Override
    public boolean emailExists(String email) {
        return findByEmail(email).isPresent();
    }



    public long countByRole(Role role) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(m) FROM Medcen m WHERE m.role = :role", Long.class);
            query.setParameter("role", role);
            return query.getSingleResult();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
}