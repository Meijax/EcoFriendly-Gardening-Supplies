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
    <title>Admin Dashboard</title>
    <!-- Include Bootstrap CSS from CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <!-- Logout button -->
        <a href="DisplayServlet?action=logout" class="btn btn-secondary mb-3">Logout</a>
        <h1 class="text-center">Welcome, Admin</h1>
        <!-- List of admin actions -->
        <div class="list-group mt-5">
            <!-- Link to add a product -->
            <a href="DisplayServlet?action=addProduct" class="list-group-item list-group-item-action">Add Product</a>
            <!-- Link to modify a product -->
            <a href="DisplayServlet?action=modifyProduct" class="list-group-item list-group-item-action">Modify Product</a>
            <!-- Link to remove a product -->
            <a href="DisplayServlet?action=removeProduct" class="list-group-item list-group-item-action">Remove Product</a>
            <!-- Link to add a category -->
            <a href="addCategory.jsp" class="list-group-item list-group-item-action">Add Category</a>
            <!-- Link to add a blog post -->
            <a href="addBlogPost.jsp" class="list-group-item list-group-item-action">Add Blog Post</a>
            <!-- Link to view contact messages -->
            <a href="DisplayServlet?action=viewContactMessages" class="list-group-item list-group-item-action">View Contact Messages</a>
            <!-- New link to view orders -->
            <a href="DisplayServlet?action=viewOrders" class="list-group-item list-group-item-action">View Orders</a>
        </div>
    </div>
    <!-- Include Bootstrap JS bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
