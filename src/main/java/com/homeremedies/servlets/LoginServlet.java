package com.homeremedies.servlets;

import com.homeremedies.util.DBUtil;
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
        String email    = req.getParameter("email");
        String password = req.getParameter("password");

        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            req.setAttribute("error", "Email and password required.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        String sql = "SELECT id, name, password FROM users WHERE email = ?";
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String dbPass = rs.getString("password");
                    if (dbPass.equals(password)) { // TODO: use hashed password compare
                        int userId = rs.getInt("id");
                        String name = rs.getString("name");

                        HttpSession session = req.getSession();
                        session.setAttribute("userId", userId);
                        session.setAttribute("userName", name);

                        resp.sendRedirect(req.getContextPath() + "/");
                        return;
                    }
                }
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }

        req.setAttribute("error", "Invalid email or password.");
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }
}
