<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <!-- Ensure proper rendering and touch zooming on mobile devices -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Blog - Eco-Friendly Gardening Supplies</title>
    <!-- Include Bootstrap CSS from CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Link to custom styles -->
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <!-- Navigation bar -->
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <div class="container-fluid">
            <!-- Brand logo -->
            <a class="navbar-brand" href="index.jsp">Eco Gardening</a>
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
                    <li class="nav-item">
                        <!-- Logout link -->
                        <a class="nav-link" href="DisplayServlet?action=logout">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Blog section -->
    <section id="blog" class="py-5">
        <div class="container">
            <h2>Blog</h2>
            <p>Read our latest articles on sustainable gardening practices.</p>
            <!-- Loop through the list of blogs -->
            <c:forEach var="blog" items="${blogs}">
                <div class="card mt-3">
                    <div class="card-body">
                        <!-- Blog title -->
                        <h5 class="card-title">${blog.title}</h5>
                        <!-- Blog author and creation date -->
                        <h6 class="card-subtitle mb-2 text-muted">By ${blog.author} on <fmt:formatDate value="${blog.createdAt}" pattern="MMM dd, yyyy"/></h6>
                        <!-- Blog content -->
                        <p class="card-text">${blog.content}</p>
                        <!-- Link to full blog -->
                        <a href="${blog.link}" target="_blank" class="card-link">View more</a>
                    </div>
                </div>
            </c:forEach>
        </div>
    </section>

    <!-- Footer -->
    <footer class="bg-dark text-white text-center py-1">
        <div class="container">
            <p>&copy; 2024 Eco Gardening Supplies. All Rights Reserved.</p>
        </div>
    </footer>

    <!-- Bootstrap JS bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
