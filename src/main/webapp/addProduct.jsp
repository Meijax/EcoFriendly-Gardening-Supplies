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
    // Retrieve the list of all categories from the request
    List<String[]> categories = (List<String[]>) request.getAttribute("allCategories");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <!-- Ensure proper rendering and touch zooming on mobile devices -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Product</title>
    <!-- Include Bootstrap CSS from CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <!-- Back button to return to the admin dashboard -->
        <a href="adminDashboard.jsp" class="btn btn-secondary mb-3">Back</a>
        <h1 class="text-center">Add Product</h1>
        <!-- Form to add a new product -->
        <form method="post" action="DisplayServlet" enctype="multipart/form-data" class="mt-3">
            <!-- Hidden input to specify the action -->
            <input type="hidden" name="action" value="addProduct">
            <div class="mb-3">
                <!-- Input for product name -->
                <label for="name" class="form-label">Name:</label>
                <input type="text" id="name" name="name" class="form-control" required>
            </div>
            <div class="mb-3">
                <!-- Textarea for product description -->
                <label for="description" class="form-label">Description:</label>
                <textarea id="description" name="description" class="form-control" required></textarea>
            </div>
            <div class="mb-3">
                <!-- Input for product price -->
                <label for="price" class="form-label">Price:</label>
                <input type="text" id="price" name="price" class="form-control" required>
            </div>
            <div class="mb-3">
                <!-- Input for product weight -->
                <label for="weight" class="form-label">Weight (kg):</label>
                <input type="text" id="weight" name="weight" class="form-control" required>
            </div>
            <div class="mb-3">
                <!-- Dropdown for product category -->
                <label for="category" class="form-label">Category:</label>
                <select id="category" name="category" class="form-control" required>
                    <% if (categories != null) {
                        // Loop through each category and create an option element
                        for (String[] category : categories) { %>
                            <option value="<%= category[0] %>"><%= category[1] %></option>
                    <% }
                    } %>
                </select>
            </div>
            <div class="mb-3">
                <!-- Input for product image -->
                <label for="image" class="form-label">Product Image:</label>
                <input type="file" id="image" name="image" class="form-control" required>
            </div>
            <!-- Submit button to add the product -->
            <button type="submit" class="btn btn-primary w-100">Add Product</button>
        </form>
        <h2 class="mt-5">All Products</h2>
        <!-- Table to display all products -->
        <table class="table table-striped mt-3">
            <thead>
                <tr>
                    <!-- Table headers -->
                    <th>ID</th>
                    <th>Name</th>
                    <th>Description</th>
                    <th>Price</th>
                    <th>Weight (kg)</th>
                    <th>Category</th>
                    <th>Image</th>
                </tr>
            </thead>
            <tbody>
                <%
                    // Retrieve the list of all products from the request
                    List<String[]> products = (List<String[]>) request.getAttribute("allProducts");
                    if (products != null) {
                        // Loop through each product and create a table row
                        for (String[] product : products) {
                %>
                <tr>
                    <!-- Display product details -->
                    <td><%= product[0] %></td>
                    <td><%= product[1] %></td>
                    <td><%= product[4] %></td>
                    <td><%= product[2] %></td>
                    <td><%= product[5] %></td>
                    <td><%= product[6] %></td>
                    <!-- Display product image -->
                    <td><img src="<%= product[3] %>" alt="<%= product[1] %>" style="width: 50px; height: 50px;"></td>
                </tr>
                <%
                        }
                    }
                %>
            </tbody>
        </table>
    </div>
    <!-- Include Bootstrap JS bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
