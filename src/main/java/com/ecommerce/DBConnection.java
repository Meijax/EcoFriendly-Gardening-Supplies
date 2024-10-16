package com.ecommerce;

// Import necessary libraries for database connection
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

// This class is responsible for establishing a connection to the database
public class DBConnection {

    // Define the database URL, username, and password
    private static final String URL = "jdbc:mysql://127.0.0.1:3306/mydatabase";
    private static final String USER = "root";
    private static final String PASSWORD = "B-Day29082001!";

    // Method to get a connection to the database
    public static Connection getConnection() {
        Connection connection = null;
        try {
            // Load the MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Establish the connection to the database
            connection = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace(); // Print the stack trace if an exception occurs
        }
        return connection; // Return the database connection
    }
}
