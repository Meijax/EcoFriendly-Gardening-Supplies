<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - Eco Gardening Supplies</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        main {
            flex: 1;
        }
        footer {
            background-color: #343a40;
            color: white;
        }
    </style>
</head>
<body>
    <!-- Navigation bar -->
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <div class="container-fluid">
            <!-- Brand logo -->
            <a class="navbar-brand" href="#">Eco Gardening</a>
            <!-- Toggle button for smaller screens -->
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <!-- Collapsible navbar links -->
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <!-- Home link -->
                        <a class="nav-link" href="${pageContext.request.contextPath}/">Home</a>
                    </li>
                    <li class="nav-item">
                        <!-- About link -->
                        <a class="nav-link" href="${pageContext.request.contextPath}/#about">About</a>
                    </li>
                    <li class="nav-item">
                        <!-- Products link -->
                        <a class="nav-link" href="${pageContext.request.contextPath}/#products">Products</a>
                    </li>
                    <li class="nav-item">
                        <!-- Blog link -->
                        <a class="nav-link" href="${pageContext.request.contextPath}/#blog">Blog</a>
                    </li>
                    <li class="nav-item">
                        <!-- Contact link -->
                        <a class="nav-link" href="${pageContext.request.contextPath}/#contact">Contact</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main content -->
    <main>
        <section id="checkout" class="py-5">
            <div class="container">
                <h2>Checkout</h2>
                <!-- JSP tag to check if the cart is not empty -->
                <c:choose>
                    <c:when test="${not empty sessionScope.cart}">
                        <!-- Display table if the cart is not empty -->
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Product</th>
                                    <th>Price</th>
                                    <th>Weight</th>
                                    <th>Remove</th>
                                </tr>
                            </thead>
                            <tbody>
                                <!-- Set initial total weight to 0 -->
                                <c:set var="totalWeight" value="0" scope="session"/>
                                <!-- Loop through the cart items -->
                                <c:forEach var="product" items="${sessionScope.cart}">
                                    <tr data-product-id="${product.id}">
                                        <td>${product.name}</td>
                                        <td>
                                            <!-- Format the price to currency -->
                                            <fmt:formatNumber value="${product.price}" type="currency" currencyCode="ZAR" pattern="ZAR #,##0.00"/>
                                        </td>
                                        <td>${product.weight} kg</td>
                                        <!-- Update total weight -->
                                        <c:set var="totalWeight" value="${sessionScope.totalWeight + product.weight}" scope="session"/>
                                        <td>
                                            <!-- Form to remove product from cart -->
                                            <form class="remove-from-cart-form" action="DisplayServlet" method="post">
                                                <input type="hidden" name="productId" value="${product.id}">
                                                <input type="hidden" name="action" value="remove">
                                                <button type="submit" class="btn btn-danger">Remove</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        <!-- Check if the user is logged in -->
                        <c:choose>
                            <c:when test="${not empty sessionScope.username}">
                                <!-- Form to proceed to payment if logged in -->
                                <form action="paymentDetails.jsp" method="post">
                                    <input type="hidden" name="action" value="placeOrder">
                                    <button type="submit" class="btn btn-success">Place Order</button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <!-- Prompt to login if not logged in -->
                                <a href="login.jsp" class="btn btn-primary">Login to Place Order</a>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <!-- Message if the cart is empty -->
                        <p>Your cart is empty.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>
    </main>
    
    <!-- Footer -->
    <footer class="bg-dark text-white text-center py-1">
        <div class="container">
            <p>&copy; 2024 Eco Gardening Supplies. All Rights Reserved.</p>
        </div>
    </footer>   
    
    <!-- Bootstrap and jQuery scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
    $(document).ready(function() {
        // Handle Remove from Cart form submission
        $('.remove-from-cart-form').submit(function(event) {
            event.preventDefault(); // Prevent the default form submission
            var $form = $(this);

            $.ajax({
                type: $form.attr('method'),
                url: $form.attr('action'),
                data: $form.serialize(),
                dataType: 'json',
                success: function(response) {
                    // Remove the product row from the table
                    var productId = $form.find('input[name="productId"]').val();
                    $('tr[data-product-id="' + productId + '"]').remove();

                    // Check if the cart is empty
                    if ($('tbody tr').length === 0) {
                        $('tbody').append('<tr><td colspan="3">Your cart is empty.</td></tr>');
                    }
                },
                error: function(xhr, status, error) {
                    console.error("Error: " + status + " " + error);
                }
            });
        });
    });
    </script>
</body>
</html>

