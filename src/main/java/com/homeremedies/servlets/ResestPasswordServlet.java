package com.homeremedies.servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/ResetPasswordServlet")
public class ResestPasswordServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // ✅ Change DB details
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/homeremedies";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASS = "root";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String token = request.getParameter("token");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (password == null || !password.equals(confirmPassword)) {
            response.getWriter().println("Passwords do not match.");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS)) {
                // 1️⃣ Check if token exists
                String checkSql = "SELECT email FROM users WHERE reset_token=?";
                PreparedStatement checkPs = con.prepareStatement(checkSql);
                checkPs.setString(1, token);
                ResultSet rs = checkPs.executeQuery();

                if (rs.next()) {
                    String email = rs.getString("email");

                    // 2️⃣ Update password & clear token
                    String updateSql = "UPDATE users SET password=?, reset_token=NULL WHERE email=?";
                    PreparedStatement updatePs = con.prepareStatement(updateSql);
                    updatePs.setString(1, password); // ⚠️ In real projects, hash the password (e.g., BCrypt)
                    updatePs.setString(2, email);

                    int rows = updatePs.executeUpdate();
                    if (rows > 0) {
                        response.getWriter().println("Password reset successfully! You can now log in.");
                    } else {
                        response.getWriter().println("Error updating password.");
                    }
                } else {
                    response.getWriter().println("Invalid or expired token.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
