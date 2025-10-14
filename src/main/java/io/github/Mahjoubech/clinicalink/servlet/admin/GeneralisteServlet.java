package io.github.Mahjoubech.clinicalink.servlet.admin;

import io.github.Mahjoubech.clinicalink.config.AppContext;
import io.github.Mahjoubech.clinicalink.dao.MedcenDAO;
import io.github.Mahjoubech.clinicalink.dao.MedcenDaoInterface;
import io.github.Mahjoubech.clinicalink.entity.Medcen;
import io.github.Mahjoubech.clinicalink.enums.Role;
import io.github.Mahjoubech.clinicalink.service.MedcenService;
import io.github.Mahjoubech.clinicalink.service.MedcenServiceInterface;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/admin/generaliste")
public class GeneralisteServlet extends HttpServlet {


    private MedcenServiceInterface medcenService;
    @Override
    public void init() throws ServletException {
        AppContext appContext = (AppContext) getServletContext().getAttribute("appContext");
        this.medcenService = appContext.getMedcenService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            // Get all generalistes using Stream API
            List<Medcen> allMedcens = medcenService.findAll();
            List<Medcen> generalistes = allMedcens.stream()
                    .filter(medcen -> medcen.getRole() == Role.GENERALISTE)
                    .collect(Collectors.toList());

            req.setAttribute("generalistes", generalistes);
            req.getRequestDispatcher("/views/admin/generaliste.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Erreur lors du chargement des généralistes: " + e.getMessage());
            req.getRequestDispatcher("/views/admin/generaliste.jsp").forward(req, resp);
        }
    }
}