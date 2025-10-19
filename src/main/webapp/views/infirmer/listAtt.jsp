<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page isELIgnored="false" %>
<%@ include file="/assets/head.jsp" %>
<%-- Ensure "now" exists (if servlet didn't set it) --%>
<%
    if (request.getAttribute("now") == null) {
        request.setAttribute("now", java.time.LocalDate.now());
    }
%>

<body class="bg-gray-50 min-h-screen antialiased">

<div class="w-full min-h-screen">
    <div class="w-full max-w-screen-xl mx-auto py-8 px-4 sm:px-6 lg:px-8">

        <%-- Header (Assuming this includes your main navigation) --%>
        <%@ include file="/views/infirmer/header.jsp"%>

        <main class="w-full">

            <%-- Notifications --%>
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

                <div class="bg-blue-600 px-6 py-4 border-b border-gray-200">
                    <div class="flex justify-between items-center">
                        <div>
                            <h3 class="text-xl font-bold text-white">⏳ File d'Attente des Patients</h3>
                            <p class="text-blue-100 text-sm mt-1">Patients en attente de prise en charge : **${listAtt != null ? listAtt.size() : 0}**</p>
                        </div>
                    </div>
                </div>

                <div class="p-6">
                    <c:if test="${empty listAtt}">
                        <div class="text-center py-12 bg-gray-50 rounded-lg border border-gray-200">
                            <i class="fa-solid fa-check-double text-6xl text-blue-400 mb-4"></i>
                            <h4 class="text-xl font-semibold text-gray-700 mb-2">File d'attente vide ! 🎉</h4>
                            <p class="text-gray-500 text-md max-w-lg mx-auto">
                                C'est calme pour l'instant. Ajoutez un patient depuis le tableau de bord pour qu'il apparaisse ici.
                            </p>
                            <a href="${pageContext.request.contextPath}/infirmer/"
                               class="inline-flex items-center gap-2 mt-6 px-5 py-2.5 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-all font-medium shadow-md">
                                <i class="fa-solid fa-arrow-left"></i>
                                Retour au Tableau de Bord
                            </a>
                        </div>
                    </c:if>

                    <c:if test="${not empty listAtt}">
                        <div class="space-y-4">
                            <c:forEach items="${listAtt}" var="queueItem" varStatus="status">
                                <div class="queue-item bg-white border border-gray-200 rounded-lg p-5 shadow-md hover:shadow-lg transition-all flex items-center justify-between">

                                    <div class="flex items-center gap-6 flex-1">
                                        <div class="flex flex-col items-center justify-center min-w-[70px]">
                                            <div class="w-14 h-14 rounded-full bg-gradient-to-br from-blue-500 to-indigo-600 flex items-center justify-center text-white font-extrabold text-2xl shadow-xl">
                                                    ${status.index + 1}
                                            </div>
                                            <span class="text-xs text-blue-600 font-medium mt-2">Position</span>
                                        </div>

                                        <div class="flex-1">
                                            <h4 class="font-bold text-gray-900 text-xl">${queueItem.patient.nameComplet}</h4>
                                            <div class="flex flex-wrap items-center gap-x-6 gap-y-2 mt-2 text-sm text-gray-600">
                                                <span class="font-medium">
                                                    <i class="fa-solid fa-id-card mr-1 text-gray-400"></i>
                                                    SSN: **${queueItem.patient.socialSecurityNumber}**
                                                </span>
                                                <span>
                                                    <i class="fa-solid fa-birthday-cake mr-1 text-gray-400"></i>
                                                    Âge:
                                                    <c:choose>
                                                        <c:when test="${not empty queueItem.patient.birthDate}">
                                                            <c:set var="birthDate" value="${queueItem.patient.birthDate}"/>
                                                            **${now.year - birthDate.year} ans**
                                                        </c:when>
                                                        <c:otherwise>
                                                            N/A
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="flex items-center gap-3 ml-4 flex-shrink-0">
                                        <a href="${pageContext.request.contextPath}/infirmer/search/${queueItem.patient.id}"
                                           class="p-3 bg-blue-50 hover:bg-blue-100 text-blue-600 rounded-lg transition-all shadow-sm flex items-center gap-2 font-medium" title="Voir Dossier Complet">
                                            <i class="fa-solid fa-user-pen"></i>
                                            <span class="hidden sm:inline">Dossier</span>
                                        </a>

                                        <form action="${pageContext.request.contextPath}/infirmer/listAtt/remove" method="POST" class="m-0">
                                            <input type="hidden" name="patientId" value="${queueItem.patient.id}">
                                            <button type="submit"
                                                    class="p-3 bg-red-500 text-white rounded-lg hover:bg-red-600 transition-all shadow-md flex items-center gap-2 font-medium" title="Retirer de la File">
                                                <i class="fa-solid fa-user-xmark"></i>
                                                <span class="hidden sm:inline">Retirer</span>
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>
                </div>
            </div>

            <c:if test="${not empty listAtt}">
                <div class="mt-6 grid grid-cols-1 md:grid-cols-3 gap-4">
                    <div class="md:col-span-2 p-5 bg-white border border-gray-200 rounded-xl shadow-md">
                        <div class="flex items-center gap-3">
                            <i class="fa-solid fa-list-check text-2xl text-blue-600"></i>
                            <span class="font-semibold text-xl text-gray-800">Résumé de la File</span>
                        </div>
                        <p class="text-sm text-gray-600 mt-2">
                            Total de patients en attente: <span class="font-bold text-blue-700">${listAtt.size()}</span>.
                            Le prochain patient est en position **#1**.
                        </p>
                    </div>

                    <a href="${pageContext.request.contextPath}/infirmer/"
                       class="p-5 bg-blue-600 text-white rounded-xl hover:bg-blue-700 transition-all shadow-md flex items-center justify-center gap-3">
                        <i class="fa-solid fa-circle-plus text-xl"></i>
                        <span class="font-medium text-lg">Ajouter un nouveau patient</span>
                    </a>
                </div>
            </c:if>
        </main>
    </div>
</div>

<style>
    /* Queue item animation for visual feedback */
    .queue-item {
        animation: fadeIn 0.5s ease-out;
    }

    @keyframes fadeIn {
        from {
            opacity: 0;
            transform: translateY(10px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
</style>

</body>
</html>