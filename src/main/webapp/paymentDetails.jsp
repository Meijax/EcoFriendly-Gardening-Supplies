<%@ page language="java" contentType="text/html; charset=UTF-8"%> <!-- Define the page language and character encoding -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> <!-- Import JSTL core tag library -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%> <!-- Import JSTL formatting tag library -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"> <!-- Define the character encoding for the HTML document -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> <!-- Ensure proper scaling and layout on mobile devices -->
    <title>Payment Details - Eco Gardening Supplies</title> <!-- Page title -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"> <!-- Bootstrap CSS for styling -->
    <style>
        .payment-container {
            display: flex;
            justify-content: space-between;
            padding: 2rem;
        }
        .payment-form {
            flex: 2;
            margin-right: 2rem;
        }
        .summary {
            flex: 1;
            border: 1px solid #ddd;
            padding: 1rem;
            border-radius: 5px;
        }
        .summary-footer {
            margin-top: 1rem;
            border-top: 1px solid #ddd;
            padding-top: 1rem;
        }
        footer {
            background-color: #343a40;
            color: white;
        }
    </style> <!-- Inline CSS for specific styles -->
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-light bg-light"> <!-- Navbar with Bootstrap classes -->
        <div class="container-fluid"> <!-- Container for navbar content -->
            <a class="navbar-brand" href="#">Eco Gardening</a> <!-- Navbar brand with link to home page -->
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span> <!-- Button to toggle navbar on small screens -->
            </button>
            <div class="collapse navbar-collapse" id="navbarNav"> <!-- Collapsible navbar content -->
                <ul class="navbar-nav ms-auto"> <!-- Navbar items aligned to the right -->
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/">Home</a> <!-- Home link -->
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/#about">About</a> <!-- About link -->
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/#products">Products</a> <!-- Products link -->
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/#blog">Blog</a> <!-- Blog link -->
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/#contact">Contact</a> <!-- Contact link -->
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="payment-container">
            <div class="payment-form">
                <h2>Enter your payment details</h2> <!-- Heading for the payment form -->
                <form id="paymentForm" action="${pageContext.request.contextPath}/DisplayServlet" method="post"> <!-- Form for payment details -->
                    <input type="hidden" name="action" value="placeOrder"> <!-- Hidden input to specify action -->
                    <div class="mb-3">
                        <label for="cardNumber" class="form-label">Card number</label> <!-- Label for card number input -->
                        <input type="text" class="form-control" id="cardNumber" name="cardNumber" required> <!-- Input field for card number -->
                    </div>
                    <div class="mb-3">
                        <label for="expiryDate" class="form-label">Expiry date (MM/YY)</label> <!-- Label for expiry date input -->
                        <input type="text" class="form-control" id="expiryDate" name="expiryDate" required> <!-- Input field for expiry date -->
                    </div>
                    <div class="mb-3">
                        <label for="cvc" class="form-label">CVC</label> <!-- Label for CVC input -->
                        <input type="text" class="form-control" id="cvc" name="cvc" required> <!-- Input field for CVC -->
                    </div>
                    <div class="mb-3">
                        <label for="address" class="form-label">Street address</label> <!-- Label for street address input -->
                        <input type="text" class="form-control" id="address" name="address" required> <!-- Input field for street address -->
                    </div>
                    <div class="mb-3">
                        <label for="address2" class="form-label">Apt, unit, suite, etc. (optional)</label> <!-- Label for address line 2 input -->
                        <input type="text" class="form-control" id="address2" name="address2"> <!-- Input field for address line 2 -->
                    </div>
                    <div class="mb-3">
                        <label for="city" class="form-label">City</label> <!-- Label for city input -->
                        <input type="text" class="form-control" id="city" name="city" required> <!-- Input field for city -->
                    </div>
                    <div class="mb-3">
                        <label for="state" class="form-label">State</label> <!-- Label for state input -->
                        <input type="text" class="form-control" id="state" name="state" required> <!-- Input field for state -->
                    </div>
                    <div class="mb-3">
                        <label for="zip" class="form-label">ZIP code</label> <!-- Label for ZIP code input -->
                        <input type="text" class="form-control" id="zip" name="zip" required> <!-- Input field for ZIP code -->
                    </div>
                    <button type="submit" class="btn btn-primary">Complete Order</button> <!-- Submit button for the form -->
                </form>
            </div>
            <div class="summary">
                <h3>Order Summary</h3> <!-- Heading for the order summary -->
                <ul class="list-group mb-3">
                    <!-- Iterate over the cart items stored in session -->
                    <c:forEach var="product" items="${sessionScope.cart}">
                        <li class="list-group-item d-flex justify-content-between">
                            <div>
                                <h6 class="my-0">${product.name}</h6> <!-- Display product name -->
                            </div>
                            <span class="text-muted"><fmt:formatNumber value="${product.price}" type="currency" currencyCode="ZAR" pattern="ZAR #,##0.00"/></span> <!-- Display product price formatted as currency -->
                        </li>
                    </c:forEach>
                </ul>
                <div class="summary-footer">
                    <ul class="list-group">
                        <li class="list-group-item d-flex justify-content-between">
                            <span>Total weight:</span> <!-- Label for total weight -->
                            <strong><fmt:formatNumber value="${sessionScope.totalWeight}" type="number" pattern="#,##0.00"/> kg</strong> <!-- Display total weight formatted as number -->
                        </li>
                        <li class="list-group-item d-flex justify-content-between">
                            <span>Weight-based shipping cost:</span> <!-- Label for shipping cost -->
                            <strong>ZAR <fmt:formatNumber value="${requestScope.weightCost}" type="number" pattern="#,##0.00" /></strong> <!-- Display shipping cost formatted as currency -->
                        </li>
                        <li class="list-group-item d-flex justify-content-between">
                            <span>Total:</span> <!-- Label for total cost -->
                            <strong>ZAR <fmt:formatNumber value="${requestScope.grandTotal}" type="number" pattern="#,##0.00"/></strong> <!-- Display total cost formatted as currency -->
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
                        
    <!-- Modal for order success message -->
    <div class="modal fade" id="orderSuccessModal" tabindex="-1" aria-labelledby="orderSuccessModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="orderSuccessModalLabel">Order Successful</h5> <!-- Modal title -->
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button> <!-- Close button for modal -->
                </div>
                <div class="modal-body">
                    Your order was successful! Please check your email for further communication. <!-- Modal body message -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-bs-dismiss="modal">OK</button> <!-- OK button to close modal -->
                </div>
            </div>
        </div>
    </div>

    <footer class="bg-dark text-white text-center py-1">
        <div class="container">
            <p>&copy; 2024 Eco Gardening Supplies. All Rights Reserved.</p> <!-- Footer content -->
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script> <!-- Bootstrap JS bundle -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> <!-- jQuery library -->
    <script>
        $(document).ready(function() {
            $('#paymentForm').on('submit', function(event) {
                event.preventDefault(); // Prevent default form submission
                $.ajax({
                    type: 'POST',
                    url: 'DisplayServlet',
                    data: $(this).serialize(), // Serialize form data
                    success: function(response) {
                        $('#orderSuccessModal').modal('show'); // Show success modal on success
                        $('#orderSuccessModal').on('hidden.bs.modal', function () {
                            window.location.href = '${pageContext.request.contextPath}/DisplayServlet'; // Redirect on modal close
                        });
                    },
                    error: function(xhr, status, error) {
                        alert('There was an error placing your order. Please try again.'); // Alert on error
                    }
                });
            });
        });
    </script> <!-- JavaScript for handling form submission and modal display -->
</body>
</html>
