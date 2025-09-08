package com.homeremedies.servlets;

import com.homeremedies.util.DBUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/addRemedy")
public class AddRemedyServlet extends HttpServlet {
    @Override
    protected void doPost (HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String category = req.getParameter("category");
        
        if (title == null || title.trim().isEmpty()) {
            req.setAttribute("error", "Title is required");
            req.getRequestDispatcher("/add.jsp").forward(req, resp);
            return;
            
        }
        
        String sql = "INSERT INTO remedies (title, description, category) VALUES (?, ?, ?)";
        try (Connection c = DBUtil.getConnection();
            PreparedStatement ps = c.prepareStatement(sql)) {
             ps.setString(1, title);
             ps.setString(2, description);
             ps.setString(3, category);
             ps.executeUpdate();
        } catch (SQLException e) {
            throw new ServletException(e);
        }
        resp.sendRedirect(req.getContextPath() + "/?added=true");
    }
    
    @Override
    protected void doGet (HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
        //show form
        req.getRequestDispatcher("/add.jsp").forward(req, resp);
    }
}