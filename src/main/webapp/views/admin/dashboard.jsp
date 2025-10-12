<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, io.github.Mahjoubech.clinicalink.entity.Medcen" %>
<%
    HttpSession sessionCheck = request.getSession(false);
    if (sessionCheck == null || sessionCheck.getAttribute("admin") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
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
                        <h1 class="text-2xl font-bold bg-gradient-to-r from-purple-600 to-blue-600 bg-clip-text text-transparent">Panneau d'Administration</h1>
                        <p class="text-sm text-gray-600 mt-1">Gestion des utilisateurs du personnel médical</p>
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
                            <a href="<%= request.getContextPath() %>/admin/user/add"
                               class="group flex items-center gap-3 px-4 py-3 rounded-xl bg-gradient-to-r from-purple-500 to-blue-500 text-white shadow-md transition-all hover:shadow-lg">
                                <span class="font-medium">Ajouter Utilisateur</span>
                            </a>
                        </li>
                        <li>
                            <a href="<%= request.getContextPath() %>/admin/infirmier"
                               class="group flex items-center gap-3 px-4 py-3 rounded-xl text-gray-700 hover:bg-purple-50 transition-all">
                                <span class="font-medium">Infirmiers</span>
                            </a>
                        </li>
                        <li>
                            <a href="<%= request.getContextPath() %>/admin/generaliste"
                               class="group flex items-center gap-3 px-4 py-3 rounded-xl text-gray-700 hover:bg-blue-50 transition-all">
                                <span class="font-medium">Généralistes</span>
                            </a>
                        </li>
                        <li>
                            <a href="<%= request.getContextPath() %>/admin/specialiste"
                               class="group flex items-center gap-3 px-4 py-3 rounded-xl text-gray-700 hover:bg-indigo-50 transition-all">
                                <span class="font-medium">Spécialistes</span>
                            </a>
                        </li>
                    </ul>

                    <div class="mt-6 pt-6 border-t border-gray-200">
                        <p class="text-xs font-medium text-gray-500 mb-3">Statistiques</p>
                        <div class="space-y-2">
                            <div class="flex items-center justify-between text-sm">
                                <span class="text-gray-600">Total utilisateurs</span>
                                <span class="font-semibold text-purple-600">--</span>
                            </div>
                            <div class="flex items-center justify-between text-sm">
                                <span class="text-gray-600">Actifs ce mois</span>
                                <span class="font-semibold text-blue-600">--</span>
                            </div>
                        </div>
                    </div>
                </nav>
            </aside>

            <!-- Main -->
            <main class="lg:col-span-3">
                <!-- Error/Success Messages -->
                <%
                    String error = (String) request.getAttribute("error");
                    String success = (String) request.getAttribute("success");
                    java.util.Map<String, String> errors = (java.util.Map<String, String>) request.getAttribute("errors");

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
                <!-- Form Card -->
                <div class="backdrop-blur-sm bg-white/80 rounded-2xl shadow-lg border border-white/50 overflow-hidden mb-6">
                    <div class="bg-gradient-to-r from-blue-400 to-blue-500 px-6 py-4">
                        <h3 class="text-xl font-bold text-white">Créer un Nouveau Compte</h3>
                        <p class="text-blue-100 text-sm mt-1">Complétez le formulaire ci-dessous pour ajouter un membre du personnel</p>
                    </div>

                    <div class="p-6">
                        <form method="post" action="<%= request.getContextPath() %>/admin/create" class="space-y-6" onsubmit="return validateForm()">

                            <!-- Basic Information -->
                            <div>
                                <h4 class="text-sm font-semibold text-gray-700 mb-4 flex items-center gap-2">
                                    <div class="w-6 h-6 rounded-full bg-purple-100 flex items-center justify-center text-purple-600 text-xs font-bold">1</div>
                                    Informations de base
                                </h4>

                                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    <!-- Nom Field -->
                                    <div>
                                        <label for="nom" class="block text-sm font-medium text-gray-700 mb-2">Nom *</label>
                                        <input id="nom" name="nom" type="text"
                                               class="w-full px-4 py-3 border <%= errors != null && errors.containsKey("nom") ? "border-red-300" : "border-gray-300" %> rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-400 focus:border-transparent transition-all"
                                               placeholder="El-Mahjoubech"
                                               value="<%= request.getParameter("nom") != null ? request.getParameter("nom") : "" %>"/>
                                        <%
                                            if (errors != null && errors.containsKey("nom")) {
                                        %>
                                        <div class="error-message">
                                            <svg class="error-icon" fill="currentColor" viewBox="0 0 20 20">
                                                <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd"/>
                                            </svg>
                                            <%= errors.get("nom") %>
                                        </div>
                                        <%
                                            }
                                        %>
                                    </div>
                                    <!-- Prenom Field -->
                                    <div>
                                        <label for="prenom" class="block text-sm font-medium text-gray-700 mb-2">Prénom *</label>
                                        <input id="prenom" name="prenom" type="text"
                                               class="w-full px-4 py-3 border <%= errors != null && errors.containsKey("prenom") ? "border-red-300" : "border-gray-300" %> rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-400 focus:border-transparent transition-all"
                                               placeholder="Youssef"
                                               value="<%= request.getParameter("prenom") != null ? request.getParameter("prenom") : "" %>"/>
                                        <%
                                            if (errors != null && errors.containsKey("prenom")) {
                                        %>
                                        <div class="error-message">
                                            <svg class="error-icon" fill="currentColor" viewBox="0 0 20 20">
                                                <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd"/>
                                            </svg>
                                            <%= errors.get("prenom") %>
                                        </div>
                                        <%
                                            }
                                        %>
                                    </div>

                                    <!-- Email Field -->
                                    <div>
                                        <label for="email" class="block text-sm font-medium text-gray-700 mb-2">Adresse email *</label>
                                        <input id="email" name="email" type="email"
                                               class="w-full px-4 py-3 border <%= errors != null && errors.containsKey("email") ? "border-red-300" : "border-gray-300" %> rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-400 focus:border-transparent transition-all"
                                               placeholder="medecin@clinicalink.com"
                                               value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>"/>
                                        <%
                                            if (errors != null && errors.containsKey("email")) {
                                        %>
                                        <div class="error-message">
                                            <svg class="error-icon" fill="currentColor" viewBox="0 0 20 20">
                                                <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd"/>
                                            </svg>
                                            <%= errors.get("email") %>
                                        </div>
                                        <%
                                            }
                                        %>
                                    </div>

                                    <!-- Telephone Field -->
                                    <div>
                                        <label for="tele" class="block text-sm font-medium text-gray-700 mb-2">Téléphone</label>
                                        <input id="tele" name="tele" type="tel"
                                               class="w-full px-4 py-3 border <%= errors != null && errors.containsKey("tele") ? "border-red-300" : "border-gray-300" %> rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-400 focus:border-transparent transition-all"
                                               placeholder="+212 6X XX XX XX"
                                               value="<%= request.getParameter("tele") != null ? request.getParameter("tele") : "" %>"/>
                                        <%
                                            if (errors != null && errors.containsKey("tele")) {
                                        %>
                                        <div class="error-message">
                                            <svg class="error-icon" fill="currentColor" viewBox="0 0 20 20">
                                                <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd"/>
                                            </svg>
                                            <%= errors.get("tele") %>
                                        </div>
                                        <%
                                            }
                                        %>
                                    </div>

                                    <!-- Password Field -->
                                    <div>
                                        <label for="password" class="block text-sm font-medium text-gray-700 mb-2">Mot de passe *</label>
                                        <input id="password" name="password" type="password"  minlength="6"
                                               class="w-full px-4 py-3 border <%= errors != null && errors.containsKey("password") ? "border-red-300" : "border-gray-300" %> rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-400 focus:border-transparent transition-all"
                                               placeholder="Minimum 6 caractères"/>
                                        <%
                                            if (errors != null && errors.containsKey("password")) {
                                        %>
                                        <div class="error-message">
                                            <svg class="error-icon" fill="currentColor" viewBox="0 0 20 20">
                                                <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd"/>
                                            </svg>
                                            <%= errors.get("password") %>
                                        </div>
                                        <%
                                            }
                                        %>
                                    </div>

                                    <!-- Confirm Password Field -->
                                    <div>
                                        <label for="confirmPassword" class="block text-sm font-medium text-gray-700 mb-2">Confirmer mot de passe *</label>
                                        <input id="confirmPassword" name="confirmpassword" type="password"  minlength="6"
                                               class="w-full px-4 py-3 border <%= errors != null && errors.containsKey("confirmpassword") ? "border-red-300" : "border-gray-300" %> rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-400 focus:border-transparent transition-all"
                                               placeholder="Minimum 6 caractères"/>
                                        <%
                                            if (errors != null && errors.containsKey("confirmpassword")) {
                                        %>
                                        <div class="error-message">
                                            <svg class="error-icon" fill="currentColor" viewBox="0 0 20 20">
                                                <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd"/>
                                            </svg>
                                            <%= errors.get("confirmpassword") %>
                                        </div>
                                        <%
                                            }
                                        %>
                                    </div>
                                </div>
                            </div>

                            <!-- Role Selection -->
                            <div>
                                <h4 class="text-sm font-semibold text-gray-700 mb-4 flex items-center gap-2">
                                    <div class="w-6 h-6 rounded-full bg-blue-100 flex items-center justify-center text-blue-600 text-xs font-bold">2</div>
                                    Sélection du rôle *
                                </h4>

                                <!-- Radio inputs with labels wrapped together for CSS sibling selector -->
                                <div class="flex flex-wrap gap-3 mb-4">
                                    <div>
                                        <input type="radio" id="role-infirmier" name="role" value="INFIRMER" class="sr-only" required
                                            <%= "INFIRMIER".equals(request.getParameter("role")) ? "checked" : "" %>>
                                        <label for="role-infirmier" class="role-card">
                                            <div class="text-center">
                                                <svg class="w-6 h-6 mx-auto mb-2" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                                                </svg>
                                                <span class="font-medium text-sm">Infirmier</span>
                                            </div>
                                        </label>
                                    </div>

                                    <div>
                                        <input type="radio" id="role-generaliste" name="role" value="GENERALISTE" class="sr-only"
                                            <%= "GENERALISTE".equals(request.getParameter("role")) ? "checked" : "" %>>
                                        <label for="role-generaliste" class="role-card">
                                            <div class="text-center">
                                                <svg class="w-6 h-6 mx-auto mb-2" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                                                </svg>
                                                <span class="font-medium text-sm">Généraliste</span>
                                            </div>
                                        </label>
                                    </div>

                                    <div>
                                        <input type="radio" id="role-specialiste" name="role" value="SPECIALISTE" class="sr-only"
                                            <%= "SPECIALISTE".equals(request.getParameter("role")) ? "checked" : "" %>>
                                        <label for="role-specialiste" class="role-card">
                                            <div class="text-center">
                                                <svg class="w-6 h-6 mx-auto mb-2" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z"/>
                                                </svg>
                                                <span class="font-medium text-sm">Spécialiste</span>
                                            </div>
                                        </label>
                                    </div>
                                </div>

                                <!-- Role Error -->
                                <%
                                    if (errors != null && errors.containsKey("role")) {
                                %>
                                <div class="error-message mb-4">
                                    <svg class="error-icon" fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd"/>
                                    </svg>
                                    <%= errors.get("role") %>
                                </div>
                                <%
                                    }
                                %>

                                <!-- Specialist-only fields -->
                                <div id="specialist-fields" class="specialist-fields">
                                    <div class="bg-gradient-to-r from-indigo-50 to-purple-50 border border-indigo-200 rounded-xl p-5">
                                        <h5 class="text-sm font-semibold text-indigo-900 mb-4 flex items-center gap-2">
                                            <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                            </svg>
                                            Informations supplémentaires pour spécialiste
                                        </h5>
                                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                            <div>
                                                <label for="specialtySelect" class="block text-sm font-medium text-gray-700 mb-2">Spécialité</label>
                                                <select id="specialtySelect" name="specialty"
                                                        class="w-full px-4 py-3 border <%= errors != null && errors.containsKey("specialty") ? "border-red-300" : "border-gray-300" %> rounded-xl focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition-all bg-white">
                                                    <option value="">-- Sélectionner --</option>
                                                    <option value="Cardiologie" <%= "Cardiologie".equals(request.getParameter("specialty")) ? "selected" : "" %>>Cardiologie</option>
                                                    <option value="Pneumologie" <%= "Pneumologie".equals(request.getParameter("specialty")) ? "selected" : "" %>>Pneumologie</option>
                                                    <option value="Neurologie" <%= "Neurologie".equals(request.getParameter("specialty")) ? "selected" : "" %>>Neurologie</option>
                                                    <option value="Gastro-entérologie" <%= "Gastro-entérologie".equals(request.getParameter("specialty")) ? "selected" : "" %>>Gastro-entérologie</option>
                                                    <option value="Endocrinologie" <%= "Endocrinologie".equals(request.getParameter("specialty")) ? "selected" : "" %>>Endocrinologie</option>
                                                    <option value="Dermatologie" <%= "Dermatologie".equals(request.getParameter("specialty")) ? "selected" : "" %>>Dermatologie</option>
                                                    <option value="Rhumatologie" <%= "Rhumatologie".equals(request.getParameter("specialty")) ? "selected" : "" %>>Rhumatologie</option>
                                                    <option value="Psychiatrie" <%= "Psychiatrie".equals(request.getParameter("specialty")) ? "selected" : "" %>>Psychiatrie</option>
                                                    <option value="Néphrologie" <%= "Néphrologie".equals(request.getParameter("specialty")) ? "selected" : "" %>>Néphrologie</option>
                                                    <option value="Orthopédie" <%= "Orthopédie".equals(request.getParameter("specialty")) ? "selected" : "" %>>Orthopédie</option>
                                                </select>
                                                <%
                                                    if (errors != null && errors.containsKey("specialty")) {
                                                %>
                                                <div class="error-message">
                                                    <svg class="error-icon" fill="currentColor" viewBox="0 0 20 20">
                                                        <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd"/>
                                                    </svg>
                                                    <%= errors.get("specialty") %>
                                                </div>
                                                <%
                                                    }
                                                %>
                                            </div>

                                            <div>
                                                <label for="rate" class="block text-sm font-medium text-gray-700 mb-2">Tarif de consultation (MAD)</label>
                                                <input id="rate" name="rate" type="number" min="0" step="0.01"
                                                       class="w-full px-4 py-3 border <%= errors != null && errors.containsKey("rate") ? "border-red-300" : "border-gray-300" %> rounded-xl focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition-all"
                                                       placeholder="200.00"
                                                       value="<%= request.getParameter("rate") != null ? request.getParameter("rate") : "" %>"/>
                                                <%
                                                    if (errors != null && errors.containsKey("rate")) {
                                                %>
                                                <div class="error-message">
                                                    <svg class="error-icon" fill="currentColor" viewBox="0 0 20 20">
                                                        <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd"/>
                                                    </svg>
                                                    <%= errors.get("rate") %>
                                                </div>
                                                <%
                                                    }
                                                %>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Actions -->
                            <div class="flex items-center justify-between pt-4 border-t border-gray-200">
                                <button type="reset" class="px-5 py-2.5 rounded-xl border-2 border-gray-300 bg-white hover:bg-gray-50 text-gray-700 font-medium transition-all">Réinitialiser</button>
                                <button type="submit" class="px-6 py-2.5 rounded-xl bg-gradient-to-r from-blue-400 to-blue-500 hover:from-blue-500 hover:to-blue-600 text-white font-medium shadow-lg hover:shadow-xl transition-all">Créer l'utilisateur</button>
                            </div>
                        </form>
                    </div>
                </div>
                <!-- Users Table -->
                <div class="backdrop-blur-sm bg-white/80 rounded-2xl shadow-lg border border-white/50 overflow-hidden">
                    <div class="px-6 py-4 border-b border-gray-200">
                        <h3 class="text-lg font-bold text-gray-900">Utilisateurs Récents</h3>
                        <p class="text-sm text-gray-600 mt-1">Liste des derniers comptes créés</p>
                    </div>

                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Nom</th>
                                <th class="px-6 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Email</th>
                                <th class="px-6 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Rôle</th>
                                <th class="px-6 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Téléphone</th>
                            </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-100">
                            <%
                                List<Medcen> users = (List<Medcen>) request.getAttribute("users");
                                if (users != null && !users.isEmpty()) {
                                    for (Medcen u : users) {
                            %>
                            <tr class="hover:bg-purple-50 transition-colors">
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <div class="flex items-center gap-3">
                                        <div class="w-8 h-8 rounded-full bg-gradient-to-br from-purple-400 to-blue-400 flex items-center justify-center text-white text-sm font-semibold">
                                            <%= (u.getNomComplet() != null && !u.getNomComplet().isEmpty()) ? u.getNomComplet().substring(0,1).toUpperCase() : "U" %>
                                        </div>
                                        <span class="text-sm font-medium text-gray-900"><%= u.getNomComplet() %></span>
                                    </div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600"><%= u.getEmail() %></td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-purple-100 text-purple-800"><%= u.getRole() %></span>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600"><%= u.getTele() %></td>
                            </tr>
                            <%
                                }
                            } else {
                            %>
                            <tr>
                                <td colspan="4" class="px-6 py-12 text-center">
                                    <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4"/>
                                    </svg>
                                    <p class="mt-2 text-sm text-gray-500">Aucun utilisateur trouvé</p>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                            </tbody>
                        </table>
                    </div>
                </div>

            </main>
        </div>
    </div>
</div>

<!-- JavaScript for toggling specialist fields and styling role cards -->
<script>
    // Get all radio buttons and specialist fields container
    const radioButtons = document.querySelectorAll('input[name="role"]');
    const specialistFields = document.getElementById('specialist-fields');

    // Function to toggle specialist fields
    function toggleSpecialistFields() {
        const selectedRole = document.querySelector('input[name="role"]:checked');
        if (selectedRole && selectedRole.value === 'SPECIALISTE') {
            specialistFields.style.display = 'block';
        } else {
            specialistFields.style.display = 'none';
        }
    }

    // Add event listeners to all radio buttons
    radioButtons.forEach(radio => {
        radio.addEventListener('change', toggleSpecialistFields);
    });

    // Initial check on page load
    toggleSpecialistFields();
</script>

<style>
    /* Hide specialist fields by default */
    .specialist-fields {
        display: none;
        animation: slideDown 0.3s ease-out;
    }

    /* Slide down animation */
    @keyframes slideDown {
        from {
            opacity: 0;
            transform: translateY(-10px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    /* Role card styling */
    .role-card {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        width: 11rem;
        height: 7rem;
        border: 2px solid #e5e7eb;
        border-radius: 1rem;
        background: #ffffff;
        transition: all 0.2s ease;
        cursor: pointer;
        padding: 1rem;
    }

    .role-card:hover {
        border-color: #93c5fd;
        background: #dbeafe;
        transform: translateY(-4px);
        box-shadow: 0 8px 20px rgba(147, 197, 253, 0.2);
    }

    .role-card svg {
        stroke: #374151;
        transition: stroke 0.2s ease;
    }

    /* Selected role card - Blue 300 theme */
    input[type="radio"]:checked + .role-card {
        background: #93c5fd;
        border-color: #60a5fa;
        color: white;
        box-shadow: 0 10px 24px rgba(96, 165, 250, 0.3);
        transform: translateY(-4px);
    }

    input[type="radio"]:checked + .role-card svg {
        stroke: white;
    }

    input[type="radio"]:checked + .role-card span {
        color: white;
    }

    /* Hide radio inputs visually but keep them accessible */
    input.sr-only {
        position: absolute;
        width: 1px;
        height: 1px;
        padding: 0;
        margin: -1px;
        overflow: hidden;
        clip: rect(0, 0, 0, 0);
        white-space: nowrap;
        border-width: 0;
    }
    /* Error message styling */
    .error-message {
        color: #dc2626;
        font-size: 0.875rem;
        margin-top: 0.5rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .error-icon {
        width: 1rem;
        height: 1rem;
        flex-shrink: 0;
    }
</style>

</body>
</html>