package com.homeremedies.util;

public class EmailTest {
    public static void main(String[] args) {
        try {
            // Change this to your own email where you want to receive the test
            String toEmail = "kasshabana7@gmail.com";  
            String subject = "Test Email from Java App";
            String body = "Hello! 🎉 This is a test email sent from my Java app.";

            EmailUtil.sendEmail(toEmail, subject, body);

            System.out.println("✅ Test email sent successfully!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
