<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Register — HealAtHome</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css" />
</head>
<body>
    <div class="container form">
        <h2>Create account</h2>

        <c:if test="${not empty requestScope.error}">
            <div class="card" style="border-left:4px solid #ef4444; padding:.75rem; margin-bottom:1rem;">
                ${requestScope.error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="post" class="form">
            <label for="name">Name</label>
            <input id="name" name="name" type="text" required/>

            <label for="email">Email</label>
            <input id="email" name="email" type="email" required/>

            <label for="password">Password</label>
            <input id="password" name="password" type="password" required/>

            <div class="form-actions">
                <button class="btn" type="submit">Register</button>
                <a href="${pageContext.request.contextPath}/login.jsp" class="btn outline">Login</a>
            </div>
        </form>
    </div>
</body>
</html>
