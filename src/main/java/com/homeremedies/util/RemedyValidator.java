package com.homeremedies.util;

import java.util.Arrays;
import java.util.List;
import java.util.regex.Pattern;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class RemedyValidator {
    
    // Dangerous substances/practices to flag
    private static final List<String> DANGEROUS_KEYWORDS = Arrays.asList(
        "bleach", "ammonia", "hydrogen peroxide drink", "battery acid",
        "gasoline", "kerosene", "turpentine", "antifreeze",
        "raw eggs", "unpasteurized milk", "miracle mineral",
        "colloidal silver large dose", "essential oil drink",
        "arsenic", "mercury", "lead", "cyanide", "lye",
        "drain cleaner", "toilet cleaner", "paint thinner"
    );
    
    // Medical procedures that require professional help
    private static final List<String> MEDICAL_PROCEDURES = Arrays.asList(
        "surgery", "incision", "cutting", "stitches",
        "injection", "intravenous", "catheter", "transplant",
        "biopsy", "endoscopy", "colonoscopy"
    );
    
    // Spam/promotional keywords
    private static final List<String> SPAM_KEYWORDS = Arrays.asList(
        "buy now", "click here", "limited offer", "100% guarantee",
        "www.", "http", ".com", ".net", ".org", "order now", 
        "call now", "free trial", "act now", "discount code"
    );
    
    private static final int MIN_DESCRIPTION_LENGTH = 20;
    private static final int MAX_DESCRIPTION_LENGTH = 5000;
    private static final int MIN_TITLE_LENGTH = 5;
    private static final int MAX_TITLE_LENGTH = 100;
    
    /**
     * Validates remedy content for safety and appropriateness
     * @param title Remedy title
     * @param description Remedy description
     * @return null if valid, error message if invalid
     */
    public static String validate(String title, String description) {
        if (title == null || description == null) {
            return "Title and description are required";
        }
        
        String titleLower = title.toLowerCase().trim();
        String descLower = description.toLowerCase().trim();
        String combined = titleLower + " " + descLower;
        
        // Length validation
        if (title.trim().length() < MIN_TITLE_LENGTH) {
            return "Title must be at least " + MIN_TITLE_LENGTH + " characters";
        }
        if (title.trim().length() > MAX_TITLE_LENGTH) {
            return "Title must not exceed " + MAX_TITLE_LENGTH + " characters";
        }
        if (description.trim().length() < MIN_DESCRIPTION_LENGTH) {
            return "Description must be at least " + MIN_DESCRIPTION_LENGTH + " characters";
        }
        if (description.trim().length() > MAX_DESCRIPTION_LENGTH) {
            return "Description must not exceed " + MAX_DESCRIPTION_LENGTH + " characters";
        }
        
        // Check for dangerous substances/practices
        for (String keyword : DANGEROUS_KEYWORDS) {
            if (combined.contains(keyword.toLowerCase())) {
                return "Your remedy contains potentially dangerous substances or practices. Please consult a healthcare professional instead.";
            }
        }
        
        // Check for medical procedures
        for (String procedure : MEDICAL_PROCEDURES) {
            if (combined.contains(procedure.toLowerCase())) {
                return "Medical procedures require professional healthcare providers. This platform is for home remedies only.";
            }
        }
        
        // Check for spam/promotional content
        for (String spam : SPAM_KEYWORDS) {
            if (combined.contains(spam.toLowerCase())) {
                return "Promotional or commercial content is not allowed. Please share genuine home remedies only.";
            }
        }
        
        // Check for excessive capitalization (likely spam)
        long upperCount = title.chars().filter(Character::isUpperCase).count();
        if (upperCount > title.length() * 0.7 && title.length() > 10) {
            return "Please use normal capitalization in your title.";
        }
        
        // Check for repeated characters (spam indicator)
        if (Pattern.compile("(.)\\1{4,}").matcher(combined).find()) {
            return "Please avoid excessive character repetition.";
        }
        
        // Check for minimum word count (quality control)
        String[] words = description.trim().split("\\s+");
        if (words.length < 10) {
            return "Please provide a more detailed description (at least 10 words).";
        }
        
        // Check for suspicious patterns
        if (Pattern.compile("\\d{10,}").matcher(combined).find()) {
            return "Please remove phone numbers or long numeric sequences.";
        }
        
        // All validations passed
        return null;
    }
    
    /**
     * Check if user should be allowed to submit based on their history
     * @param userId User ID
     * @param conn Database connection
     * @return true if user can submit, false otherwise
     */
    public static boolean canUserSubmit(int userId, Connection conn) {
        try {
            PreparedStatement ps = conn.prepareStatement(
                "SELECT COUNT(*) FROM remedies WHERE submitted_by = ? AND status = 'pending'"
            );
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int pendingCount = rs.getInt(1);
                // Limit to 5 pending submissions at a time
                return pendingCount < 5;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return true;
    }
    
    /**
     * Get the number of pending submissions for a user
     * @param userId User ID
     * @param conn Database connection
     * @return Number of pending submissions
     */
    public static int getPendingCount(int userId, Connection conn) {
        try {
            PreparedStatement ps = conn.prepareStatement(
                "SELECT COUNT(*) FROM remedies WHERE submitted_by = ? AND status = 'pending'"
            );
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}