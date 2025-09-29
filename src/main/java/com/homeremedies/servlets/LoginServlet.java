package com.homeremedies.servlets;

import com.homeremedies.util.DBUtil;
import com.homeremedies.util.PasswordUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String loginField = req.getParameter("email");
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        String actualLoginField = (username != null && !username.trim().isEmpty()) ? username : loginField;
        boolean isEmail = actualLoginField != null && actualLoginField.contains("@");

        if (actualLoginField == null || password == null
                || actualLoginField.trim().isEmpty() || password.trim().isEmpty()) {
            req.setAttribute("error", "Login credentials required.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        String sql = isEmail
                ? "SELECT id, name, email, password FROM users WHERE LOWER(email) = LOWER(?)"
                : "SELECT id, name, email, password FROM users WHERE LOWER(username) = LOWER(?)";

        try (Connection c = DBUtil.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, actualLoginField.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String dbPass = rs.getString("password");
                    
                    // Try BCrypt verification first (for hashed passwords)
                    // If that fails, try plain text comparison (for old passwords)
                    boolean isValid = false;
                    try {
                        isValid = PasswordUtil.verify(password, dbPass);
                    } catch (Exception e) {
                        // If BCrypt fails, it might be a plain text password
                        isValid = dbPass.equals(password);
                    }
                    
                    if (isValid) {
                        int userId = rs.getInt("id");
                        String name = rs.getString("name");
                        String email = rs.getString("email");

                        HttpSession session = req.getSession();
                        session.setAttribute("userId", userId);
                        session.setAttribute("userName", name);
                        session.setAttribute("userEmail", email);

                        resp.sendRedirect(req.getContextPath() + "/");
                        return;
                    }
                }
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }

        req.setAttribute("error", "Invalid login credentials.");
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }
}