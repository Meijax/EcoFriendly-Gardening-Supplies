<%@ page session="true" %> <!-- Enable session for this JSP page -->
<%@ page import="java.util.List" %> <!-- Import java.util.List for handling list of products -->

<%
    // Retrieve the user attribute from the session
    String user = (String) session.getAttribute("user");
    // If the user is not logged in or not an admin, redirect to login page
    if (user == null || !user.equals("admin")) {
        response.sendRedirect("login.jsp"); // Redirect to login page
        return; // Exit the current page execution
    }
    // Retrieve the list of all products from the request attribute
    List<String[]> products = (List<String[]>) request.getAttribute("allProducts");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"> <!-- Character encoding for the HTML document -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> <!-- Responsive design meta tag -->
    <title>Remove Product</title> <!-- Title of the page -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"> <!-- Bootstrap CSS -->
</head>
<body>
    <div class="container mt-5"> <!-- Main container with top margin -->
        <a href="adminDashboard.jsp" class="btn btn-secondary mb-3">Back</a> <!-- Back button to admin dashboard -->
        <h1 class="text-center">Remove Product</h1> <!-- Page heading centered -->
        <form method="post" action="DisplayServlet" class="mt-3"> <!-- Form to remove product, submitting to DisplayServlet -->
            <input type="hidden" name="action" value="removeProduct"> <!-- Hidden input to specify the action as removeProduct -->
            <div class="mb-3">
                <label for="id" class="form-label">Product ID:</label> <!-- Label for product ID input -->
                <input type="text" id="id" name="id" class="form-control" required> <!-- Input field for product ID -->
            </div>
            <button type="submit" class="btn btn-danger w-100">Remove Product</button> <!-- Submit button to remove product -->
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
                    // Check if the products list is not null
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
