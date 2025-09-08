<%-- 
    Document   : add
    Created on : 8 Sept 2025, 1:35:33 am
    Author     : musta
--%>

<%@page contentType="text/html" pageEncoding="UTF-8" language="java"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8"/>
        <title>Add Remedy — HealAt.Home</title>
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
            <h2>Add / Suggest a Remedy</h2>

            <form action="${pageContext.request.contextPath}/addRemedy" method="post" class="form">
                <label>Title <input name="title" required/></label>
                <label>Description <textarea name="description" rows="6"></textarea></label>

                <div class="form-actions">
                    <button class="btn" type="submit">Save</button>
                    <a class="btn outline" href="${pageContext.request.contextPath}/">Cancel</a>
                </div>
            </form>
        </main>
    </body>
</html>
