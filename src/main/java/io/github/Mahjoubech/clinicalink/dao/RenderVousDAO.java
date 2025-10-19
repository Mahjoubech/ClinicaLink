package io.github.Mahjoubech.clinicalink.dao;

import io.github.Mahjoubech.clinicalink.entity.Consultation;
import io.github.Mahjoubech.clinicalink.enums.StatusRendezVous;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.EntityTransaction;

import java.util.List;
import java.util.Optional;

public class RenderVousDAO implements RenderVousDaoInterface {

    private final EntityManagerFactory emf;

    public RenderVousDAO(EntityManagerFactory emf){
        this.emf = emf;
    }

    @Override
    public Consultation save(Consultation consultation) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction tx = em.getTransaction();
        try{
            tx.begin();
            Consultation savedConsult;
            if(consultation.getId() == null){
                em.persist(consultation);
                savedConsult = consultation;
            }else{
                if(consultation.getDiagnosis() != null && consultation.getTreatment() != null){
                    consultation.setStatus(StatusRendezVous.TERMINE);
                }
                savedConsult = em.merge(consultation);
            }
            tx.commit();
            return savedConsult;
        }catch(Exception e){
            if(tx.isActive()) tx.rollback();
            throw new RuntimeException("Failed to save consultation");
        }finally {
            em.close();
        }
    }

    @Override
    public void delete(String id) {

    }
    @Override
        public Optional<Consultation> findById(String id) {
        EntityManager em = emf.createEntityManager();
        try{
            return Optional.ofNullable(em.find(Consultation.class,id));
        }finally {
            em.close();
        }
    }

    @Override
    public List<Consultation> findAll() {
        EntityManager em = emf.createEntityManager();
        try{
            return em.createQuery("SELECT c FROM Consultation c ORDER BY c.createdAt DESC",Consultation.class).getResultList();
        }finally {
            em.close();
        }
    }
    @Override
    public  Consultation update(Consultation t){
        return null;
    }
}
