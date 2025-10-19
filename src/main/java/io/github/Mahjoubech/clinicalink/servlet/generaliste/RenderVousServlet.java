package io.github.Mahjoubech.clinicalink.servlet.generaliste;

import io.github.Mahjoubech.clinicalink.entity.Consultation;
import io.github.Mahjoubech.clinicalink.entity.Generaliste;
import io.github.Mahjoubech.clinicalink.entity.Patient;
import io.github.Mahjoubech.clinicalink.enums.StatusRendezVous;
import io.github.Mahjoubech.clinicalink.service.PatientService;
import io.github.Mahjoubech.clinicalink.service.PatientServiceInterface;
import io.github.Mahjoubech.clinicalink.service.RenderVousServiceInterface;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Optional;
import java.util.List;
@WebServlet("/generalist/*")
public class RenderVousServlet extends HttpServlet {
    private RenderVousServiceInterface renderVousService;
    private PatientServiceInterface patientService; //

    @Override
    public void init() throws ServletException {
        Object appContext = getServletContext().getAttribute("appContext");
        if (appContext != null) {
            try {
                this.renderVousService = (RenderVousServiceInterface) appContext.getClass().getMethod("getRenderVousService").invoke(appContext);
                this.patientService = (PatientServiceInterface) appContext.getClass().getMethod("getPatientService").invoke(appContext);
            } catch (Exception e) {
                throw new ServletException("Échec de l'initialisation des services dans AppContext", e);
            }
        } else {
            throw new ServletException("Le contexte de l'application (appContext) n'est pas défini.");
        }
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String action = request.getPathInfo();
        if (action == null) {
            action = "/";
        }

        switch (action) {
            case "/":
                showDashboard(request, response);
                break;
            case "/consultation/create":
                createConsultation(request, response);
                break;
            case "/consultations":
                showConsultations(request, response);
                break;
            default:
                if (action.startsWith("/consultation/")) {
                    String id = action.substring(14);
                    showConsultation(request, response, id);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
                break;
        }
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String action = request.getPathInfo();
        if (action == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        switch (action) {
            case "/consultation/create":
                registerConsultation(request, response);
                break;
            case "/consultation/update-status":
                updateStatus(request, response);
                break;
            case "/consultation/update-diagnosis":
                updateDiagnosis(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }

    // --- Méthodes de la Servlet ---

    private void notificationMessages(HttpServletRequest request) {
        String success = (String) request.getSession().getAttribute("success");
        String error = (String) request.getSession().getAttribute("error");
        if (success != null) {
            request.setAttribute("success", success);
            request.getSession().removeAttribute("success");
        }
        if (error != null) {
            request.setAttribute("error", error);
            request.getSession().removeAttribute("error");
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        notificationMessages(request);
        // Supposons que patientService a une méthode getQueuePatients()
        try {
            List<?> queue = (List<?>) patientService.getClass().getMethod("getQueuePatients").invoke(patientService);
            request.setAttribute("queue", queue);
        } catch (Exception e) {
            // Gérer l'exception si la méthode n'existe pas ou échoue
            request.setAttribute("error", "Échec du chargement de la file d'attente : " + e.getMessage());
        }
        request.getRequestDispatcher("/pages/generalist/dashboard.jsp").forward(request, response);
    }

    private void createConsultation(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        notificationMessages(request);
        try {
            String patientIdStr = request.getParameter("patientId");
            Optional<?> optPatient = (Optional<?>) patientService.getClass().getMethod("findById", String.class).invoke(patientService, patientIdStr);
            if (optPatient.isEmpty()) {
                request.setAttribute("error", "Patient non trouvé avec l'identifiant : " + patientIdStr); // Message en français
            } else {
                request.setAttribute("patient", optPatient.get());
            }
        } catch (Exception e) {
            request.setAttribute("error", "Paramètre patientId manquant ou invalide."); // Message en français
        }
        request.getRequestDispatcher("/pages/generalist/consultCreate.jsp").forward(request, response);
    }

    private void registerConsultation(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        // Les services utilisent String pour les IDs, on prend les paramètres en String
        String patientIDStr = request.getParameter("id"); // Le paramètre s'appelle 'id' dans le formulaire
        Generaliste generalist = (Generaliste) request.getSession().getAttribute("currentUser");
        String motive = request.getParameter("motive");
        String observations = request.getParameter("observations");

        try {
            if (generalist == null) {
                throw new RuntimeException("Généraliste non connecté.");
            }
            if (patientIDStr == null || patientIDStr.isEmpty()) {
                throw new IllegalArgumentException("L'identifiant du patient est manquant.");
            }

            Consultation consultation = renderVousService.createConsultation(
                    patientIDStr,
                    generalist.getId(),
                    motive,
                    observations);

            request.getSession().setAttribute("success", "Consultation créée avec succès pour le patient avec SSN : " + consultation.getPatient().getSocialSecurityNumber());
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Échec de l'enregistrement de la consultation : " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/generalist/");
    }

    private void showConsultations(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        Generaliste generalist = (Generaliste) request.getSession().getAttribute("currentUser");
        if (generalist != null) {
            request.setAttribute("consultations", renderVousService.getConsultationsGeneralistId(generalist.getId()));
        } else {
            request.setAttribute("error", "Veuillez vous connecter en tant que Généraliste.");
        }
        request.getRequestDispatcher("/pages/generalist/consultations.jsp").forward(request, response);
    }

    private void showConsultation(HttpServletRequest request, HttpServletResponse response, String id)
            throws IOException, ServletException {
        notificationMessages(request);
        Optional<Consultation> optConsultation = renderVousService.getConsultationById(id);

        if (optConsultation.isEmpty()) {
            request.setAttribute("error", "Consultation non trouvée avec l'identifiant : " + id); // Message en français
        } else {

            try {
                Object availableMedicalActs = renderVousService.getClass().getMethod("getAllAvailableMedicalActs", String.class).invoke(renderVousService, id);
                request.setAttribute("availableMedicalActs", availableMedicalActs);
            } catch (Exception e) {
                request.setAttribute("error", "Échec du chargement des actes médicaux disponibles : " + e.getMessage());
            }

            request.setAttribute("consultation", optConsultation.get());
        }
        request.getRequestDispatcher("/pages/generalist/consultation.jsp").forward(request, response);
    }

    private void updateStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        String consultationId = request.getParameter("consultationId");
        String status = request.getParameter("status");
        try {
            StatusRendezVous consultationStatus = StatusRendezVous.valueOf(status);
            renderVousService.updateStatus(consultationId, consultationStatus);
            request.getSession().setAttribute("success", "Statut mis à jour avec succès à " + status + " !"); // Message en français
            response.sendRedirect(request.getContextPath() + "/generalist/consultation/" + consultationId);
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Échec de la mise à jour du statut : " + e.getMessage()); // Message en français
            response.sendRedirect(request.getContextPath() + "/generalist/consultation/" + consultationId);
        }
    }

    private void updateDiagnosis(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        String consultationId = request.getParameter("consultationId");
        try {
            renderVousService.updateDiagnosis(consultationId, request.getParameter("diagnosis"));
            request.getSession().setAttribute("success", "Diagnostic de la consultation mis à jour avec succès !"); // Message en français
            response.sendRedirect(request.getContextPath() + "/generalist/consultation/" + consultationId);
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Échec de la mise à jour du diagnostic de la consultation : " + e.getMessage()); // Message en français
            response.sendRedirect(request.getContextPath() + "/generalist/consultation/" + consultationId);
        }
    }


}