package io.github.Mahjoubech.clinicalink.servlet;

import io.github.Mahjoubech.clinicalink.dao.MedcenDaoInterface;
import io.github.Mahjoubech.clinicalink.entity.Medcen;
import io.github.Mahjoubech.clinicalink.enums.Role;
import io.github.Mahjoubech.clinicalink.service.MedcenService;
import io.github.Mahjoubech.clinicalink.utils.AdminAuth;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Optional;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private MedcenService medcinService;
    private MedcenDaoInterface medcDao;

    @Override
    public void init() throws ServletException {
        this.medcinService = new MedcenService(medcDao);
        System.out.println("✅ LoginServlet initialized successfully!");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String adminName = "Admin";

        // 1. Check admin login
        if (AdminAuth.authenticate(email, password)) {
            HttpSession session = request.getSession();
            session.setAttribute("adminName", adminName);
            session.setAttribute("admin", true);
            session.setAttribute("adminEmail", email);
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        // 2. Check medical staff login
        try {
            // Find user by email first
            Optional<Medcen> medcenOpt = medcinService.findByEmail(email);

            if (medcenOpt.isPresent()) {
                Medcen medcen = medcenOpt.get();

                // Check password using authenticate method
                if (medcinService.authenticate(email, password)) {
                    HttpSession session = request.getSession();
                    session.setAttribute("user", medcen);
                    session.setAttribute("userRole", medcen.getRole());
                    session.setAttribute("userName", medcen.getNomComplet());
                    session.setAttribute("userEmail", medcen.getEmail());

                    // Redirect based on role
                    String redirectPath = getRedirectPathByRole(medcen.getRole());
                    response.sendRedirect(request.getContextPath() + redirectPath);
                } else {
                    request.setAttribute("error", "Email ou mot de passe incorrect");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "Email ou mot de passe incorrect");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors de l'authentification: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    /**
     * Determine redirect path based on user role
     */
    private String getRedirectPathByRole(Role role) {
        if (role == null) {
            return "/login";
        }

        switch (role) {
            case INFIRMER:
                return "/infirmier/dashboard";
            case GENERALISTE:
                return "/generaliste/dashboard";
            case SPECIALISTE:
                return "/specialiste/dashboard";
            default:
                return "/login";
        }
    }

}