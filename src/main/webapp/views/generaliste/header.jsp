<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Session check logic remains
    HttpSession sessionCheck = request.getSession(false);
    if (sessionCheck == null || sessionCheck.getAttribute("currentUser") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>

<nav class="bg-white rounded-xl shadow-md border border-gray-100 p-4 mb-8">
    <div class="flex items-center justify-between">

        <div class="flex items-center gap-3">
            <div class="w-10 h-10 rounded-lg bg-gradient-to-br from-purple-500 to-blue-500 flex items-center justify-center text-white font-bold text-xl shadow-lg">
                <i class="fa-solid fa-house-medical-circle-check"></i>
            </div>
            <div>
                <h1 class="text-xl font-bold text-gray-800">ClinicalInk</h1>
                <p class="text-xs text-gray-500">Espace Infirmier</p>
            </div>
        </div>

        <div class="flex items-center space-x-4">
            <a href="${pageContext.request.contextPath}/infirmer/"
               class="flex items-center px-4 py-2 rounded-lg text-sm font-medium transition-all
               ${pageContext.request.servletPath eq '/infirmer' ? 'bg-blue-100 text-blue-700' : 'text-gray-600 hover:bg-gray-100'}">
                <i class="fa-solid fa-table-columns mr-2"></i> Tableau de Bord
            </a>

            <a href="${pageContext.request.contextPath}/infirmer/listAtt"
               class="flex items-center px-4 py-2 rounded-lg text-sm font-medium transition-all
               ${pageContext.request.servletPath eq '/infirmer/listAtt' ? 'bg-blue-100 text-blue-700' : 'text-gray-600 hover:bg-gray-100'}">
                <i class="fa-solid fa-hourglass-start mr-2"></i> File d'Attente
                <c:if test="${patientService.getQueuePatients().size() > 0}">
                    <span class="ml-2 inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-semibold bg-red-100 text-red-800">
                            ${patientService.getQueuePatients().size()}
                    </span>
                </c:if>
            </a>
        </div>

        <div class="flex items-center gap-4">
            <div class="text-right">
                <p class="text-sm font-semibold text-gray-800">${sessionScope.currentUser.nomComplet}</p>
                <p class="text-xs text-gray-500">${sessionScope.currentUser.role}</p>
            </div>
            <a href="${pageContext.request.contextPath}/logout"
               class="p-2 rounded-full bg-red-100 hover:bg-red-200 text-red-600 transition-all shadow-sm"
               title="Déconnexion">
                <i class="fa-solid fa-right-from-bracket w-4 h-4"></i>
            </a>
        </div>
    </div>
</nav>