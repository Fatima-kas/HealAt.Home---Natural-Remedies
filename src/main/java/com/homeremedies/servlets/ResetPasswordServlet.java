package com.homeremedies.servlets;

import com.homeremedies.util.DBUtil;
import com.homeremedies.util.PasswordUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");
        String password = req.getParameter("password");
        String confirm = req.getParameter("confirmPassword");

        if (token == null || token.trim().isEmpty()) {
            req.setAttribute("error", "Invalid reset link.");
            req.getRequestDispatcher("/reset-password.jsp").forward(req, resp);
            return;
        }

        if (password == null || confirm == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Password is required.");
            req.setAttribute("token", token);
            req.getRequestDispatcher("/reset-password.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(confirm)) {
            req.setAttribute("error", "Passwords do not match.");
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

            if (used) {
                conn.rollback();
                req.setAttribute("error", "This reset link has already been used. Please request a new one.");
                req.getRequestDispatcher("/reset-password.jsp").forward(req, resp);
                return;
            }
            
            if (expiresAt.getTime() < System.currentTimeMillis()) {
                conn.rollback();
                req.setAttribute("error", "This reset link has expired. Please request a new one.");
                req.getRequestDispatcher("/reset-password.jsp").forward(req, resp);
                return;
            }

            // Hash the password and update in the 'password' column
            String hashed = PasswordUtil.hash(password);
            PreparedStatement updUser = conn.prepareStatement("UPDATE users SET password = ? WHERE id = ?");
            updUser.setString(1, hashed);
            updUser.setInt(2, userId);
            int updated = updUser.executeUpdate();

            if (updated == 0) {
                conn.rollback();
                req.setAttribute("error", "User not found.");
                req.getRequestDispatcher("/reset-password.jsp").forward(req, resp);
                return;
            }

            // Mark token as used
            PreparedStatement mark = conn.prepareStatement("UPDATE password_reset_tokens SET used = true WHERE id = ?");
            mark.setInt(1, tokenId);
            mark.executeUpdate();

            conn.commit();

            req.setAttribute("message", "Password updated successfully! You can now log in with your new password.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Server error. Please try again later.");
            req.setAttribute("token", token);
            req.getRequestDispatcher("/reset-password.jsp").forward(req, resp);
        }
    }
}