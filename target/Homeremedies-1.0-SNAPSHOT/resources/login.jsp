<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8"/>
    <title>Login — HealAtHome</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css" />
</head>
<body>
    <div class="container form">
        <h2>Login</h2>

        <c:if test="${not empty requestScope.error}">
            <div class="card" style="border-left:4px solid #ef4444; padding:.75rem; margin-bottom:1rem;">
                ${requestScope.error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post" class="form">
            <label for="email">Email</label>
            <input id="email" name="email" type="email" required/>

            <label for="password">Password</label>
            <input id="password" name="password" type="password" required/>

            <div class="form-actions">
                <button class="btn" type="submit">Login</button>
                <a href="${pageContext.request.contextPath}/register.jsp" class="btn outline">Register</a>
            </div>
        </form>
    </div>
</body>
</html>
