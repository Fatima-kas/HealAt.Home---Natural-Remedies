<%-- 
    Document   : search.jsp
    Created on : 8 Sept 2025, 1:23:01 am
    Author     : musta
--%>

<%@page contentType="text/html" pageEncoding="UTF-8" language="java"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8"/>
        <title>Search — HealAt.Home</title>
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

        <main class="container">
            <h2>Search results for: "<c:out value="${query}"/>"</h2>
            <form action="${pageContext.request.contextPath}/search" method="get" class="search-form">
                <input name="q" placeholder="Search remedies (example: Cold, Pimples, Hair, etc)"/>
                <button class="btn" type="submit"><i class="fas fa-search"></i> Search</button>
            </form>

            <c:choose>
                <c:when test="${empty results}">
                    <p>No search results found. Try another keyword or <a href="${pageContext.request.contextPath}/addRemedy">add a remedy</a>.</p>
                </c:when>
                <c:otherwise>
                    <div class="results-grid">
                        <c:forEach var="r" items="${results}">
                            <div class="remedy-card">
                                <h3><c:out value="${r.title}"/></h3>
                                <p class="category"><small><c:out value="${r.category}"/></small></p>
                                <p><c:out value="${r.description}"/></p>
                                <div class="actions">
                                    <a class="btn small" href="${pageContext.request.contextPath}/favorites?add=${r.id}">❤ Add Favorite</a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
            <p><a href="${pageContext.request.contextPath}/">Back to Home</a></p>
        </main>
    </body>
</html>