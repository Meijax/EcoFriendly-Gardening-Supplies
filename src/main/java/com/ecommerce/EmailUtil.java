package com.ecommerce;

// Import necessary libraries for email functionality
import java.util.Properties;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

// This class is responsible for sending emails
public class EmailUtil {

    // Method to send an email
    public static void sendEmail(String to, String subject, String body) {
        // Define the email host, port, username, and password
        final String username = "your-email@example.com";
        final String password = "your-email-password";
        String host = "smtp.example.com";

        // Set properties for the email session
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", "587");

        // Create a new email session with authentication
        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        try {
            // Create a new email message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(username)); // Set the sender's email address
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to)); // Set the recipient's email address
            message.setSubject(subject); // Set the email subject
            message.setText(body); // Set the email body

            // Send the email
            Transport.send(message);

            System.out.println("Email sent successfully");

        } catch (MessagingException e) {
            throw new RuntimeException(e); // Throw an exception if there is an error
        }
    }
}
