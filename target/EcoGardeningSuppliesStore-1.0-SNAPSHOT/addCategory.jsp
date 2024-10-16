<%@ page session="true" %>
<%@ page import="java.util.List" %>
<%
    // Retrieve the user from the session
    String user = (String) session.getAttribute("user");
    // If the user is not logged in or not an admin, redirect to login page
    if (user == null || !user.equals("admin")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <!-- Ensure proper rendering and touch zooming on mobile devices -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Category</title>
    <!-- Include Bootstrap CSS from CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <!-- Back button to return to the admin dashboard -->
        <a href="adminDashboard.jsp" class="btn btn-secondary mb-3">Back</a>
        <h1 class="text-center">Add New Category</h1>
        <!-- Form to add a new category -->
        <form method="post" action="DisplayServlet" class="mt-3">
            <!-- Hidden input to specify the action -->
            <input type="hidden" name="action" value="addCategory">
            <div class="mb-3">
                <!-- Input for category name -->
                <label for="category" class="form-label">Category Name:</label>
                <input type="text" id="category" name="category" class="form-control" required>
            </div>
            <!-- Submit button to add the category -->
            <button type="submit" class="btn btn-primary w-100">Add Category</button>
        </form>
        <% if (request.getAttribute("message") != null) { %>
            <!-- Display message if there is one -->
            <div class="alert alert-info mt-3"><%= request.getAttribute("message") %></div>
        <% } %>
    </div>
    <!-- Include Bootstrap JS bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
