<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> <!-- Define the page language and encoding -->
<%@ page import="java.sql.*" %> <!-- Import java.sql package for database operations -->
<%@ page import="javax.servlet.*" %> <!-- Import javax.servlet package for servlet operations -->
<%@ page import="javax.servlet.http.*" %> <!-- Import javax.servlet.http package for HTTP-specific operations -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"> <!-- Define the character encoding for the HTML document -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> <!-- Ensure proper scaling and layout on mobile devices -->
    <title>User Login - Eco-Friendly Gardening Supplies</title> <!-- Title of the page -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"> <!-- Bootstrap CSS for styling -->
    <link rel="stylesheet" href="styles.css"> <!-- Link to an external CSS file for additional styles -->
</head>
<body>
    <div class="container mt-5"> <!-- Main container with top margin -->
        <div class="row justify-content-center"> <!-- Center the row content -->
            <div class="col-md-6"> <!-- Set the column width to 6 out of 12 (centered) -->
                <h2 class="text-center">User Login</h2> <!-- Login form heading, centered -->
                <% 
                    // Retrieve errorMessage attribute from the request
                    String errorMessage = (String) request.getAttribute("errorMessage");
                    // If errorMessage is not null, display it in an alert box
                    if (errorMessage != null) { 
                %>
                <div class="alert alert-danger mt-3"><%= errorMessage %></div> <!-- Display error message if present -->
                <% } %>
                <form action="${pageContext.request.contextPath}/DisplayServlet" method="post" class="mt-3"> <!-- Form to handle user login, submitting to DisplayServlet -->
                    <input type="hidden" name="action" value="login"> <!-- Hidden input to specify action -->
                    <div class="mb-3">
                        <label for="username" class="form-label">Username:</label> <!-- Label for username input -->
                        <input type="text" id="username" name="username" class="form-control" value="" required> <!-- Input field for username -->
                    </div>
                    <div class="mb-3">
                        <label for="password" class="form-label">Password:</label> <!-- Label for password input -->
                        <input type="password" id="password" name="password" class="form-control" value="" required> <!-- Input field for password -->
                    </div>
                    <button type="submit" class="btn btn-primary w-100">Login</button> <!-- Submit button for login -->
                </form>
                <div class="text-center mt-3">
                    <a href="registration.jsp">Don't have an account? Register here</a> <!-- Link to registration page for users without an account -->
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script> <!-- Bootstrap JS bundle -->
</body>
</html>
