package com.homeremedies.servlets;

import com.homeremedies.util.EmailUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.UUID;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // ✅ Change these to match your DB
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/homeremedies";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASS = "root";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        System.out.println("Email received from form: " + email);

        if (email == null || email.isEmpty()) {
            response.getWriter().println("Please enter a valid email.");
            return;
        }

        try {
            // 1️⃣ Generate reset token
            String token = UUID.randomUUID().toString();

            // 2️⃣ Save token in DB (assuming you have a 'users' table with email + reset_token column)
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS)) {
                String sql = "UPDATE users SET reset_token=? WHERE email=?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, token);
                ps.setString(2, email);

                int rows = ps.executeUpdate();
                if (rows > 0) {
                    // 3️⃣ Create reset link
                    String resetLink = "http://localhost:8080/Homeremedies/resetpassword.jsp?token=" + token;

                    // 4️⃣ Send email
                    String subject = "Password Reset Request";
                    String message = "Hi,\n\nClick the link below to reset your password:\n" + resetLink;

                    EmailUtil.sendEmail(email, subject, message);

                    response.getWriter().println("A reset link has been sent to your email.");
                } else {
                    response.getWriter().println("No user found with this email.");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
