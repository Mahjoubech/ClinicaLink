package io.github.Mahjoubech.clinicalink.utils;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
public class JPAConnection {
        private static JPAConnection instance;
        private EntityManagerFactory emf;
        private JPAConnection() {
            try {
                emf = Persistence.createEntityManagerFactory("clinicalink");
                System.out.println("EntityManagerFactory created successfully!");
            } catch (Exception e) {
                System.out.println("Error creating EntityManagerFactory:");
                e.printStackTrace();
            }
        }

        public static JPAConnection getInstance() {
            if (instance == null) {
                instance = new JPAConnection();
            }
            return instance;
        }

        public EntityManager getEntityManager() {
            if (emf != null) {
                return emf.createEntityManager();
            } else {
                throw new IllegalStateException("EntityManagerFactory not initialized.");
            }
        }
        public void close() {
            if (emf != null) {
                emf.close();
            }
        }
    }

