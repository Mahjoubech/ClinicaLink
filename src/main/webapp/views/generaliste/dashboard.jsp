<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page isELIgnored="false" %>
<%@ include file="/assets/head.jsp" %>

<%-- NOTE: /layout/meta.jsp should include Tailwind CSS and Font Awesome for icons --%>

<body class="bg-gray-50 min-h-screen antialiased">

<div class="w-full min-h-screen">
    <div class="w-full max-w-screen-xl mx-auto py-8 px-4 sm:px-6 lg:px-8">

        <%@ include file="/views/generaliste/header.jsp" %>

        <main class="w-full max-w-6xl mx-auto mt-8">

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

                <div class="bg-blue-100 px-6 py-4 border-b border-blue-200">
                    <div class="flex justify-between items-center">
                        <div>
                            <h3 class="text-xl font-bold text-blue-800 flex items-center gap-2">
                                <i class="fa-solid fa-user-clock"></i>
                                File d'Attente des Patients (${queue.size()} en attente)
                            </h3>
                            <p class="text-blue-700 text-sm mt-1">Patients prêts pour la consultation médicale.</p>
                        </div>
                    </div>
                </div>

                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-blue-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-semibold text-blue-700 uppercase tracking-wider">Nom Complet</th>
                            <th class="px-6 py-3 text-left text-xs font-semibold text-blue-700 uppercase tracking-wider">NSS</th>
                            <th class="px-6 py-3 text-left text-xs font-semibold text-blue-700 uppercase tracking-wider">Heure d'Arrivée</th>
                            <th class="px-6 py-3 text-left text-xs font-semibold text-blue-700 uppercase tracking-wider">Actions</th>
                        </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-100">
                        <c:choose>
                            <c:when test="${empty queue}">
                                <tr>
                                    <td colspan="4" class="px-6 py-8 text-center text-sm text-gray-500 bg-gray-50">
                                        <i class="fa-solid fa-house-chimney-medical text-2xl mb-2"></i><br>
                                        La file d'attente est vide. Aucun patient n'est en attente.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach items="${queue}" var="q">
                                    <tr class="hover:bg-blue-50 transition-colors">

                                            <%-- Patient Name & SSN (Adjusted for generic ListAttente 'q' object) --%>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                                            <i class="fa-solid fa-user text-gray-400 mr-2"></i>
                                                <%-- NOTE: Assuming patient entity uses 'nameComplet' or you combine names --%>
                                                ${q.patient.nameComplet}
                                        </td>

                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">${q.patient.socialSecurityNumber}</td>

                                            <%-- Arrival Time (Assuming a 'arrivalTime' property which is a Date/Timestamp) --%>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
                                            <fmt:formatDate value="${q.arrivalTime}" pattern="HH:mm" />
                                        </td>

                                            <%-- Actions --%>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <form action="${pageContext.request.contextPath}/generalist/consultation/create" method="GET" class="inline">
                                                <input type="hidden" name="patientId" value="${q.patient.id}">
                                                    <%-- Removed csrfToken as it's not present in the original Generalist code for this GET request --%>

                                                <button type="submit"
                                                        class="bg-blue-600 text-white px-4 py-2 rounded-lg text-sm hover:bg-blue-700 transition-all font-medium flex items-center gap-2 shadow-md">
                                                    <i class="fa-solid fa-notes-medical"></i> Démarrer Consultation
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</div>

</body>
</html>