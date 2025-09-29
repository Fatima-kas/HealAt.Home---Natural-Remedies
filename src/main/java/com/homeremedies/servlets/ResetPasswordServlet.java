package com.homeremedies.servlets;

import com.homeremedies.util.DBUtil;
import com.homeremedies.util.PasswordUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.time.Instant;

@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");
        String password = req.getParameter("password");
        String confirm = req.getParameter("confirmPassword");

        if (token == null || password == null || confirm == null || !password.equals(confirm)) {
            req.setAttribute("error", "Passwords do not match or invalid request.");
            req.setAttribute("token", token);
            req.getRequestDispatcher("/reset-password.jsp").forward(req, resp);
            return;
        }

        if (password.length() < 6) {
            req.setAttribute("error", "Password must be at least 6 characters.");
            req.setAttribute("token", token);
            req.getRequestDispatcher("/reset-password.jsp").forward(req, resp);
            return;
        }

        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);

            // lock the token row to avoid race conditions
            PreparedStatement ps = conn.prepareStatement(
                    "SELECT id, user_id, expires_at, used FROM password_reset_tokens WHERE token = ? FOR UPDATE");
            ps.setString(1, token);
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) {
                conn.rollback();
                req.setAttribute("error", "Invalid or expired reset link.");
                req.getRequestDispatcher("/reset-password.jsp").forward(req, resp);
                return;
            }

            int tokenId = rs.getInt("id");
            int userId = rs.getInt("user_id");
            boolean used = rs.getBoolean("used");
            Timestamp expiresAt = rs.getTimestamp("expires_at");

            if (used || expiresAt.toInstant().isBefore(Instant.now())) {
                conn.rollback();
                req.setAttribute("error", "This reset link has expired or already been used.");
                req.getRequestDispatcher("/reset-password.jsp").forward(req, resp);
                return;
            }

            // Hash and update password
            String hashed = PasswordUtil.hash(password);
            PreparedStatement updUser = conn.prepareStatement("UPDATE users SET password_hash = ? WHERE id = ?");
            updUser.setString(1, hashed);
            updUser.setInt(2, userId);
            updUser.executeUpdate();

            // mark token used
            PreparedStatement mark = conn.prepareStatement("UPDATE password_reset_tokens SET used = true WHERE id = ?");
            mark.setInt(1, tokenId);
            mark.executeUpdate();

            conn.commit();

            // forward to success page or login
            req.setAttribute("message", "Password updated. You can now log in.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Server error.");
            req.getRequestDispatcher("/reset-password.jsp").forward(req, resp);
        }
    }
}
