package com.homeremedies.servlets;

import com.homeremedies.util.DBUtil;
import com.homeremedies.util.TokenUtil;
import com.homeremedies.util.EmailUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.ZoneId;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {
    private static final long TOKEN_EXPIRY_MINUTES = 60; // 1 hour

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        resp.setContentType("application/json;charset=UTF-8");

        if (email == null || email.trim().isEmpty()) {
            resp.getWriter().write("{\"status\":\"error\",\"message\":\"Please provide email\"}");
            return;
        }

        try (Connection conn = DBUtil.getConnection()) {
            // Find user id
            PreparedStatement psUser = conn.prepareStatement("SELECT id FROM users WHERE email = ?");
            psUser.setString(1, email);
            ResultSet rsUser = psUser.executeQuery();
            if (!rsUser.next()) {
                // Don't reveal existence — respond with generic message
                resp.getWriter().write("{\"status\":\"ok\",\"message\":\"If an account exists with this email, a reset link has been sent.\"}");
                return;
            }

            int userId = rsUser.getInt("id");

            // Insert token
            String token = TokenUtil.generateToken(32);
            LocalDateTime expiresAt = LocalDateTime.now(ZoneId.of("UTC")).plusMinutes(TOKEN_EXPIRY_MINUTES);

            PreparedStatement insert = conn.prepareStatement(
                    "INSERT INTO password_reset_tokens (user_id, token, expires_at, used) VALUES (?, ?, ?, ?)");
            insert.setInt(1, userId);
            insert.setString(2, token);
            insert.setTimestamp(3, Timestamp.valueOf(expiresAt));
            insert.setBoolean(4, false);
            insert.executeUpdate();

            // Build reset link
            String resetLink = buildAppUrl(req) + "/reset-password.jsp?token=" + token;

            String subject = "Reset your password";
            String body = "<p>To reset your password click the link below (valid for " + TOKEN_EXPIRY_MINUTES + " minutes):</p>"
                    + "<p><a href=\"" + resetLink + "\">Reset password</a></p>"
                    + "<p>If you did not request this, please ignore this message.</p>";

            // Send email (synchronous). Ensure EmailUtil is configured with SMTP credentials.
            EmailUtil.sendEmail(email, subject, body);

            resp.getWriter().write("{\"status\":\"ok\",\"message\":\"If an account exists with this email, a reset link has been sent.\"}");
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().write("{\"status\":\"error\",\"message\":\"Server error\"}");
        }
    }

    private String buildAppUrl(HttpServletRequest req) {
        // prefer forwarded headers if behind proxy; adapt if necessary
        String scheme = req.getScheme();
        String serverName = req.getServerName();
        int port = req.getServerPort();
        String context = req.getContextPath();
        String portPart = "";

        if ((scheme.equals("http") && port != 80) || (scheme.equals("https") && port != 443)) {
            portPart = ":" + port;
        }
        return scheme + "://" + serverName + portPart + context;
    }
}
