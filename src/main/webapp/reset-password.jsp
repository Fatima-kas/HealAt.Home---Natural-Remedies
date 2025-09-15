<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Reset Password</title>
</head>
<body>
    <h2>Reset Your Password</h2>

    <form action="ResetPasswordServlet" method="post">
        <!-- Hidden field for token -->
        <input type="hidden" name="token" value="<%= request.getParameter("token") %>" />

        <label for="password">New Password:</label><br>
        <input type="password" name="password" required /><br><br>

        <label for="confirmPassword">Confirm Password:</label><br>
        <input type="password" name="confirmPassword" required /><br><br>

        <input type="submit" value="Reset Password" />
    </form>
</body>
</html>
