package io.github.Mahjoubech.clinicalink.config;

import io.github.Mahjoubech.clinicalink.dao.MedcenDAO;
import io.github.Mahjoubech.clinicalink.dao.PatientDAO;
import io.github.Mahjoubech.clinicalink.dao.RenderVousDAO;
import io.github.Mahjoubech.clinicalink.entity.Medcen;
import io.github.Mahjoubech.clinicalink.enums.Role;
import io.github.Mahjoubech.clinicalink.service.MedcenService;
import io.github.Mahjoubech.clinicalink.service.PatientService;
import io.github.Mahjoubech.clinicalink.service.RenderVousService;
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
        PatientDAO patientDAO = new PatientDAO(emf);
        RenderVousDAO rendezVousDAO = new RenderVousDAO(emf);
        MedcenService medcenService = new MedcenService(medcenDAO);
        PatientService patientService = new PatientService(patientDAO);
        RenderVousService renderVousService = new RenderVousService(rendezVousDAO , patientDAO,medcenDAO);
            AppContext appContext = new AppContext(emf, medcenService, patientService , renderVousService);
        ctx.setAttribute("appContext", appContext);

    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        AppContext appContext = (AppContext) sce.getServletContext().getAttribute("appContext");
        if (appContext != null) appContext.close();
    }
}
