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
            String sql = "SELECT id, title, description, category FROM remedies WHERE title LIKE ? OR description LIKE ? OR category LIKE ?";
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
                        results.add(row);
                    }
                }
            } catch (SQLException e) {
                throw new ServletException(e);
            }
        }

        req.setAttribute("query", q);
        req.setAttribute("results", results);
        req.getRequestDispatcher("/search.jsp").forward(req, resp);
    }
}
