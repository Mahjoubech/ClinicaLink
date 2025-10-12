package io.github.Mahjoubech.clinicalink.servlet.admin;

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

@WebServlet("/admin/infirmier")
public class InfirmierServlet extends HttpServlet {

    private MedcenServiceInterface medcenService;
    private MedcenDaoInterface medcenDAO;

    @Override
    public void init() throws ServletException {
        this.medcenService = new MedcenService(medcenDAO);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            List<Medcen> allMedcens = medcenService.findAll();
            List<Medcen> infirmiers = allMedcens.stream()
                    .filter(medcen -> medcen.getRole() == Role.INFIRMER)
                    .collect(Collectors.toList());

            req.setAttribute("infirmiers", infirmiers);
            req.getRequestDispatcher("/views/admin/infirmier.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Erreur lors du chargement des infirmiers: " + e.getMessage());
            req.getRequestDispatcher("/views/admin/infirmier.jsp").forward(req, resp);
        }
    }
}