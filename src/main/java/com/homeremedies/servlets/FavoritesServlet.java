package com.homeremedies.servlets;

import com.homeremedies.util.DBUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/favorites")
public class FavoritesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        int userId = (int) session.getAttribute("userId");

        // Handle add favorite via ?add=<remedyId>
        String addId = req.getParameter("add");
        if (addId != null) {
            try {
                int remedyId = Integer.parseInt(addId);
                String insertSql = "INSERT INTO favorites (user_id, remedy_id) VALUES (?, ?)";
                try (Connection c = DBUtil.getConnection();
                     PreparedStatement ps = c.prepareStatement(insertSql)) {
                    ps.setInt(1, userId);
                    ps.setInt(2, remedyId);
                    ps.executeUpdate();
                } catch (SQLIntegrityConstraintViolationException ex) {
                    // duplicate or FK issue -> ignore safely
                } catch (SQLException e) {
                    throw new ServletException("Error inserting favorite", e);
                }
            } catch (NumberFormatException ignored) {}
            resp.sendRedirect(req.getContextPath() + "/favorites");
            return;
        }

        // List favorites for this user
        List<Map<String, Object>> favs = new ArrayList<>();
        String sql = "SELECT r.id, r.title, r.description, r.image_url, f.created_at " +
                     "FROM favorites f JOIN remedies r ON f.remedy_id = r.id " +
                     "WHERE f.user_id = ? ORDER BY f.created_at DESC";

        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("id", rs.getInt("id"));
                    m.put("title", rs.getString("title"));
                    m.put("description", rs.getString("description"));
                    m.put("image_url", rs.getString("image_url"));
                    m.put("created_at", rs.getTimestamp("created_at"));
                    favs.add(m);
                }
            }
        } catch (SQLException e) {
            throw new ServletException("Error fetching favorites", e);
        }

        req.setAttribute("favorites", favs);
        req.getRequestDispatcher("/favorites.jsp").forward(req, resp);
    }
}
