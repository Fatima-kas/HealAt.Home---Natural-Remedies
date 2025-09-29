package com.homeremedies.util;

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

public class EmailUtil {

    private static final String FROM_EMAIL = "healathome.notifications@gmail.com";
    private static final String FROM_EMAIL_PASSWORD = "neeaghxmwaihjzdm";

    public static void sendEmail(String toEmail, String subject, String body) throws Exception {
        System.out.println("=== Starting email send process ===");
        System.out.println("To: " + toEmail);
        System.out.println("Subject: " + subject);
        
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.starttls.required", "true");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        
        // Enable debug mode
        props.put("mail.debug", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                System.out.println("Authenticating with Gmail...");
                return new PasswordAuthentication(FROM_EMAIL, FROM_EMAIL_PASSWORD);
            }
        });
        
        // Enable debug output
        session.setDebug(true);

        try {
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(FROM_EMAIL, "Health@Home"));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail, false));
            msg.setSubject(subject);
            
            // CRITICAL FIX: Set content as HTML, not plain text
            msg.setContent(body, "text/html; charset=utf-8");
            msg.setSentDate(new java.util.Date());

            System.out.println("Attempting to send email...");
            Transport.send(msg);
            System.out.println("=== Email sent successfully! ===");
            
        } catch (MessagingException e) {
            System.err.println("=== EMAIL SEND FAILED ===");
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
            throw new Exception("Failed to send email: " + e.getMessage(), e);
        }
    }
}