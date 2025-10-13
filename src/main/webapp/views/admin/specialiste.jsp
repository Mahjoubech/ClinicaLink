<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, io.github.Mahjoubech.clinicalink.entity.Medcen, io.github.Mahjoubech.clinicalink.enums.Role" %>
<%
    HttpSession sessionCheck = request.getSession(false);
    if (sessionCheck == null || sessionCheck.getAttribute("admin") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<jsp:include page="/assets/head.jsp" />


<body class="bg-gradient-to-br from-gray-50 via-blue-50 to-indigo-50 min-h-screen antialiased">

<!-- Full width layout for desktop -->
<div class="w-full min-h-screen">

    <!-- Centered container but wide for PC -->
    <div class="w-full max-w-screen-xl mx-auto py-8 px-6 lg:px-12">

        <!-- Header -->
        <header class="backdrop-blur-sm bg-white/80 rounded-2xl shadow-lg border border-white/50 p-6 mb-8">
            <div class="flex items-center justify-between">
                <div class="flex items-center gap-4">
                    <div class="relative w-14 h-14">
                        <div class="absolute inset-0 bg-gradient-to-br from-purple-400 to-blue-500 rounded-2xl blur-lg opacity-30"></div>
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" width="64" height="64" role="img" aria-labelledby="clTitle clDesc">
                            <title id="clTitle">ClinicaLink</title>
                            <desc id="clDesc">ClinicaLink logo — gradient ring, linked arcs and central medical cross</desc>
                            <defs>
                                <linearGradient id="g" x1="0" x2="1" y1="0" y2="1">
                                    <stop offset="0%" stop-color="#7C3AED"/>
                                    <stop offset="60%" stop-color="#4F46E5"/>
                                    <stop offset="100%" stop-color="#2563EB"/>
                                </linearGradient>
                                <filter id="shadow" x="-50%" y="-50%" width="200%" height="200%">
                                    <feDropShadow dx="0" dy="2" stdDeviation="2" flood-color="#000" flood-opacity="0.12"/>
                                </filter>
                            </defs>
                            <circle cx="32" cy="32" r="26" fill="url(#g)" />
                            <path d="M20.8 40.2 A10.6 10.6 0 0 1 20 24.5 L24.5 24.5" fill="none" stroke="#FFFFFF" stroke-width="2.8" stroke-linecap="round" stroke-linejoin="round" opacity="0.95"/>
                            <path d="M43.2 23.8 A10.6 10.6 0 0 1 44 39.5 L39.5 39.5" fill="none" stroke="#FFFFFF" stroke-width="2.8" stroke-linecap="round" stroke-linejoin="round" opacity="0.95"/>
                            <circle cx="26.4" cy="28.2" r="1.8" fill="#FFFFFF" opacity="0.95"/>
                            <circle cx="37.6" cy="35.8" r="1.8" fill="#FFFFFF" opacity="0.95"/>
                            <rect x="28.6" y="20.8" width="6.8" height="22.4" rx="1.2" fill="#FFFFFF" filter="url(#shadow)"/>
                            <rect x="20.8" y="28.6" width="22.4" height="6.8" rx="1.2" fill="#FFFFFF" filter="url(#shadow)"/>
                        </svg>
                    </div>
                    <div>
                        <h1 class="text-2xl font-bold bg-gradient-to-r from-purple-600 to-blue-600 bg-clip-text text-transparent">Gestion des Spécialistes</h1>
                        <p class="text-sm text-gray-600 mt-1">Liste et gestion des médecins spécialistes</p>
                    </div>
                </div>

                <div class="flex items-center gap-4">
                    <%
                        Object _u = session.getAttribute("user");
                        if (_u != null) {
                            try {
                                Medcen _med = (Medcen) _u;
                    %>
                    <div class="flex items-center gap-3 bg-gradient-to-r from-purple-50 to-blue-50 rounded-lg px-4 py-2 border border-purple-100">
                        <div class="w-10 h-10 rounded-full bg-gradient-to-br from-purple-500 to-blue-500 flex items-center justify-center text-white font-semibold shadow-md">
                            <%= (_med.getNomComplet() != null && !_med.getNomComplet().isEmpty()) ? _med.getNomComplet().substring(0,1).toUpperCase() : "A" %>
                        </div>
                        <div class="text-left">
                            <p class="text-xs text-gray-500">Administrateur</p>
                            <p class="text-sm font-semibold text-gray-800"><%= _med.getNomComplet() %></p>
                        </div>
                    </div>
                    <%
                            } catch (Exception ignore) {}
                        }
                    %>

                    <a href="<%= request.getContextPath() %>/logout"
                       class="px-4 py-2 rounded-lg bg-white hover:bg-gray-50 text-gray-700 text-sm font-medium shadow-sm border border-gray-200 transition-all hover:shadow-md">
                        Déconnexion
                    </a>
                </div>
            </div>
        </header>

        <!-- Grid layout: sidebar + main -->
        <div class="grid grid-cols-1 lg:grid-cols-4 gap-6">

            <!-- Sidebar -->
            <aside class="lg:col-span-1">
                <nav class="backdrop-blur-sm bg-white/80 rounded-2xl shadow-lg border border-white/50 p-6 sticky top-6">
                    <h2 class="text-sm font-semibold text-gray-500 uppercase tracking-wide mb-4">Navigation</h2>

                    <ul class="space-y-2">
                        <li>
                            <a href="<%= request.getContextPath() %>/admin/create"
                               class="group flex items-center gap-3 px-4 py-3 rounded-xl text-gray-700 hover:bg-purple-50 transition-all">
                                <svg class="w-5 h-5 text-gray-600" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v4M8 8h8M5 21v-2a4 4 0 014-4h6a4 4 0 014 4v2"/>
                                </svg>
                                <span class="font-medium">Ajouter User</span>
                            </a>
                        </li>
                        <li>
                            <a href="<%= request.getContextPath() %>/admin/infirmier"
                               class="group flex items-center gap-3 px-4 py-3 rounded-xl text-gray-700 hover:bg-purple-50 transition-all">
                                <svg class="w-5 h-5 text-gray-600" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                                </svg>
                                <span class="font-medium">Infirmiers</span>
                            </a>
                        </li>
                        <li>
                            <a href="<%= request.getContextPath() %>/admin/generaliste"
                               class="group flex items-center gap-3 px-4 py-3 rounded-xl text-gray-700 hover:bg-blue-50 transition-all">
                                <svg class="w-5 h-5 text-gray-600" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                                </svg>
                                <span class="font-medium">Généralistes</span>
                            </a>
                        </li>
                        <li>
                            <a href="<%= request.getContextPath() %>/admin/specialiste"
                               class="group flex items-center gap-3 px-4 py-3 rounded-xl bg-gradient-to-r from-purple-500 to-blue-500 text-white shadow-md transition-all hover:shadow-lg">
                                <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z"/>
                                </svg>
                                <span class="font-medium">Spécialistes</span>
                            </a>
                        </li>
                    </ul>

                    <div class="mt-6 pt-6 border-t border-gray-200">
                        <p class="text-xs font-medium text-gray-500 mb-3">Statistiques Spécialistes</p>
                        <div class="space-y-2">
                            <%
                                List<Medcen> allSpecialistes = (List<Medcen>) request.getAttribute("specialistes");
                                int totalSpecialistes = allSpecialistes != null ? allSpecialistes.size() : 0;
                            %>
                            <div class="flex items-center justify-between text-sm">
                                <span class="text-gray-600">Total spécialistes</span>
                                <span class="font-semibold text-purple-600"><%= totalSpecialistes %></span>
                            </div>
                            <div class="flex items-center justify-between text-sm">
                                <span class="text-gray-600">Dernier ajout</span>
                                <span class="font-semibold text-blue-600">
                                    <%
                                        if (totalSpecialistes > 0 && allSpecialistes.get(0).getId() != null) {
                                            out.print(allSpecialistes.get(0).getId());
                                        } else {
                                            out.print("--");
                                        }
                                    %>
                                </span>
                            </div>
                        </div>
                    </div>
                </nav>
            </aside>

            <!-- Main -->
            <main class="lg:col-span-3">
                <!-- Success/Error Messages -->
                <%
                    String error = (String) request.getAttribute("error");
                    String success = (String) request.getAttribute("success");

                    if (error != null) {
                %>
                <div class="mb-6 p-4 bg-red-50 border border-red-200 rounded-xl shadow-sm">
                    <div class="flex items-center">
                        <svg class="w-5 h-5 text-red-400 mr-3" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"/>
                        </svg>
                        <span class="text-red-700 text-sm font-medium"><%= error %></span>
                    </div>
                </div>
                <%
                    }

                    if (success != null) {
                %>
                <div class="mb-6 p-4 bg-green-50 border border-green-200 rounded-xl shadow-sm">
                    <div class="flex items-center">
                        <svg class="w-5 h-5 text-green-400 mr-3" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
                        </svg>
                        <span class="text-green-700 text-sm font-medium"><%= success %></span>
                    </div>
                </div>
                <%
                    }
                %>

                <!-- Header Actions -->
                <div class="flex items-center justify-between mb-6">
                    <div>
                        <h2 class="text-xl font-bold text-gray-900">Liste des Spécialistes</h2>
                        <p class="text-sm text-gray-600 mt-1">Gérez les médecins spécialistes de votre établissement</p>
                    </div>
                    <a href="<%= request.getContextPath() %>/admin/create"
                       class="px-4 py-2.5 bg-gradient-to-r from-purple-500 to-blue-500 hover:from-purple-600 hover:to-blue-600 text-white font-medium rounded-xl shadow-lg hover:shadow-xl transition-all flex items-center gap-2">
                        <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                        </svg>
                        Nouveau Spécialiste
                    </a>
                </div>

                <!-- Spécialistes Table -->
                <div class="backdrop-blur-sm bg-white/80 rounded-2xl shadow-lg border border-white/50 overflow-hidden">
                    <div class="px-6 py-4 border-b border-gray-200 bg-gradient-to-r from-purple-50 to-blue-50">
                        <div class="flex items-center justify-between">
                            <div>
                                <h3 class="text-lg font-bold text-gray-900">Médecins Spécialistes</h3>
                                <p class="text-sm text-gray-600 mt-1"><%= totalSpecialistes %> spécialiste(s) trouvé(s)</p>
                            </div>
                            <div class="flex items-center gap-3">
                                <div class="relative">
                                    <input type="text" placeholder="Rechercher un spécialiste..."
                                           class="pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-400 focus:border-transparent text-sm">
                                    <svg class="w-5 h-5 text-gray-400 absolute left-3 top-2" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                                    </svg>
                                </div>
                                <button class="px-3 py-2 border border-gray-300 rounded-lg bg-white hover:bg-gray-50 text-sm font-medium transition-all">
                                    Filtres
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">ID</th>
                                <th class="px-6 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Spécialiste</th>
                                <th class="px-6 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Contact</th>
                                <th class="px-6 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Spécialité</th>
                                <th class="px-6 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Tarif</th>
                                <th class="px-6 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Rôle</th>
                            </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-100">
                            <%
                                List<Medcen> specialistes = (List<Medcen>) request.getAttribute("specialistes");
                                if (specialistes != null && !specialistes.isEmpty()) {
                                    for (Medcen specialiste : specialistes) {
                                        // Cast to Specialiste to access specialty and tariff
                                        String specialite = "Non spécifiée";
                                        Double tarif = 0.0;
                                        if (specialiste instanceof io.github.Mahjoubech.clinicalink.entity.Specialiste) {
                                            io.github.Mahjoubech.clinicalink.entity.Specialiste spec = (io.github.Mahjoubech.clinicalink.entity.Specialiste) specialiste;
                                            specialite = spec.getSpecialite() != null ? spec.getSpecialite() : "Non spécifiée";
                                            tarif = spec.getTarif();
                                        }
                            %>
                            <tr class="hover:bg-purple-50 transition-colors">
                                <td class="px-6 py-4 whitespace-nowrap text-sm font-mono text-gray-600">
                                    <%= specialiste.getId() != null ? specialiste.getId() : "N/A" %>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <div class="flex items-center gap-3">
                                        <div class="w-10 h-10 rounded-full bg-gradient-to-br from-indigo-400 to-purple-400 flex items-center justify-center text-white text-sm font-semibold shadow-md">
                                            <%= (specialiste.getNomComplet() != null && !specialiste.getNomComplet().isEmpty()) ? specialiste.getNomComplet().substring(0,1).toUpperCase() : "S" %>
                                        </div>
                                        <div class="text-left">
                                            <p class="text-sm font-medium text-gray-900"><%= specialiste.getNomComplet() %></p>
                                            <p class="text-xs text-gray-500">ID: <%= specialiste.getId() != null ? specialiste.getId() : "N/A" %></p>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <div class="text-sm text-gray-900"><%= specialiste.getEmail() %></div>
                                    <div class="text-sm text-gray-500"><%= specialiste.getTele() != null ? specialiste.getTele() : "Non renseigné" %></div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-indigo-100 text-indigo-800">
                                        <%= specialite %>
                                    </span>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                    <%= tarif %> MAD
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-purple-100 text-purple-800">
                                        <%= specialiste.getRole() != null ? specialiste.getRole().name() : "SPECIALISTE" %>
                                    </span>
                                </td>
                            </tr>
                            <%
                                }
                            } else {
                            %>
                            <tr>
                                <td colspan="6" class="px-6 py-12 text-center">
                                    <svg class="mx-auto h-16 w-16 text-gray-400" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z"/>
                                    </svg>
                                    <p class="mt-4 text-lg font-medium text-gray-900">Aucun spécialiste trouvé</p>
                                    <p class="mt-2 text-sm text-gray-500">Commencez par ajouter votre premier médecin spécialiste.</p>
                                    <a href="<%= request.getContextPath() %>/admin/create"
                                       class="mt-4 inline-flex items-center gap-2 px-4 py-2 bg-gradient-to-r from-purple-500 to-blue-500 text-white font-medium rounded-lg hover:shadow-lg transition-all">
                                        <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                                        </svg>
                                        Ajouter le premier spécialiste
                                    </a>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <div class="px-6 py-4 border-t border-gray-200 bg-gray-50">
                        <div class="flex items-center justify-between">
                            <div class="text-sm text-gray-700">
                                Affichage de <span class="font-medium">1</span> à <span class="font-medium"><%= totalSpecialistes %></span> sur <span class="font-medium"><%= totalSpecialistes %></span> résultats
                            </div>
                            <div class="flex items-center gap-2">
                                <button class="px-3 py-1 border border-gray-300 rounded-md bg-white text-sm font-medium text-gray-700 hover:bg-gray-50">
                                    Précédent
                                </button>
                                <button class="px-3 py-1 border border-gray-300 rounded-md bg-white text-sm font-medium text-gray-700 hover:bg-gray-50">
                                    Suivant
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

            </main>
        </div>
    </div>
</div>

</body>
</html>