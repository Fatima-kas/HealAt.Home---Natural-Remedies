package com.homeremedies.servlets;

import com.homeremedies.util.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name  = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        if (name == null || email == null || password == null
            || name.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty()) {
            req.setAttribute("error", "All fields are required.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        String checkSql = "SELECT id FROM users WHERE email = ?";
        String insertSql = "INSERT INTO users (name, email, password) VALUES (?, ?, ?)";

        try (Connection c = DBUtil.getConnection()) {
            // check existing email
            try (PreparedStatement ps = c.prepareStatement(checkSql)) {
                ps.setString(1, email);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        req.setAttribute("error", "Email already registered.");
                        req.getRequestDispatcher("/register.jsp").forward(req, resp);
                        return;
                    }
                }
            }

            // insert user
            try (PreparedStatement ps = c.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, password); // TODO: hash in production
                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int userId = rs.getInt(1);
                        HttpSession session = req.getSession();
                        session.setAttribute("userId", userId);
                        session.setAttribute("userName", name);
                    }
                }
            }

            resp.sendRedirect(req.getContextPath() + "/");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
