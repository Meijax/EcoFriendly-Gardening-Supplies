<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> <!-- Define the page language and encoding -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"> <!-- Define the character encoding for the HTML document -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> <!-- Ensure proper scaling and layout on mobile devices -->
    <title>User Registration - Eco-Friendly Gardening Supplies</title> <!-- Page title -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"> <!-- Bootstrap CSS for styling -->
    <link rel="stylesheet" href="styles.css"> <!-- Link to an external CSS file for additional styles -->
</head>
<body>
    <div class="container mt-5"> <!-- Bootstrap container with top margin -->
        <div class="row justify-content-center"> <!-- Center the row content -->
            <div class="col-md-6"> <!-- Set the column width to 6 out of 12 (centered) -->
                <h2 class="text-center">User Registration</h2> <!-- Registration form heading, centered -->
                <!-- Check if there's an error message to display -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger mt-3">${errorMessage}</div> <!-- Display error message if present -->
                </c:if>
                <form action="DisplayServlet?action=register" method="post" class="mt-3"> <!-- Form to handle user registration, submitting to DisplayServlet with action register -->
                    <div class="mb-3">
                        <label for="username" class="form-label">Username:</label> <!-- Label for username input -->
                        <!-- Input field for username, prefilled with previous input if available -->
                        <input type="text" id="username" name="username" class="form-control" value="${param.username != null ? param.username : ''}" required>
                    </div>
                    <div class="mb-3">
                        <label for="password" class="form-label">Password:</label> <!-- Label for password input -->
                        <input type="password" id="password" name="password" class="form-control" required> <!-- Input field for password -->
                    </div>
                    <div class="mb-3">
                        <label for="email" class="form-label">Email:</label> <!-- Label for email input -->
                        <!-- Input field for email, prefilled with previous input if available -->
                        <input type="email" id="email" name="email" class="form-control" value="${param.email != null ? param.email : ''}" required>
                    </div>
                    <button type="submit" class="btn btn-primary w-100">Register</button> <!-- Submit button to register -->
                </form>
                <div class="text-center mt-3">
                    <a href="login.jsp">Already have an account? Login here</a> <!-- Link to login page for users who already have an account -->
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script> <!-- Bootstrap JS bundle -->
</body>
</html>
