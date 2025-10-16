package io.github.Mahjoubech.clinicalink.servlet.auth;

import io.github.Mahjoubech.clinicalink.config.AppContext;
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

    @Override
    public void init() throws ServletException {
        AppContext appContext = (AppContext) getServletContext().getAttribute("appContext");
        this.medcinService = appContext.getMedcenService();
    }
   @Override
   protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
         req.getRequestDispatcher("login.jsp").forward(req, resp);
   }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleLogin(request, response);
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            if (AdminAuth.authenticate(email, password)) {
                HttpSession session = request.getSession();
                session.setAttribute("currentUser", createAdminUser(email));
                response.sendRedirect(request.getContextPath() + "/admin/");
                return;
            }
            Optional<Medcen> medcenOpt = medcinService.findByEmail(email);

            if (medcenOpt.isPresent() && medcinService.authenticate(email, password)) {
                Medcen user = medcenOpt.get();
                HttpSession session = request.getSession();
                session.setAttribute("currentUser", user);
                String redirectPath = "/" + user.getRole().toString().toLowerCase() + "/";
                response.sendRedirect(request.getContextPath() + redirectPath);
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
     * Create a mock admin user object for session consistency
     */
    private Object createAdminUser(String email) {
        // You might want to create a proper Admin class for type safety
        // For now, returning a simple representation
        return new Object() {
            public String getRole() { return "ADMIN"; }
            public String getEmail() { return email; }
            public String getName() { return "Admin"; }

            @Override
            public String toString() {
                return "Admin{email='" + email + "'}";
            }
        };
    }
}