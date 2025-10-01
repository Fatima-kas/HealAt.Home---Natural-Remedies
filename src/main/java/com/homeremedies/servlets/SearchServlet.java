package com.homeremedies.servlets;

import com.homeremedies.util.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String q = req.getParameter("q");
        List<Map<String, Object>> results = new ArrayList<>();

        if (q != null && !q.trim().isEmpty()) {
            // Updated SQL to include ratings and filter by approved status
            String sql = "SELECT r.id, r.title, r.description, r.category, " +
                        "COALESCE(AVG(rr.rating), 0) as avg_rating, " +
                        "COUNT(rr.id) as rating_count " +
                        "FROM remedies r " +
                        "LEFT JOIN remedy_ratings rr ON r.id = rr.remedy_id " +
                        "WHERE (r.title LIKE ? OR r.description LIKE ? OR r.category LIKE ?) " +
                        "AND r.status = 'approved' " +
                        "GROUP BY r.id, r.title, r.description, r.category " +
                        "ORDER BY avg_rating DESC, rating_count DESC";
            
            try (Connection c = DBUtil.getConnection();
                 PreparedStatement ps = c.prepareStatement(sql)) {
                
                String like = "%" + q.trim() + "%";
                ps.setString(1, like);
                ps.setString(2, like);
                ps.setString(3, like);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> row = new HashMap<>();
                        row.put("id", rs.getInt("id"));
                        row.put("title", rs.getString("title"));
                        row.put("description", rs.getString("description"));
                        row.put("category", rs.getString("category"));
                        row.put("avg_rating", rs.getDouble("avg_rating"));
                        row.put("rating_count", rs.getInt("rating_count"));
                        results.add(row);
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
                throw new ServletException("Database error during search", e);
            }
        }

        req.setAttribute("query", q);
        req.setAttribute("results", results);
        req.getRequestDispatcher("/search.jsp").forward(req, resp);
    }
}