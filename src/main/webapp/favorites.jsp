<%-- 
    Document   : favorites
    Created on : 8 Sept 2025, 1:42:25 am
    Author     : musta
--%>

<%@page contentType="text/html" pageEncoding="UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8"/>
        <title>Favorites — HealAt.Home</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"/>
    </head>
    <body>
        <header class="site-header" id="header">
            <div class="container">
                <a href="${pageContext.request.contextPath}/" class="brand">
                    <i class="fas fa-leaf"></i>
                    <h1>
                        <span class="brand-first">HealAt.</span>
                        <span class="brand-second-option2">Home</span>
                    </h1>
                </a>

                <nav class="nav" id="mainNav">
                    <a href="${pageContext.request.contextPath}/">
                        <i class="fas fa-home"></i> Home
                    </a>
                    <a href="${pageContext.request.contextPath}/search">
                        <i class="fas fa-search"></i> Search
                    </a>
                    <a href="${pageContext.request.contextPath}/addRemedy">
                        <i class="fas fa-plus-circle"></i> Add Remedy
                    </a>
                    <a href="${pageContext.request.contextPath}/favorites" class="active">
                        <i class="fas fa-heart"></i> Favorites
                    </a>
                </nav>

                <div class="user-info">
                    <c:choose>
                        <c:when test="${not empty sessionScope.userId}">
                            <span>Welcome, <strong>${sessionScope.userName}</strong>!</span>
                            <a href="${pageContext.request.contextPath}/logout">
                                <i class="fas fa-sign-out-alt"></i> Logout
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login">
                                <i class="fas fa-sign-in-alt"></i> Login
                            </a>
                            <a href="${pageContext.request.contextPath}/register">
                                <i class="fas fa-user-plus"></i> Register
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>

                <button class="mobile-menu-btn" id="mobileMenuBtn" aria-label="Toggle mobile menu">
                    <span></span>
                    <span></span>
                    <span></span>
                </button>
            </div>
        </header>

        <main class="container">
            <h2>Your Favorites</h2>

            <c:choose>
                <c:when test="${empty favorites}">
                    <p>No Favorites yet. Browse <a href="${pageContext.request.contextPath}/search">remedies</a> and add some!</p>
                </c:when>
                <c:otherwise>
                    <div class="results-grid">
                        <c:forEach var="r" items="${favorites}">
                            <div class="remedy-card">
                                <h3><c:out value="${r.title}"/></h3>
                                <p><c:out value="${r.description}"/></p>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
    </body>
</html>
