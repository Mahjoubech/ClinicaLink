package io.github.Mahjoubech.clinicalink.config;

import io.github.Mahjoubech.clinicalink.dao.MedcenDAO;
import io.github.Mahjoubech.clinicalink.dao.PatientDAO;
import io.github.Mahjoubech.clinicalink.entity.Medcen;
import io.github.Mahjoubech.clinicalink.enums.Role;
import io.github.Mahjoubech.clinicalink.service.MedcenService;
import io.github.Mahjoubech.clinicalink.service.PatientService;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Persistence;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import org.mindrot.jbcrypt.BCrypt;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
@WebListener
public class AppBoostraper  implements ServletContextListener {
    private ScheduledExecutorService scheduler;
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // 1️⃣ Get ServletContext
        ServletContext ctx = sce.getServletContext();
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("clinicalink");
        MedcenDAO medcenDAO = new MedcenDAO(emf);
        PatientDAO patientDAO = new PatientDAO();

        MedcenService medcenService = new MedcenService(medcenDAO);
            PatientService patientService = new PatientService();

        // 4️⃣ Create and store AppContext
            AppContext appContext = new AppContext(emf, medcenService, patientService);
        ctx.setAttribute("appContext", appContext);

        // 5️⃣ Seed initial data (optional)
        seed(emf);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        AppContext appContext = (AppContext) sce.getServletContext().getAttribute("appContext");
        if (appContext != null) appContext.close();
    }

    private void seed(EntityManagerFactory emf) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            // Check if admin already exists
            long count = (long) em.createQuery("SELECT COUNT(m) FROM Medcen m WHERE m.role = :role")
                    .setParameter("role", Role.INFIRMER)
                    .getSingleResult();

            if (count == 0) {
                // Create default admin
                Medcen admin = new Medcen(
                        "admin-001",
                        "Administrateur Système",
                        "admin@clinicalink.ma",
                        "0612345678",
                        BCrypt.hashpw("admin123", BCrypt.gensalt()),
                        Role.INFIRMER
                );
                em.persist(admin);
            }

            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }
}
