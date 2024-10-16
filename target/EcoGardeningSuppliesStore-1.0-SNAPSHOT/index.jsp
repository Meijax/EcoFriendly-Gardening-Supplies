<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> <!-- Define the page language and character encoding -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> <!-- Import JSTL core tag library -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%> <!-- Import JSTL formatting tag library -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"> <!-- Define the character encoding for the HTML document -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> <!-- Ensure proper scaling and layout on mobile devices -->
    <title>Eco-Friendly Gardening Supplies</title> <!-- Title of the page -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"> <!-- Bootstrap CSS for styling -->
    <link rel="stylesheet" href="styles.css"> <!-- Link to an external CSS file for additional styles -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> <!-- jQuery library -->
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
                        <a class="nav-link" href="#home">Home</a> <!-- Home link -->
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#about">About</a> <!-- About link -->
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#products">Products</a> <!-- Products link -->
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="DisplayServlet?action=blogs">Blog</a> <!-- Blog link -->
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#contact">Contact</a> <!-- Contact link -->
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            User
                        </a> <!-- User dropdown menu -->
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                            <c:choose>
                                <c:when test="${not empty sessionScope.username}">
                                    <li><a class="dropdown-item" href="DisplayServlet?action=profile">Profile</a></li> <!-- Profile link for logged in user -->
                                    <li><a class="dropdown-item" href="DisplayServlet?action=logout">Logout</a></li> <!-- Logout link for logged in user -->
                                </c:when>
                                <c:otherwise>
                                    <li><a class="dropdown-item" href="login.jsp">Login</a></li> <!-- Login link for guest user -->
                                    <li><a class="dropdown-item" href="registration.jsp">Register</a></li> <!-- Register link for guest user -->
                                </c:otherwise>
                            </c:choose>
                        </ul>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="checkout.jsp">Cart</a> <!-- Cart link -->
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <header id="home" class="custom-header text-white text-center py-5"> <!-- Custom header section -->
        <div class="container">
            <h1>Welcome to Eco Gardening Supplies</h1> <!-- Main heading -->
            <p>Your source for sustainable gardening products</p> <!-- Subheading -->
        </div>
    </header>

    <!-- Notification Area -->
    <div id="notification" class="notification"></div> <!-- Notification div for showing messages -->
    
    <section id="products" class="py-5 bg-light"> <!-- Products section with light background -->
        <div class="container">
            <h2>Our Products</h2> <!-- Products section heading -->
            <!-- Loop through categorized products -->
            <c:forEach var="entry" items="${categorizedProducts}">
                <div class="card mb-3"> <!-- Card for each product category -->
                    <div class="card-header" id="heading-${entry.key}">
                        <h3 class="mb-0">
                            <button class="btn btn-category" type="button" data-bs-toggle="collapse" data-bs-target="#collapse-${entry.key}" aria-expanded="false" aria-controls="collapse-${entry.key}">
                                ${entry.key}
                            </button> <!-- Button to toggle collapse of products under this category -->
                        </h3>
                    </div>
                    <div id="collapse-${entry.key}" class="collapse" aria-labelledby="heading-${entry.key}" data-bs-parent="#products">
                        <div class="card-body">
                            <div class="row">
                                <!-- Loop through products under this category -->
                                <c:forEach var="product" items="${entry.value}">
                                    <div class="col-md-4"> <!-- Column for each product -->
                                        <div class="card">
                                            <img src="${product[3]}" alt="${product[1]}" class="product-img"> <!-- Product image -->
                                            <div class="card-body">
                                                <h5 class="card-title">${product[1]}</h5> <!-- Product title -->
                                                <p class="card-text">
                                                    <strong>ZAR <fmt:formatNumber value="${product[2]}" type="currency" currencyCode="ZAR" pattern="#,##0.00"/></strong> <!-- Product price -->
                                                </p>
                                                <p class="card-weight">Weight: <fmt:formatNumber value="${product[5]}" pattern="#,##0.00"/> kg</p> <!-- Product weight -->
                                                <p class="card-description">${product[4]}</p> <!-- Product description -->
                                                <form class="add-to-cart-form" action="DisplayServlet" method="post"> <!-- Form to add product to cart -->
                                                    <input type="hidden" name="productId" value="${product[0]}"> <!-- Hidden input for product ID -->
                                                    <input type="hidden" name="action" value="add"> <!-- Hidden input for action type -->
                                                    <button type="submit" class="btn btn-primary">Add to Cart</button> <!-- Add to Cart button -->
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </section>
    
    <section id="about" class="py-5"> <!-- About Us section -->
        <div class="container">
            <h2>About Us</h2> <!-- About Us section heading -->
            <p>We provide eco-friendly gardening supplies to help you maintain a sustainable garden.</p> <!-- Short about us description -->
            <p><button class="btn btn-primary" type="button" data-bs-toggle="collapse" data-bs-target="#aboutMore" aria-expanded="false" aria-controls="aboutMore">
                Read More
            </button></p> <!-- Button to toggle more about us information -->
            <div class="collapse" id="aboutMore">
                <div class="card card-body">
                    <h3>Our Mission</h3> <!-- Mission heading -->
                    <p>At Eco Gardening Supplies, our mission is to promote sustainable gardening practices that benefit both the environment and the community. We believe in providing high-quality, eco-friendly products that help gardeners cultivate beautiful, productive gardens while minimizing their ecological footprint.</p> <!-- Mission description -->

                    <h3>Our Products</h3> <!-- Products heading -->
                    <p>We offer a wide range of products designed to support sustainable gardening, including organic fertilizers, compost bins, rainwater harvesting systems, and native plants. Our products are carefully selected to ensure they meet our high standards for sustainability and effectiveness.</p> <!-- Products description -->

                    <h3>Why Choose Us?</h3> <!-- Why Choose Us heading -->
                    <ul>
                        <li><strong>Eco-Friendly Products:</strong> All our products are chosen for their sustainability and minimal impact on the environment.</li> <!-- First reason -->
                        <li><strong>Expert Advice:</strong> Our team of gardening experts is always available to provide advice and support to help you achieve your gardening goals.</li> <!-- Second reason -->
                        <li><strong>Community Focused:</strong> We believe in supporting our local community and work with local suppliers and organizations to promote sustainable gardening.</li> <!-- Third reason -->
                        <li><strong>Quality Guaranteed:</strong> We stand behind the quality of our products and offer a satisfaction guarantee on all purchases.</li> <!-- Fourth reason -->
                    </ul>

                    <h3>Get Involved</h3> <!-- Get Involved heading -->
                    <p>We are passionate about building a community of gardeners who share our commitment to sustainability. Join our newsletter, follow us on social media, and participate in our workshops and events to learn more about sustainable gardening and connect with like-minded individuals.</p> <!-- Get involved description -->

                    <h3>Contact Us</h3> <!-- Contact Us heading -->
                    <p>If you have any questions or need more information about our products and services, please don't hesitate to contact us. We are here to help you create a beautiful, sustainable garden that you can be proud of.</p> <!-- Contact us description -->
                </div>
            </div>
        </div>
    </section>

    <section id="contact" class="py-5 bg-light"> <!-- Contact Us section with light background -->
        <div class="container">
            <h2>Contact Us</h2> <!-- Contact Us section heading -->
            <!-- Check if messageReceived attribute is not empty -->
            <c:if test="${not empty messageReceived}">
                <div class="alert alert-success" role="alert">
                    Your message has been received. Thank you! <!-- Success message -->
                </div>
            </c:if>
            <form action="DisplayServlet" method="post"> <!-- Form to submit contact message -->
                <input type="hidden" name="action" value="contact"> <!-- Hidden input to specify action -->
                <div class="mb-3">
                    <label for="name" class="form-label">Name</label> <!-- Label for name input -->
                    <input type="text" class="form-control" id="name" name="name" required> <!-- Input field for name -->
                </div>
                <div class="mb-3">
                    <label for="email" class="form-label">Email</label> <!-- Label for email input -->
                    <input type="email" class="form-control" id="email" name="email" required> <!-- Input field for email -->
                </div>
                <div class="mb-3">
                    <label for="message" class="form-label">Message</label> <!-- Label for message textarea -->
                    <textarea class="form-control" id="message" name="message" rows="3" required></textarea> <!-- Textarea for message -->
                </div>
                <button type="submit" class="btn btn-primary">Submit</button> <!-- Submit button for form -->
            </form>
        </div>
    </section>

    <footer class="bg-dark text-white text-center py-1"> <!-- Footer with dark background and white text -->
        <div class="container">
            <p>&copy; 2024 Eco Gardening Supplies. All Rights Reserved.</p> <!-- Footer content -->
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script> <!-- Bootstrap JS bundle -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> <!-- jQuery library -->
<script>
$(document).ready(function() {
    // Handle Add to Cart form submission
    $('.add-to-cart-form').submit(function(event) {
        event.preventDefault(); // Prevent the default form submission
        var $form = $(this);

        $.ajax({
            type: $form.attr('method'),
            url: $form.attr('action'),
            data: $form.serialize(), // Serialize form data
            dataType: 'json',
            success: function(response) {
                // Show the notification message
                var notification = $('#notification');
                notification.text('Product added to cart successfully!');
                notification.addClass('show');

                // Hide the notification after 3 seconds
                setTimeout(function() {
                    notification.addClass('hide');
                    setTimeout(function() {
                        notification.removeClass('show hide');
                    }, 500); // Wait for the transition to complete
                }, 3000);

                // Reload the cart dropdown menu
                loadCartDropdown();
            },
            error: function(xhr, status, error) {
                console.error("Error: " + status + " " + error);
                var notification = $('#notification');
                notification.text('An error occurred while adding the product to the cart.');
                notification.addClass('show');

                // Hide the notification after 3 seconds
                setTimeout(function() {
                    notification.addClass('hide');
                    setTimeout(function() {
                        notification.removeClass('show hide');
                    }, 500); // Wait for the transition to complete
                }, 3000);
            }
        });
    });
});
</script>

</body>
</html>
