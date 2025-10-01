package com.homeremedies.servlets;

import com.homeremedies.util.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/submitRating")
public class SubmitRatingServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // require logged in user
        HttpSession session = req.getSession(false);
        Object uidObj = (session == null) ? null : session.getAttribute("userId");
        if (uidObj == null) {
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().write("{\"success\":false, \"message\":\"login_required\"}");
            return;
        }

        int userId, remedyId, rating;
        try {
            userId = Integer.parseInt(uidObj.toString());
            remedyId = Integer.parseInt(req.getParameter("remedyId"));
            rating = Integer.parseInt(req.getParameter("rating"));
            if (rating < 1 || rating > 5) throw new NumberFormatException();
        } catch (Exception e) {
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().write("{\"success\":false, \"message\":\"invalid_input\"}");
            return;
        }

        String upsert = "INSERT INTO remedy_ratings (remedy_id, user_id, rating) VALUES (?, ?, ?) " +
                        "ON DUPLICATE KEY UPDATE rating = VALUES(rating), updated_at = CURRENT_TIMESTAMP";
        String avgSql = "SELECT AVG(rating) AS avg_rating, COUNT(*) AS cnt FROM remedy_ratings WHERE remedy_id = ?";

        try (Connection conn = DBUtil.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(upsert)) {
                ps.setInt(1, remedyId);
                ps.setInt(2, userId);
                ps.setInt(3, rating);
                ps.executeUpdate();
            }

            double avg = 0.0; int cnt = 0;
            try (PreparedStatement ps2 = conn.prepareStatement(avgSql)) {
                ps2.setInt(1, remedyId);
                try (ResultSet rs = ps2.executeQuery()) {
                    if (rs.next()) {
                        avg = rs.getDouble("avg_rating");
                        cnt = rs.getInt("cnt");
                    }
                }
            }

            resp.setContentType("application/json;charset=UTF-8");
            String json = String.format("{\"success\":true, \"avg\":%.2f, \"count\":%d, \"userRating\":%d}", avg, cnt, rating);
            resp.getWriter().write(json);
        } catch (SQLException ex) {
            ex.printStackTrace();
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().write("{\"success\":false, \"message\":\"db_error\"}");
        }
    }
}
