package com.homeremedies.servlets;

import com.homeremedies.util.DBUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/remedy")
public class RemedyDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("id");
        
        if (idParam == null || idParam.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/?error=Invalid remedy ID");
            return;
        }
        
        try {
            int remedyId = Integer.parseInt(idParam);
            Map<String, Object> remedyData = getRemedyDetails(remedyId);
            
            if (remedyData == null) {
                resp.sendRedirect(req.getContextPath() + "/?error=Remedy not found");
                return;
            }
            
            // Check if user is logged in to get their rating
            HttpSession session = req.getSession(false);
            Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;
            
            if (userId != null) {
                int userRating = getUserRating(remedyId, userId);
                req.setAttribute("userRating", userRating);
            }
            
            // Set remedy attributes
            req.setAttribute("remedy", remedyData);
            req.setAttribute("remedyId", remedyId);
            
            // Forward to JSP
            req.getRequestDispatcher("/remedy-detail.jsp").forward(req, resp);
            
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/?error=Invalid remedy ID format");
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Database error", e);
        }
    }
    
    private Map<String, Object> getRemedyDetails(int remedyId) throws SQLException {
        String sql = "SELECT r.id, r.title, r.description, r.category, " +
                    "COALESCE(AVG(rr.rating), 0) as avg_rating, " +
                    "COUNT(rr.id) as rating_count " +
                    "FROM remedies r " +
                    "LEFT JOIN remedy_ratings rr ON r.id = rr.remedy_id " +
                    "WHERE r.id = ? AND r.status = 'approved' " +
                    "GROUP BY r.id, r.title, r.description, r.category";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, remedyId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> remedy = new HashMap<>();
                    remedy.put("id", rs.getInt("id"));
                    remedy.put("title", rs.getString("title"));
                    remedy.put("description", rs.getString("description"));
                    remedy.put("category", rs.getString("category"));
                    remedy.put("avg_rating", rs.getDouble("avg_rating"));
                    remedy.put("rating_count", rs.getInt("rating_count"));
                    return remedy;
                }
            }
        }
        return null;
    }
    
    private int getUserRating(int remedyId, int userId) throws SQLException {
        String sql = "SELECT rating FROM remedy_ratings WHERE remedy_id = ? AND user_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, remedyId);
            ps.setInt(2, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("rating");
                }
            }
        }
        return 0;
    }
}