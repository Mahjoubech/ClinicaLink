package io.github.Mahjoubech.clinicalink.servlet.infirmer;

import io.github.Mahjoubech.clinicalink.config.AppContext;
import io.github.Mahjoubech.clinicalink.entity.Patient;
import io.github.Mahjoubech.clinicalink.entity.VitalSigns;
import io.github.Mahjoubech.clinicalink.service.PatientServiceInterface;
import io.github.Mahjoubech.clinicalink.utils.Helper;
import io.github.Mahjoubech.clinicalink.utils.Validateur;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.time.Period;
import java.util.List;
import java.util.Optional;

// NOTE: You must uncomment the @WebServlet annotation for this servlet to work.
// Example: @WebServlet("/infirmer/*")
public class InfirmierServlet extends HttpServlet {
    private PatientServiceInterface patientService;

    @Override
    public void init() throws ServletException {
        AppContext appContext = (AppContext) getServletContext().getAttribute("appContext");
        this.patientService = appContext.getPatientService();
        System.out.println("✅ InfirmierServlet initialized successfully!");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();
        if (action == null) action = "/";
        switch (action) {
            case "/":
                showDashboard(request, response);
                break;
            case "/listAtt":
                showListAtt(request, response);
                break;
            default:
                if (action.startsWith("/search/")) {
                    String idPatient = action.substring(8);
                    searchPatient(request, response, idPatient);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();
        if (action == null) action = "/";
        switch (action) {
            case "/listAtt/add":
                addToListAtt(request, response);
                break;
            case "/patient/register":
                registerPatient(request, response);
                break;
            case "/listAtt/remove":
                removeFromQueue(request, response);
                break;
            case "/patient/vitals/add":
                addVitalSigns(request, response);
                break;
            case "/patient/update":
                updatePatient(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        setNotifications(request);
        request.setAttribute("patients", patientService.getAllPatients());
        request.getRequestDispatcher("/views/infirmer/dashboard.jsp").forward(request, response);
    }

    private void showListAtt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        setNotifications(request);

        List<Patient> queuePatients = patientService.getQueuePatients();
        List<Patient> allPatients = patientService.getAllPatients();

        request.setAttribute("now", java.time.LocalDate.now());

        request.setAttribute("listAtt", queuePatients);
        request.setAttribute("patients", allPatients);

        System.out.println("DEBUG: showListAtt - queue size = " + (queuePatients != null ? queuePatients.size() : 0));

        request.getRequestDispatcher("/views/infirmer/listAtt.jsp").forward(request, response);
    }

    private void addToListAtt(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String id = request.getParameter("id");
            patientService.addToQueue(id);
            request.getSession().setAttribute("success", "Patient added to queue!");
        } catch (Exception e) {
            request.getSession().setAttribute("error", e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/infirmer/listAtt");
    }

    private void registerPatient(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String id = Helper.generatePatientID();
            String ssn = request.getParameter("ssn");
            String nom = request.getParameter("nameComplet");
            LocalDate birth = LocalDate.parse(request.getParameter("birthDate"));
            String tele = request.getParameter("phone");
            String email = request.getParameter("email");
            String antecedents = request.getParameter("antecedents");
            String allergies = request.getParameter("allergies");
            String traitementsEnCours = request.getParameter("traitementsEnCours");

            String standardizedSsn = ssn.toUpperCase().trim();
            System.out.println("DEBUG Servlet: Received SSN: " + ssn);
            System.out.println("DEBUG Servlet: Standardized SSN: " + standardizedSsn);

            if(!Validateur.isValidSSN(standardizedSsn)){
                System.out.println("DEBUG Servlet: SSN validation failed");
                request.getSession().setAttribute("error", "Invalid SSN: " + standardizedSsn);
                response.sendRedirect(request.getContextPath() + "/infirmer/");
                return;
            }

            Optional<Patient> existing = patientService.findPatientBySsn(standardizedSsn);
            System.out.println("DEBUG Servlet: Patient exists: " + existing.isPresent());

            if (existing.isPresent()) {
                Patient patient = existing.get();
                System.out.println("DEBUG Servlet: Existing patient - ID: " + patient.getId() + ", SSN: " + patient.getSocialSecurityNumber());
                request.getSession().setAttribute("error", "SSN " + standardizedSsn + " already exists for patient ID: " + patient.getId());
                response.sendRedirect(request.getContextPath() + "/infirmer/");
                return;
            }

            if (nom == null || nom.trim().isEmpty() || nom.length() < 6) {
                request.getSession().setAttribute("error", "Le nom complet est obligatoire et doit contenir au moins 6 caractères");
                response.sendRedirect(request.getContextPath() + "/infirmer/");
                return;
            }

            int age = Period.between(birth, LocalDate.now()).getYears();
            if (age < 0 || age > 130) {
                request.getSession().setAttribute("error", "Âge invalide : " + age + " ans.");
                response.sendRedirect(request.getContextPath() + "/infirmer/");
                return;
            }

            if (tele == null || tele.trim().isEmpty() || !Validateur.isValidTele(tele)) {
                request.getSession().setAttribute("error", "Format de numéro de téléphone invalide ou manquant");
                response.sendRedirect(request.getContextPath() + "/infirmer/");
                return;
            } else if (patientService.teleExit(tele)) {
                request.getSession().setAttribute("error", "Ce numéro de téléphone est déjà utilisé");
                response.sendRedirect(request.getContextPath() + "/infirmer/");
                return;
            }

            if (email == null || email.trim().isEmpty() || !Validateur.isValidEmail(email)) {
                request.getSession().setAttribute("error", "Format d'email invalide ou manquant");
                response.sendRedirect(request.getContextPath() + "/infirmer/");
                return;
            } else if (patientService.emailExiste(email)) {
                request.getSession().setAttribute("error", "Cet email est déjà utilisé");
                response.sendRedirect(request.getContextPath() + "/infirmer/");
                return;
            }

            // --- Patient Creation ---
            Patient patient = new Patient(
                    id,
                    nom,
                    birth,
                    standardizedSsn, // Use standardized SSN
                    tele,
                    email,
                    antecedents,
                    allergies,
                    traitementsEnCours,
                    null
            );

            VitalSigns vs = null;
            String bp = request.getParameter("bloodPressure");
            if (bp != null && !bp.isEmpty()) {
                vs = new VitalSigns(
                        Helper.generateVitalsingeId(),
                        patient,
                        parseDoubleWithDefault(bp, 0.0),
                        parseIntWithDefault(request.getParameter("heartRate"), 0),
                        parseDoubleWithDefault(request.getParameter("bodyTemperature"), 0.0),
                        parseIntWithDefault(request.getParameter("respiratoryRate"), 0),
                        parseDoubleWithDefault(request.getParameter("weight"), 0.0),
                        parseDoubleWithDefault(request.getParameter("height"), 0.0)
                );
            }
            patientService.registerPatient(patient, vs);
            request.getSession().setAttribute("success", "Patient registered successfully!");
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Error registering patient: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/infirmer/");
    }

    private void removeFromQueue(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String patientId = request.getParameter("patientId");
            patientService.removeFromQueue(patientId);
            request.getSession().setAttribute("success", "Patient removed from queue!");
        } catch (Exception e) {
            request.getSession().setAttribute("error", e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/infirmer/listAtt");
    }

    private void addVitalSigns(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String patientId = request.getParameter("id");

        try {
            Optional<Patient> optPatient = patientService.findPatientById(patientId);
            if (optPatient.isPresent()) {
                Patient patient = optPatient.get();
                VitalSigns vs = new VitalSigns(Helper.generateVitalsingeId(),
                        patient,
                        parseDoubleWithDefault(request.getParameter("bloodPressure"), 0.0),
                        parseIntWithDefault(request.getParameter("heartRate"), 0),
                        parseDoubleWithDefault(request.getParameter("bodyTemperature"), 0.0),
                        parseIntWithDefault(request.getParameter("respiratoryRate"), 0),
                        parseDoubleWithDefault(request.getParameter("weight"), 0.0),
                        parseDoubleWithDefault(request.getParameter("height"), 0.0)
                );
                patientService.addVitalSigns(patientId, vs);
                request.getSession().setAttribute("success", "Vital signs added successfully!");
            } else {
                request.getSession().setAttribute("error", "Patient not found!");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Error adding vital signs: " + e.getMessage());
        }

        // Redirect back to Dashboard as requested
        response.sendRedirect(request.getContextPath() + "/infirmer/");
    }

    private void updatePatient(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String patientId = request.getParameter("patientId");

        try {
            Optional<Patient> optPatient = patientService.findPatientById(patientId);
            if (optPatient.isPresent()) {
                Patient patient = optPatient.get();

                // Validate and standardize SSN before saving
                String newSsn = request.getParameter("ssn").toUpperCase();

                patient.setNameComplet(request.getParameter("nameComplet"));
                patient.setBirthDate(LocalDate.parse(request.getParameter("birthDate")));
                patient.setSocialSecurityNumber(newSsn); // Use standardized SSN
                patient.setPhone(request.getParameter("phone"));
                patient.setEmail(request.getParameter("email"));
                patient.setAntecedents(request.getParameter("antecedents"));
                patient.setAllergies(request.getParameter("allergies"));
                patient.setTraitementsEnCours(request.getParameter("traitementsEnCours"));

                patientService.updatePatient(patient);
                request.getSession().setAttribute("success", "Patient updated successfully!");
            } else {
                request.getSession().setAttribute("error", "Patient not found!");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Error updating patient: " + e.getMessage());
        }

        // Redirect back to Dashboard as requested
        response.sendRedirect(request.getContextPath() + "/infirmer/");
    }

    private void searchPatient(HttpServletRequest request, HttpServletResponse response, String idPatient)
            throws ServletException, IOException {
        setNotifications(request);
        String standardizedSsn = idPatient.toUpperCase();

        Optional<Patient> patient = patientService.findPatientById(standardizedSsn);

        if (patient.isPresent()) {
            request.setAttribute("patient", patient.get());
        } else {
            // Use the original ssn in the error message for clarity
            request.setAttribute("error", "Patient with SSN " + idPatient + " not found");
        }
        // FORWARD to the JSP that displays the details
        request.getRequestDispatcher("/views/infirmer/patient.jsp").forward(request, response);
    }

    private void setNotifications(HttpServletRequest request) {
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

    // Utility parse methods with default values
    private Integer parseIntWithDefault(String param, int defaultValue) {
        try {
            return Integer.parseInt(param);
        } catch (Exception e) {
            return defaultValue;
        }
    }

    private Double parseDoubleWithDefault(String param, double defaultValue) {
        try {
            return Double.parseDouble(param);
        } catch (Exception e) {
            return defaultValue;
        }
    }
}