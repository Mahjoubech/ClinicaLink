<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="/assets/head.jsp" />
<!doctype html>
<html lang="fr">
<body class="bg-gray-50 min-h-screen flex items-center justify-center px-4">
<div class="w-full max-w-md">
    <!-- GitHub Logo -->
    <div class="flex justify-center mb-6">
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

            <!-- outer ring -->
            <circle cx="32" cy="32" r="26" fill="url(#g)" />

            <!-- left link arc -->
            <path d="M20.8 40.2
           A10.6 10.6 0 0 1 20 24.5
           L24.5 24.5"
                  fill="none" stroke="#FFFFFF" stroke-width="2.8" stroke-linecap="round" stroke-linejoin="round" opacity="0.95"/>

            <!-- right link arc -->
            <path d="M43.2 23.8
           A10.6 10.6 0 0 1 44 39.5
           L39.5 39.5"
                  fill="none" stroke="#FFFFFF" stroke-width="2.8" stroke-linecap="round" stroke-linejoin="round" opacity="0.95"/>

            <!-- connector dots -->
            <circle cx="26.4" cy="28.2" r="1.8" fill="#FFFFFF" opacity="0.95"/>
            <circle cx="37.6" cy="35.8" r="1.8" fill="#FFFFFF" opacity="0.95"/>

            <!-- central medical cross (soft rounded look) -->
            <rect x="28.6" y="20.8" width="6.8" height="22.4" rx="1.2" fill="#FFFFFF" filter="url(#shadow)"/>
            <rect x="20.8" y="28.6" width="22.4" height="6.8" rx="1.2" fill="#FFFFFF" filter="url(#shadow)"/>
        </svg>    </div>

    <!-- Sign in heading -->
    <h1 class="text-2xl font-light text-center text-gray-800 mb-8">Sign in to ClinicaLink</h1>

    <!-- Login Form -->
    <div class="bg-white border border-gray-300 rounded-md p-6 shadow-sm">
        <form action="login" method="post">
            <!-- Username/Email -->
            <div class="mb-4">
                <label for="login" class="block text-sm font-medium text-gray-700 mb-2">
                    email address
                </label>
                <input
                        type="email"
                        id="login"
                        name="email"
                        placeholder="exmaple41@gmail.com"
                        class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                        autofocus
                >
            </div>

            <!-- Password -->
            <div class="mb-4">
                <div class="flex items-center justify-between mb-2">
                    <label for="password" class="block text-sm font-medium text-gray-700">
                        Password
                    </label>
                    <a href="#" class="text-sm text-blue-600 hover:underline">
                        Forgot password?
                    </a>
                </div>
                <input
                        type="password"
                        id="password"
                        name="password"
                        placeholder="Enter Password"
                        class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                >
            </div>
            <p class="text-red-600 text-sm mb-4">
                <% String errorMessage = (String) request.getAttribute("error");
                   if (errorMessage != null) { %>
                    <%= errorMessage %>
                <% } %>
            <!-- Sign in button -->
            <button
                    type="submit"
                    class="w-full bg-blue-300 hover:bg-blue-500 text-white font-medium py-2 px-4 rounded-md transition-colors"
            >
                Sign in
            </button>
        </form>
    </div>

    <!-- Divider -->
    <div class="relative my-6">
        <div class="absolute inset-0 flex items-center">
            <div class="w-full border-t border-gray-300"></div>
        </div>
        <div class="relative flex justify-center text-sm">
            <span class="px-2 bg-gray-50 text-gray-500">or</span>
        </div>
    </div>
</div>
</body></html>