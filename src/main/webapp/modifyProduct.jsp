<%@ page session="true" %> <!-- Enable session for this JSP page -->
<%@ page import="java.util.List" %> <!-- Import java.util.List for handling list of categories -->
<%
    // Retrieve the user attribute from the session
    String user = (String) session.getAttribute("user");
    // If the user is not logged in or not an admin, redirect to login page
    if (user == null || !user.equals("admin")) {
        response.sendRedirect("login.jsp"); // Redirect to login page
        return; // Exit the current page execution
    }
    // Retrieve the list of all categories from the request attribute
    List<String[]> categories = (List<String[]>) request.getAttribute("allCategories");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"> <!-- Define the character encoding for the HTML document -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> <!-- Ensure proper scaling and layout on mobile devices -->
    <title>Modify Product</title> <!-- Title of the page -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"> <!-- Bootstrap CSS -->
</head>
<body>
    <div class="container mt-5"> <!-- Main container with top margin -->
        <a href="adminDashboard.jsp" class="btn btn-secondary mb-3">Back</a> <!-- Back button to admin dashboard -->
        <h1 class="text-center">Modify Product</h1> <!-- Page heading centered -->
        <form method="post" action="DisplayServlet" enctype="multipart/form-data" class="mt-3"> <!-- Form to modify product, submitting to DisplayServlet with enctype for file upload -->
            <input type="hidden" name="action" value="modifyProduct"> <!-- Hidden input to specify the action as modifyProduct -->
            <div class="mb-3">
                <label for="id" class="form-label">Product ID:</label> <!-- Label for product ID input -->
                <input type="text" id="id" name="id" class="form-control" required> <!-- Input field for product ID -->
            </div>
            <div class="mb-3">
                <label for="name" class="form-label">New Name:</label> <!-- Label for new name input -->
                <input type="text" id="name" name="name" class="form-control" required> <!-- Input field for new name -->
            </div>
            <div class="mb-3">
                <label for="description" class="form-label">New Description:</label> <!-- Label for new description input -->
                <textarea id="description" name="description" class="form-control" required></textarea> <!-- Textarea for new description -->
            </div>
            <div class="mb-3">
                <label for="price" class="form-label">New Price:</label> <!-- Label for new price input -->
                <input type="text" id="price" name="price" class="form-control" required> <!-- Input field for new price -->
            </div>
            <div class="mb-3">
                <label for="weight" class="form-label">New Weight (kg):</label> <!-- Label for new weight input -->
                <input type="text" id="weight" name="weight" class="form-control" required> <!-- Input field for new weight -->
            </div>
            <div class="mb-3">
                <label for="category" class="form-label">Category:</label> <!-- Label for category select input -->
                <select id="category" name="category" class="form-control" required> <!-- Select input for category -->
                    <% if (categories != null) {
                        // Iterate over each category in the list
                        for (String[] category : categories) { %>
                            <option value="<%= category[0] %>"><%= category[1] %></option> <!-- Option for each category -->
                    <% }
                    } %>
                </select>
            </div>
            <div class="mb-3">
                <label for="image" class="form-label">Product Image:</label> <!-- Label for product image input -->
                <input type="file" id="image" name="image" class="form-control"> <!-- File input for product image -->
            </div>
            <button type="submit" class="btn btn-primary w-100">Modify Product</button> <!-- Submit button to modify product -->
        </form>
        <h2 class="mt-5">All Products</h2> <!-- Heading for the products table -->
        <table class="table table-striped mt-3"> <!-- Table to display all products with striped rows -->
            <thead>
                <tr>
                    <th>ID</th> <!-- Table header for product ID -->
                    <th>Name</th> <!-- Table header for product name -->
                    <th>Description</th> <!-- Table header for product description -->
                    <th>Price</th> <!-- Table header for product price -->
                    <th>Weight (kg)</th> <!-- Table header for product weight -->
                    <th>Category</th> <!-- Table header for product category -->
                    <th>Image</th> <!-- Table header for product image -->
                </tr>
            </thead>
            <tbody>
                <%
                    // Retrieve the list of all products from the request attribute
                    List<String[]> products = (List<String[]>) request.getAttribute("allProducts");
                    if (products != null) {
                        // Iterate over each product in the list
                        for (String[] product : products) {
                %>
                <tr>
                    <td><%= product[0] %></td> <!-- Display product ID -->
                    <td><%= product[1] %></td> <!-- Display product name -->
                    <td><%= product[4] %></td> <!-- Display product description -->
                    <td><%= product[2] %></td> <!-- Display product price -->
                    <td><%= product[5] %></td> <!-- Display product weight -->
                    <td><%= product[6] %></td> <!-- Display product category -->
                    <td><img src="<%= product[3] %>" alt="<%= product[1] %>" style="width: 50px; height: 50px;"></td> <!-- Display product image with specified size -->
                </tr>
                <%
                        }
                    }
                %>
            </tbody>
        </table>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script> <!-- Bootstrap JS -->
</body>
</html>
