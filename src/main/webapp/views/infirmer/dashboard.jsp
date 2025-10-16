<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<%@ include file="/assets/head.jsp" %>
<body class="bg-gray-50 min-h-screen antialiased">

<div class="w-full min-h-screen">
    <div class="w-full max-w-screen-xl mx-auto py-8 px-4 sm:px-6 lg:px-8">

        <%@ include file="/views/infirmer/header.jsp"%>

        <main class="lg:col-span-4">

            <c:if test="${not empty error}">
                <div class="mb-6 p-4 bg-red-50 border border-red-200 rounded-xl shadow-sm flex items-center">
                    <i class="fa-solid fa-circle-exclamation text-red-500 mr-3"></i>
                    <span class="text-red-700 text-sm font-medium">${error}</span>
                </div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="mb-6 p-4 bg-green-50 border border-green-200 rounded-xl shadow-sm flex items-center">
                    <i class="fa-solid fa-circle-check text-green-500 mr-3"></i>
                    <span class="text-green-700 text-sm font-medium">${success}</span>
                </div>
            </c:if>

            <div class="bg-white rounded-xl shadow-lg border border-gray-200 overflow-hidden">

                <div class="bg-gray-50 px-6 py-4 border-b border-gray-200">
                    <div class="flex justify-between items-center">
                        <div>
                            <h3 class="text-xl font-bold text-gray-800">Liste des Patients (Total: ${patients.size()})</h3>
                            <p class="text-gray-500 text-sm mt-1">Gérez les dossiers patients de l'établissement</p>
                        </div>

                        <button onclick="showModal()"
                                class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-all font-medium flex items-center gap-2 shadow-md">
                            <i class="fa-solid fa-plus w-4 h-4"></i> Nouveau Patient
                        </button>
                    </div>
                </div>

                <div class="p-6">
                    <div class="mb-6">
                        <form action="${pageContext.request.contextPath}/infirmer/search" method="GET" class="flex gap-2">
                            <div class="relative flex-1">
                                <input type="text" name="ssn" placeholder="Rechercher par numéro de sécurité sociale..."
                                       class="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-400 focus:border-transparent transition-all">
                                <i class="fa-solid fa-magnifying-glass absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                            </div>
                            <button type="submit"
                                    class="bg-blue-600 text-white px-6 py-3 rounded-xl hover:bg-blue-700 transition-all font-medium hidden sm:block">
                                Rechercher
                            </button>
                        </form>
                    </div>

                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">NSS</th>
                                <th class="px-6 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Nom Complet</th>
                                <th class="px-6 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Date de Naissance</th>
                                <th class="px-6 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Téléphone</th>
                                <th class="px-6 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Actions</th>
                            </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-100">
                            <c:choose>
                                <c:when test="${patients.isEmpty()}">
                                    <tr>
                                        <td colspan="5" class="px-6 py-8 text-center text-sm text-gray-500 bg-gray-50">
                                            <i class="fa-solid fa-folder-open text-2xl mb-2"></i><br>
                                            Aucun patient trouvé.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${patients}" var="p">
                                        <tr class="hover:bg-blue-50 transition-colors">
                                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">${p.socialSecurityNumber}</td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">${p.nameComplet}</td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">${p.birthDate}</td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">${p.phone}</td>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <div class="flex gap-3 items-center">
                                                    <a href="${pageContext.request.contextPath}/infirmer/search/${p.id}"
                                                       class="text-blue-600 hover:text-blue-800 p-2 rounded-full hover:bg-blue-100 transition-colors" title="Voir Dossier">
                                                        <i class="fa-solid fa-eye"></i>
                                                    </a>

                                                        <%-- Check if the patient is currently in the queue --%>
                                                    <c:set var="inQueue" value="${patientService.isPatientInQueue(p.id)}" />

                                                    <c:choose>
                                                        <c:when test="${inQueue}">
                                                            <%-- Display status tag if in queue --%>
                                                            <span class="inline-flex items-center px-3 py-1 text-xs font-semibold leading-4 rounded-full bg-green-100 text-green-700 shadow-sm">
                                                                    <i class="fa-solid fa-clock mr-1"></i> En liste d'attente
                                                                </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <%-- Display Add to Queue button if not in queue --%>
                                                            <form action="${pageContext.request.contextPath}/infirmer/listAtt/add" method="POST" class="inline">
                                                                <input type="hidden" name="id" value="${p.id}" />
                                                                <button type="submit" class="text-purple-600 hover:text-purple-800 p-2 rounded-full hover:bg-purple-100 transition-colors" title="Ajouter à la File d'Attente">
                                                                    <i class="fa-solid fa-user-clock"></i>
                                                                </button>
                                                            </form>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<div id="addPatient" class="modal hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
    <div class="bg-white rounded-xl shadow-2xl p-6 w-full max-w-3xl max-h-[90%] overflow-y-auto transform transition-all">
        <h3 class="text-2xl font-bold text-blue-600 mb-6 border-b pb-2">➕ Enregistrer un Nouveau Patient</h3>
        <form action="${pageContext.request.contextPath}/infirmer/patient/register" method="post">

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
                <div class="form-group">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Nom Complet *</label>
                    <input type="text" name="nameComplet" required class="form-input">
                </div>
                <div class="form-group">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Date de Naissance *</label>
                    <input type="date" name="birthDate" required class="form-input">
                </div>
                <div class="form-group">
                    <label class="block text-sm font-medium text-gray-700 mb-1">NSS (Numéro de Sécurité Sociale) *</label>
                    <input type="text" name="ssn" required class="form-input">
                </div>
                <div class="form-group">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Téléphone</label>
                    <input type="text" name="phone" class="form-input">
                </div>
                <div class="form-group md:col-span-2">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Email</label>
                    <input type="email" name="email" class="form-input">
                </div>
            </div>

            <div class="border-t pt-6 mb-6">
                <h4 class="text-lg font-semibold text-gray-800 mb-4">Informations Médicales et Historique</h4>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div class="form-group">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Allergies</label>
                        <input type="text" name="allergies" class="form-input">
                    </div>
                    <div class="form-group">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Traitements en Cours</label>
                        <input type="text" name="traitementsEnCours" class="form-input">
                    </div>
                    <div class="form-group md:col-span-2">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Antécédents</label>
                        <textarea name="antecedents" rows="2" class="form-input"></textarea>
                    </div>
                </div>
            </div>

            <div class="border-t pt-6 mb-8">
                <h4 class="text-lg font-semibold text-gray-800 mb-4">Signes Vitaux Initiaux (Optionnel)</h4>
                <div class="grid grid-cols-2 md:grid-cols-3 gap-4">
                    <div class="form-group">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Température (°C)</label>
                        <input type="number" step="0.1" name="bodyTemperature" placeholder="ex: 36.6" class="form-input">
                    </div>
                    <div class="form-group">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Pression Artérielle</label>
                        <input type="text" name="bloodPressure" placeholder="ex: 120/80" class="form-input">
                    </div>
                    <div class="form-group">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Rythme Cardiaque (bpm)</label>
                        <input type="number" name="heartRate" placeholder="ex: 72" class="form-input">
                    </div>
                    <div class="form-group">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Poids (kg)</label>
                        <input type="number" step="0.1" name="weight" placeholder="ex: 70.5" class="form-input">
                    </div>
                    <div class="form-group">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Taille (cm)</label>
                        <input type="number" step="0.1" name="height" placeholder="ex: 175.0" class="form-input">
                    </div>
                    <div class="form-group">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Rythme Respiratoire</label>
                        <input type="number" name="respiratoryRate" placeholder="ex: 16" class="form-input">
                    </div>
                </div>
            </div>

            <div class="flex justify-end space-x-3 border-t pt-4">
                <button type="button" onclick="hideModal()"
                        class="px-6 py-3 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition-all font-medium shadow-sm">
                    Annuler
                </button>
                <button type="submit"
                        class="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-all font-medium shadow-md">
                    Enregistrer le Patient
                </button>
            </div>
        </form>
    </div>
</div>

<style>
    /* 1. Ensure input borders are clearly visible */
    .form-input {
        /* w-full border border-gray-300 rounded-lg... */
        @apply w-full border-2 border-gray-300 rounded-lg px-4 py-2.5 text-gray-800 transition-all focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500;
    }
</style>

<script>
    function showModal(){
        document.getElementById("addPatient").classList.remove('hidden');
    }
    function hideModal(){
        document.getElementById("addPatient").classList.add('hidden');
    }

    // Close modal when clicking outside
    document.getElementById("addPatient").addEventListener('click', function(event) {
        if (event.target.classList.contains('modal')) {
            event.target.classList.add('hidden');
        }
    });
</script>

</body>
</html>