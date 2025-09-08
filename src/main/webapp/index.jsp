<%-- 
    Document   : index
    Created on : 8 Sept 2025, 1:04:00 am
    Author     : musta
--%>

<%@page contentType="text/html" pageEncoding="UTF-8" language="java"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Home — HealAt.Home</title>
        <meta name="viewport" content="width=device-width,initial-scale=1"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"/>
    </head>
    <body>
        <header class="site-header">
            <div class="container">
                <div class="brand">
                    <i class="fas fa-leaf"></i>
                    <h1><span class="brand-first">HealAt.</span><span class="brand-second-option2">Home</span></h1>
                </div>
                <nav class="nav">
                    <a href="${pageContext.request.contextPath}/">Home</a>
                    <a href="${pageContext.request.contextPath}/search">Search</a>
                    <a href="${pageContext.request.contextPath}/addRemedy">Add Remedy</a>
                    <a href="${pageContext.request.contextPath}/favorites">Favorites</a>
                    <a href="${pageContext.request.contextPath}/login.jsp">Login</a>
                    <a href="${pageContext.request.contextPath}/register.jsp">Register</a>
                    <a href="${pageContext.request.contextPath}/logout">Logout</a>

                </nav>
            </div>

            <c:choose>
                <c:when test="${not empty sessionScope.userId}">
                    Welcome, ${sessionScope.username}! 
                    <a href="logout">Logout</a>
                </c:when>
                <c:otherwise>
                    <a href="login.jsp">Login</a> | <a href="register.jsp">Register</a>
                </c:otherwise>
            </c:choose>

        </header>

        <main class="container hero">
            <h2>Natural care is often the gentlest care</h2>
            <p>Find tested home remedies for everyday problems — colds, skin issues, digestion, and more.</p>
            <div class="hero-actions">
                <a class="btn" href="${pageContext.request.contextPath}/search?q=cold">Remedies for Cold</a>
                <a class="btn outline" href="${pageContext.request.contextPath}/addRemedy">Share a Remedy</a>
            </div>

            <section class="slogans">
                <div class="card">
                    <h3>Safe & Natural</h3>
                    <p>Simple ingredients from your kitchen and garden.</p>
                </div>
                <div class="card">
                    <h3>Community Tested</h3>
                    <p>Real experiences from users — practical, everyday tips.</p>
                </div>
                <div class="card">
                    <h3>Easy to Try</h3>
                    <p>Most remedies are low-cost and easy to make.</p>
                </div>
            </section> 



            <br><br><br>

            <section class="recent container">
                <h3>Quick Search</h3>
                <form action="${pageContext.request.contextPath}/search" method="get" class="search-form">
                    <input name="q" placeholder="Search remedies (example: Cold, Pimples, Hair, etc)"/>
                    <button class="btn" type="submit"><i class="fas fa-search"></i> Search</button>
                </form>
            </section>
        </main>

        <footer class="site-footer">
            <div class="container">
                <p>&copy; 2025 HealAt.Home - Noor Fatima</p>
            </div>
        </footer>
    </body>
</html>