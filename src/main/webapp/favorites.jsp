<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <title>Favorites — Natural Remedies</title>
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
                <a href="${pageContext.request.contextPath}/favorites" class="active">Favorites</a>

                <c:choose>
                    <c:when test="${not empty sessionScope.userId}">
                        <span style="margin-left:1rem;">Hello, ${sessionScope.userName}!</span>
                        <a href="${pageContext.request.contextPath}/logout">Logout</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login.jsp">Login</a>
                    </c:otherwise>
                </c:choose>
            </nav>
        </div>
    </header>

    <main class="container">
        <h2>Your Favorites</h2>

        <c:choose>
            <c:when test="${empty favorites}">
                <p>No favorites yet. Browse <a href="${pageContext.request.contextPath}/search">remedies</a> and add some!</p>
            </c:when>
            <c:otherwise>
                <div class="results-grid">
                    <c:forEach var="r" items="${favorites}">
                        <div class="remedy-card">
                            <h3><c:out value="${r.title}"/></h3>
                            <c:if test="${not empty r.image_url}">
                                <img src="${pageContext.request.contextPath}/${r.image_url}" alt="${r.title}" style="max-width:100%; border-radius:8px;"/>
                            </c:if>
                            <p><c:out value="${r.description}"/></p>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </main>
</body>
</html>
