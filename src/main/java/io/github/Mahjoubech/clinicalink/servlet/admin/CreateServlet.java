package io.github.Mahjoubech.clinicalink.servlet.admin;

import io.github.Mahjoubech.clinicalink.dao.MedcenDAO;
import io.github.Mahjoubech.clinicalink.dao.MedcenDaoInterface;
import io.github.Mahjoubech.clinicalink.dto.MedcenDTO;
import io.github.Mahjoubech.clinicalink.service.MedcenService;
import io.github.Mahjoubech.clinicalink.enums.Role;
import io.github.Mahjoubech.clinicalink.service.MedcenServiceInterface;
import io.github.Mahjoubech.clinicalink.utils.Validateur;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/admin/create")
public class CreateServlet extends HttpServlet {

    private MedcenServiceInterface medcinService;
    private MedcenDaoInterface medcDao;
    @Override
    public void init() throws ServletException {
        this.medcDao = new MedcenDAO();
        this.medcinService = new MedcenService(medcDao); // Initialize here
        System.out.println("✅ CreateServlet initialized successfully!");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Get parameters from form
        String nom = req.getParameter("nom");
        String prenom = req.getParameter("prenom");
        String email = req.getParameter("email");
        String tele = req.getParameter("tele");
        String password = req.getParameter("password");
        String confirmpassword = req.getParameter("confirmpassword");
        String roleStr = req.getParameter("role");
        String specialty = req.getParameter("specialty");
        String rate = req.getParameter("rate");

        String nomComplet = (nom != null ? nom : "") + " " + (prenom != null ? prenom : "");

        // Store form data for repopulation
        req.setAttribute("nom", nom);
        req.setAttribute("prenom", prenom);
        req.setAttribute("email", email);
        req.setAttribute("tele", tele);
        req.setAttribute("role", roleStr);
        req.setAttribute("specialty", specialty);
        req.setAttribute("rate", rate);

        // Validate fields
        Map<String, String> errors = new HashMap<>();

        if (nom == null || nom.trim().isEmpty()) {
            errors.put("nom", "Le nom est obligatoire");
        } else if (nom.length() < 2) {
            errors.put("nom", "Le nom doit contenir au moins 2 caractères");
        }

        // Validate prenom
        if (prenom == null || prenom.trim().isEmpty()) {
            errors.put("prenom", "Le prénom est obligatoire");
        } else if (prenom.length() < 2) {
            errors.put("prenom", "Le prénom doit contenir au moins 2 caractères");
        }

        // Validate tele
        if (tele == null || tele.trim().isEmpty()) {
            errors.put("tele", "Le numéro de téléphone est obligatoire");
        } else if (!Validateur.isValidTele(tele)) {
            errors.put("tele", "Format de numéro de téléphone invalide");
        } else if (medcinService.teleExit(tele)) {
            errors.put("tele", "Ce numéro de téléphone est déjà utilisé");
        }

        // Validate email
        if (email == null || email.trim().isEmpty()) {
            errors.put("email", "L'email est obligatoire");
        } else if (!Validateur.isValidEmail(email)) {
            errors.put("email", "Format d'email invalide");
        } else if (medcinService.emailExiste(email)) {
            errors.put("email", "Cet email est déjà utilisé");
        }

        // Validate password
        if (password == null || password.trim().isEmpty()) {
            errors.put("password", "Le mot de passe est obligatoire");
        } else if (password.length() < 6) {
            errors.put("password", "Le mot de passe doit contenir au moins 6 caractères");
        }

        // Validate confirm password
        if (confirmpassword == null || confirmpassword.trim().isEmpty()) {
            errors.put("confirmpassword", "Veuillez confirmer le mot de passe");
        } else if (!password.equals(confirmpassword)) {
            errors.put("confirmpassword", "Les mots de passe ne correspondent pas");
        }

        // Validate role
        if (roleStr == null || roleStr.trim().isEmpty()) {
            errors.put("role", "Veuillez sélectionner un rôle");
        } else {
            try {
                Role role = Role.valueOf(roleStr);
                if (role == Role.SPECIALISTE) {
                    if (specialty == null || specialty.trim().isEmpty()) {
                        errors.put("specialty", "La spécialité est obligatoire pour les spécialistes");
                    }

                    if (rate == null || rate.trim().isEmpty()) {
                        errors.put("rate", "Le tarif est obligatoire pour les spécialistes");
                    } else {
                        try {
                            double tarif = Double.parseDouble(rate);
                            if (tarif <= 0) {
                                errors.put("rate", "Le tarif doit être supérieur à 0");
                            }
                        } catch (NumberFormatException e) {
                            errors.put("rate", "Le tarif doit être un nombre valide");
                        }
                    }
                }
            } catch (IllegalArgumentException e) {
                errors.put("role", "Rôle invalide");
            }
        }

        // If there are errors, return to form with error messages
        if (!errors.isEmpty()) {
            req.setAttribute("errors", errors);
            req.getRequestDispatcher("/views/admin/dashboard.jsp").forward(req, resp);
            return;
        }

        try {
            // Create DTO and register user
            MedcenDTO med = new MedcenDTO(
                    nomComplet.trim(),
                    email,
                    tele,
                    password,
                    Role.valueOf(roleStr)
            );

            // Set specialist fields if applicable
            if (Role.valueOf(roleStr) == Role.SPECIALISTE) {
                med.setSpecialite(specialty);
                med.setTarif(Double.parseDouble(rate)); // Fixed method name
            }

            boolean success = medcinService.registerMedcen(med);

            if (success) {
                req.setAttribute("success", "Utilisateur créé avec succès!");
                // Clear form data
                req.removeAttribute("nom");
                req.removeAttribute("prenom");
                req.removeAttribute("email");
                req.removeAttribute("tele");
                req.removeAttribute("role");
                req.removeAttribute("specialty");
                req.removeAttribute("rate");
            } else {
                req.setAttribute("error", "Erreur lors de la création de l'utilisateur");
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Erreur technique: " + e.getMessage());
        }

        req.getRequestDispatcher("/views/admin/dashboard.jsp").forward(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/views/admin/dashboard.jsp").forward(req, resp);
    }
}