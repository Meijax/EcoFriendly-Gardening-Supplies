<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <!-- Ensure proper rendering and touch zooming on mobile devices -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Blog Post</title>
    <!-- Include Bootstrap CSS from CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <!-- Back button to return to the admin dashboard -->
        <a href="adminDashboard.jsp" class="btn btn-secondary mb-3">Back</a>
        <h1 class="text-center">Add Blog Post</h1>
        <!-- Form to add a new blog post -->
        <form method="post" action="DisplayServlet">
            <!-- Hidden input to specify the action -->
            <input type="hidden" name="action" value="addBlogPost">
            <div class="mb-3">
                <!-- Input for blog post title -->
                <label for="title" class="form-label">Title:</label>
                <input type="text" id="title" name="title" class="form-control" required>
            </div>
            <div class="mb-3">
                <!-- Textarea for blog post content -->
                <label for="content" class="form-label">Content:</label>
                <textarea id="content" name="content" class="form-control" rows="5" required></textarea>
            </div>
            <div class="mb-3">
                <!-- Input for blog post author -->
                <label for="author" class="form-label">Author:</label>
                <input type="text" id="author" name="author" class="form-control" required>
            </div>
            <div class="mb-3">
                <!-- Input for optional link related to the blog post -->
                <label for="link" class="form-label">Link (optional):</label>
                <input type="text" id="link" name="link" class="form-control">
            </div>
            <!-- Submit button to add the blog post -->
            <button type="submit" class="btn btn-primary w-100">Add Blog Post</button>
        </form>
        <%
            // Check if there is an error message from the request
            String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null) {
        %>
        <!-- Display error message if there is one -->
        <div class="alert alert-danger mt-3"><%= errorMessage %></div>
        <%
            }
        %>
    </div>
    <!-- Include Bootstrap JS bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
