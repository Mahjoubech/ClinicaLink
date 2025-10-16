<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<%@ include file="/assets/head.jsp" %>
<%-- NOTE: Ensure your /assets/head.jsp includes Font Awesome. --%>

<%-- Ensure "now" exists (used to compute age) --%>
<%
    if (request.getAttribute("now") == null) {
        request.setAttribute("now", java.time.LocalDate.now());
    }
%>

<body class="bg-gray-100 min-h-screen antialiased">

<div class="w-full min-h-screen">
    <div class="w-full max-w-screen-xl mx-auto py-8 px-4 sm:px-6 lg:px-8">

        <%@ include file="/views/infirmer/header.jsp"%>

        <main class="w-full max-w-5xl mx-auto">

            <%-- Notification Display (Reverting to original classes) --%>
            <c:if test="${not empty error}">
                <div class="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg shadow-sm flex items-center">
                    <i class="fa-solid fa-circle-exclamation text-red-500 mr-3"></i>
                    <span class="text-red-700 text-sm font-medium">${error}</span>
                </div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="mb-6 p-4 bg-green-50 border border-green-200 rounded-lg shadow-sm flex items-center">
                    <i class="fa-solid fa-circle-check text-green-500 mr-3"></i>
                    <span class="text-green-700 text-sm font-medium">${success}</span>
                </div>
            </c:if>

            <c:if test="${not empty patient}">

                <%-- 1. PATIENT SUMMARY CARD --%>
                <div class="bg-white rounded-xl shadow-lg border border-gray-200 p-6 mb-6">
                    <div class="flex justify-between items-start border-b pb-4 mb-4">
                        <h1 class="text-2xl font-semibold text-gray-800 flex items-center gap-2">
                            <i class="fa-solid fa-user-injured text-blue-500"></i>
                            Dossier Patient: <span class="text-blue-700 font-bold">${patient.nameComplet}</span>
                        </h1>
                        <button onclick="showModal('editPatient')"
                                class="bg-yellow-500 text-white px-4 py-2 text-sm rounded-lg hover:bg-yellow-600 transition-all font-medium flex items-center gap-2 shadow-md">
                            <i class="fa-solid fa-user-pen"></i> Modifier
                        </button>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 text-sm">
                        <div class="p-3 border-l-4 border-blue-500 bg-blue-50 rounded">
                            <p class="text-gray-500">ID Patient</p>
                            <p class="font-bold text-gray-800">${patient.id}</p>
                        </div>
                        <div class="p-3 border-l-4 border-blue-500 bg-blue-50 rounded">
                            <p class="text-gray-500">NSS</p>
                            <p class="font-bold text-gray-800">${patient.socialSecurityNumber}</p>
                        </div>
                        <div class="p-3 border-l-4 border-blue-500 bg-blue-50 rounded">
                            <p class="text-gray-500">Âge</p>
                            <c:set var="birthDate" value="${patient.birthDate}" />
                            <p class="font-bold text-gray-800">${now.year - birthDate.year} ans</p>
                        </div>
                        <div class="p-3 border-l-4 border-blue-500 bg-blue-50 rounded">
                            <p class="text-gray-500">Téléphone</p>
                            <p class="font-bold text-gray-800">${patient.phone}</p>
                        </div>

                            <%-- Extended details (Email, BirthDate) --%>
                        <div class="lg:col-span-2 p-3 border border-gray-200 rounded">
                            <p class="text-gray-500">Email</p>
                            <p class="text-gray-800">${patient.email}</p>
                        </div>
                        <div class="lg:col-span-2 p-3 border border-gray-200 rounded">
                            <p class="text-gray-500">Date de Naissance</p>
                            <p class="text-gray-800">${patient.birthDate}</p>
                        </div>
                    </div>
                </div>

                <%-- 2. MEDICAL HISTORY CARD --%>
                <div class="bg-white rounded-xl shadow-lg border border-gray-200 p-6 mb-6">
                    <h2 class="text-xl font-semibold text-gray-800 mb-4 border-b pb-2">
                        <i class="fa-solid fa-file-medical text-green-500 mr-2"></i>Antécédents et Traitements
                    </h2>

                    <div class="grid grid-cols-1 md:grid-cols-3 gap-5">
                        <div class="p-3 border border-red-200 bg-red-50 rounded-lg">
                            <p class="text-sm font-medium text-red-700 mb-1">Antécédents</p>
                            <p class="text-gray-800 text-sm">${not empty patient.antecedents ? patient.antecedents : 'Non renseigné.'}</p>
                        </div>
                        <div class="p-3 border border-yellow-200 bg-yellow-50 rounded-lg">
                            <p class="text-sm font-medium text-yellow-700 mb-1">Allergies</p>
                            <p class="text-gray-800 text-sm">${not empty patient.allergies ? patient.allergies : 'Aucune allergie documentée.'}</p>
                        </div>
                        <div class="p-3 border border-purple-200 bg-purple-50 rounded-lg">
                            <p class="text-sm font-medium text-purple-700 mb-1">Traitements en Cours</p>
                            <p class="text-gray-800 text-sm">${not empty patient.traitementsEnCours ? patient.traitementsEnCours : 'Non renseigné.'}</p>
                        </div>
                    </div>
                </div>

                <%-- 3. VITAL SIGNS HISTORY CARD --%>
                <div class="bg-white rounded-xl shadow-lg border border-gray-200 p-6 mb-6">
                    <div class="flex justify-between items-center mb-4 border-b pb-2">
                        <h2 class="text-xl font-semibold text-gray-800 flex items-center gap-2">
                            <i class="fa-solid fa-heart-pulse text-red-500"></i>
                            Signes Vitaux
                        </h2>
                        <button onclick="showModal('addVitals')"
                                class="bg-blue-600 text-white px-4 py-2 text-sm rounded-lg hover:bg-blue-700 transition-all font-medium flex items-center gap-2 shadow-md">
                            <i class="fa-solid fa-plus"></i> Ajouter Lecture
                        </button>
                    </div>

                    <c:if test="${not empty patient.vitalSigns and patient.vitalSigns.size() > 0}">
                        <%-- Latest Vitals Summary (Detailed) --%>
                        <c:set var="latestVitals" value="${patient.vitalSigns[0]}" />
                        <div class="border border-blue-300 rounded-lg mb-6 overflow-hidden">
                            <p class="bg-blue-200 text-blue-800 font-bold p-3 text-center text-sm">
                                Dernière Lecture: ${latestVitals.createdAt}/>
                            </p>
                            <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 divide-x divide-blue-200 bg-blue-50">
                                <div class="p-3 text-center">
                                    <p class="text-gray-600 text-xs">P. Artérielle</p>
                                    <p class="font-bold text-lg text-blue-700">${latestVitals.bloodPressure} mmHg</p>
                                </div>
                                <div class="p-3 text-center">
                                    <p class="text-gray-600 text-xs">F. Cardiaque</p>
                                    <p class="font-bold text-lg text-blue-700">${latestVitals.heartRate} bpm</p>
                                </div>
                                <div class="p-3 text-center">
                                    <p class="text-gray-600 text-xs">Température</p>
                                    <p class="font-bold text-lg text-blue-700">${latestVitals.temperature}°C>
                                </div>
                                <div class="p-3 text-center">
                                    <p class="text-gray-600 text-xs">F. Respiratoire</p>
                                    <p class="font-bold text-lg text-blue-700">${latestVitals.respiratoryRate} /min</p>
                                </div>
                                <div class="p-3 text-center">
                                    <p class="text-gray-600 text-xs">Poids</p>
                                    <p class="font-bold text-lg text-blue-700">${latestVitals.weight} kg</p>
                                </div>
                                <div class="p-3 text-center">
                                    <p class="text-gray-600 text-xs">Taille</p>
                                    <p class="font-bold text-lg text-blue-700">${latestVitals.height} cm</p>
                                </div>
                            </div>
                        </div>

                        <%-- Vitals History Table --%>
                        <div class="overflow-x-auto border border-gray-200 rounded-lg shadow-sm">
                            <table class="w-full divide-y divide-gray-200">
                                <thead class="bg-gray-50">
                                <tr>
                                    <th class="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Date & Heure</th>
                                    <th class="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Pression</th>
                                    <th class="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Cardiaque</th>
                                    <th class="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Température</th>
                                    <th class="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Respiratoire</th>
                                    <th class="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Poids</th>
                                    <th class="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Taille</th>
                                </tr>
                                </thead>
                                <tbody class="bg-white divide-y divide-gray-100">
                                <c:forEach items="${patient.vitalSigns}" var="v">
                                    <tr class="hover:bg-gray-50 transition-colors">
                                        <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-800">
                                            ${v.createdAt}
                                        </td>
                                        <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-800">${v.bloodPressure} mmHg</td>
                                        <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-800">${v.heartRate} bpm</td>
                                        <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-800">${v.temperature}°C</td>
                                        <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-800">${v.respiratoryRate} /min</td>
                                        <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-800">${v.weight} kg</td>
                                        <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-800">${v.height} cm</td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>

                    <c:if test="${empty patient.vitalSigns}">
                        <div class="text-center py-8 text-gray-500 bg-gray-50 rounded-lg border border-gray-200">
                            <i class="fa-solid fa-chart-line text-4xl mb-2"></i>
                            <p>Aucune lecture des signes vitaux enregistrée.</p>
                        </div>
                    </c:if>
                </div>
            </c:if>

        </main>
    </div>
</div>

<style>
    /* Styling for the modal inputs, ensuring consistency */
    .form-input {
        @apply w-full border border-gray-300 rounded-lg px-3 py-2 text-gray-800 transition-all focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500;
    }
</style>

<c:if test="${not empty patient}">
    <%-- MODAL: EDIT PATIENT (Original structure, restored attributes) --%>
    <div id="editPatient" class="modal hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
        <div class="bg-white rounded-lg p-6 w-full max-w-2xl max-h-[90vh] overflow-y-auto shadow-2xl">
            <h3 class="text-xl font-bold text-yellow-600 mb-4 border-b pb-2">Modifier les Informations du Patient</h3>
            <form action="${pageContext.request.contextPath}/infirmer/patient/update" method="post">
                <input type="hidden" name="patientId" value="${patient.id}"/>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <label class="block">
                        <span class="text-gray-700 text-sm font-medium">Nom Complet</span>
                        <input type="text" name="nameComplet" value="${patient.nameComplet}" required class="form-input"/>
                    </label>

                    <label class="block">
                        <span class="text-gray-700 text-sm font-medium">Date de Naissance</span>
                        <input type="date" name="birthDate" value="${patient.birthDate}" required class="form-input"/>
                    </label>

                    <label class="block">
                        <span class="text-gray-700 text-sm font-medium">NSS</span>
                        <input type="text" name="ssn" value="${patient.socialSecurityNumber}" required class="form-input"/>
                    </label>

                    <label class="block">
                        <span class="text-gray-700 text-sm font-medium">Téléphone</span>
                        <input type="text" name="phone" value="${patient.phone}" class="form-input"/>
                    </label>

                    <label class="block md:col-span-2">
                        <span class="text-gray-700 text-sm font-medium">Email</span>
                        <input type="email" name="email" value="${patient.email}" class="form-input"/>
                    </label>

                    <label class="block md:col-span-2">
                        <span class="text-gray-700 text-sm font-medium">Antécédents</span>
                        <textarea name="antecedents" rows="3" class="form-input">${patient.antecedents}</textarea>
                    </label>

                    <label class="block">
                        <span class="text-gray-700 text-sm font-medium">Allergies</span>
                        <textarea name="allergies" rows="3" class="form-input">${patient.allergies}</textarea>
                    </label>

                    <label class="block">
                        <span class="text-gray-700 text-sm font-medium">Traitements en cours</span>
                        <textarea name="traitementsEnCours" rows="3" class="form-input">${patient.traitementsEnCours}</textarea>
                    </label>
                </div>

                <div class="flex justify-end space-x-3 border-t pt-4 mt-6">
                    <button type="button" onclick="hideModal('editPatient')" class="px-6 py-2.5 bg-gray-300 text-gray-700 rounded-lg hover:bg-gray-400 transition-all font-medium">
                        Annuler
                    </button>
                    <button type="submit" class="px-6 py-2.5 bg-yellow-500 text-white rounded-lg hover:bg-yellow-600 transition-all font-medium shadow-md">
                        Mettre à Jour
                    </button>
                </div>
            </form>
        </div>
    </div>

    <%-- MODAL: ADD VITAL SIGNS (Original structure, restored attributes) --%>
    <div id="addVitals" class="modal hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
        <div class="bg-white rounded-lg p-6 w-full max-w-lg max-h-[90vh] overflow-y-auto shadow-2xl">
            <h3 class="text-xl font-bold text-blue-600 mb-4 border-b pb-2">Ajouter une Nouvelle Lecture des Signes Vitaux</h3>
            <form action="${pageContext.request.contextPath}/infirmer/patient/vitals/add" method="post">
                <input type="hidden" name="id" value="${patient.id}"/>

                <div class="grid grid-cols-2 gap-4 mb-4">
                    <label class="block">
                        <span class="text-gray-700 text-sm font-medium">Pression Artérielle (mmHg)</span>
                        <input type="text" name="bloodPressure" placeholder="ex: 120/80" class="form-input"/>
                    </label>

                    <label class="block">
                        <span class="text-gray-700 text-sm font-medium">Fréquence Cardiaque (bpm)</span>
                        <input type="number" name="heartRate" placeholder="ex: 72" class="form-input"/>
                    </label>

                    <label class="block">
                        <span class="text-gray-700 text-sm font-medium">Température (°C)</span>
                        <input type="number" step="0.1" name="bodyTemperature" placeholder="ex: 36.5" class="form-input"/>
                    </label>

                    <label class="block">
                        <span class="text-gray-700 text-sm font-medium">Fréquence Respiratoire (/min)</span>
                        <input type="number" name="respiratoryRate" placeholder="ex: 16" class="form-input"/>
                    </label>

                    <label class="block">
                        <span class="text-gray-700 text-sm font-medium">Poids (kg)</span>
                        <input type="number" step="0.1" name="weight" placeholder="ex: 70.5" class="form-input"/>
                    </label>

                    <label class="block">
                        <span class="text-gray-700 text-sm font-medium">Taille (cm)</span>
                        <input type="number" step="0.1" name="height" placeholder="ex: 175.0" class="form-input"/>
                    </label>
                </div>

                <div class="flex justify-end space-x-3 border-t pt-4 mt-2">
                    <button type="button" onclick="hideModal('addVitals')" class="px-6 py-2.5 bg-gray-300 text-gray-700 rounded-lg hover:bg-gray-400 transition-all font-medium">
                        Annuler
                    </button>
                    <button type="submit" class="px-6 py-2.5 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-all font-medium shadow-md">
                        Enregistrer la Lecture
                    </button>
                </div>
            </form>
        </div>
    </div>
</c:if>


</body>
<script>
    function showModal(id) {
        document.getElementById(id).classList.remove('hidden');
    }

    function hideModal(id) {
        document.getElementById(id).classList.add('hidden');
    }
    // Close modal when clicking outside
    document.addEventListener('click', function(event) {
        if (event.target.classList.contains('modal')) {
            event.target.classList.add('hidden');
        }
    });
</script>
</html>